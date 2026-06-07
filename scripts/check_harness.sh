#!/usr/bin/env bash
# Mechanical validation of the harness's own invariants.
#
# Deliberately needs no language runtime — bash 3.2+ and POSIX tools
# (grep, sed, find, wc) only, so it runs in any sandbox or CI container.
# Exit 0 = harness is sound; exit 1 = violations (listed on stderr).
#
# This is the template's `make check` until a stack is wired; afterwards
# it runs as the `harness` target inside `make check` forever.

set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

AGENTS_LINE_BUDGET=120
FAIL=0

err() {
  if [ "$FAIL" -eq 0 ]; then echo "harness check FAILED:" >&2; fi
  FAIL=1
  echo "  - $1" >&2
}

# fm FILE KEY — value of "KEY:" inside the leading frontmatter block,
# empty if the file has no frontmatter or the key is absent.
fm() {
  awk -v key="$2" '
    NR==1 && $0!="---" {exit}
    NR>1 && $0=="---" {exit}
    index($0, key":")==1 {sub(/^[^:]*:[[:space:]]*/, ""); print; exit}
  ' "$1"
}

DATE_RE='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'

# --- 1. Required paths -------------------------------------------------------
for p in \
  AGENTS.md ARCHITECTURE.md CONTEXT.md \
  docs/PLANS.md \
  docs/design-docs/index.md docs/design-docs/core-beliefs.md \
  docs/exec-plans/active docs/exec-plans/completed \
  docs/exec-plans/tech-debt-tracker.md \
  docs/product-specs/index.md \
  docs/references/README.md docs/generated/README.md
do
  [ -e "$p" ] || err "missing required path: $p"
done

# --- 2. AGENTS.md line budget (a map, not a manual) --------------------------
if [ -f AGENTS.md ]; then
  lines=$(wc -l < AGENTS.md | tr -d ' ')
  if [ "$lines" -gt "$AGENTS_LINE_BUDGET" ]; then
    err "AGENTS.md is $lines lines — budget is $AGENTS_LINE_BUDGET"
  fi
fi

# --- 3. design-docs <-> index sync -------------------------------------------
if [ -f docs/design-docs/index.md ]; then
  for f in docs/design-docs/[0-9][0-9][0-9][0-9]-*.md; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    grep -qF "$name" docs/design-docs/index.md \
      || err "design-doc not in index.md: $name"
  done
  for link in $(grep -oE '\]\([0-9]{4}-[^)#]+\.md\)' docs/design-docs/index.md \
                | sed -E 's/^\]\(//; s/\)$//'); do
    [ -e "docs/design-docs/$link" ] \
      || err "design-docs/index.md links to missing file: $link"
  done
fi

# --- 4. product-specs <-> index sync ------------------------------------------
if [ -f docs/product-specs/index.md ]; then
  for f in docs/product-specs/*.md; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    [ "$name" = "index.md" ] && continue
    grep -qF "$name" docs/product-specs/index.md \
      || err "product spec not in index.md: $name"
  done
fi

# --- 5. Exec plans: naming + required sections --------------------------------
for state in active completed; do
  for f in docs/exec-plans/$state/*.md; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    case "$name" in
      [0-9][0-9][0-9][0-9]-*.md) : ;;
      *) err "exec plan not named NNNN-slug.md: $state/$name" ;;
    esac
    for section in '## Goal' '## Context' '## Plan' '## Validation'; do
      grep -q "^$section" "$f" \
        || err "exec plan $state/$name missing section: $section"
    done
  done
done

# --- 5b. Exec plans: lifecycle frontmatter (design-doc 0005) -------------------
# status: is canonical; the directory mirrors it. Substance freezes at close;
# frontmatter and decision-log entries stay live.
for state in active completed; do
  for f in docs/exec-plans/$state/*.md; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    status=$(fm "$f" status)
    case "$status" in
      draft|executing|blocked)
        [ "$state" = "active" ] \
          || err "plan $name: status '$status' but file is in completed/" ;;
      completed|superseded)
        [ "$state" = "completed" ] \
          || err "plan $name: status '$status' but file is in active/" ;;
      "") err "plan $state/$name: missing 'status:' frontmatter" ;;
      *)  err "plan $state/$name: unknown status '$status'" ;;
    esac
    fm "$f" created | grep -qE "$DATE_RE" \
      || err "plan $state/$name: missing or malformed 'created:' (YYYY-MM-DD)"
    if [ "$status" = "completed" ]; then
      fm "$f" completed | grep -qE "$DATE_RE" \
        || err "plan $name: status completed but no 'completed:' date"
    fi
    if [ "$status" = "superseded" ]; then
      fm "$f" superseded-by | grep -qE '^[0-9]{4}$' \
        || err "plan $name: status superseded but no 'superseded-by: NNNN'"
    fi
  done
done
# Open questions are resolved at close — they may not survive into completed/.
for f in docs/exec-plans/completed/*.md; do
  [ -e "$f" ] || continue
  if grep -qi '^## Open questions' "$f"; then
    err "completed plan $(basename "$f") still has '## Open questions' — resolve at close"
  fi
done

# --- 5c. Design docs: lifecycle frontmatter (design-doc 0005) ------------------
for f in docs/design-docs/[0-9][0-9][0-9][0-9]-*.md; do
  [ -e "$f" ] || continue
  name=$(basename "$f")
  status=$(fm "$f" status)
  case "$status" in
    accepted) : ;;
    superseded)
      fm "$f" superseded-by | grep -qE '^[0-9]{4}$' \
        || err "design-doc $name: status superseded but no 'superseded-by: NNNN'" ;;
    "") err "design-doc $name: missing 'status:' frontmatter" ;;
    *)  err "design-doc $name: unknown status '$status'" ;;
  esac
  fm "$f" date | grep -qE "$DATE_RE" \
    || err "design-doc $name: missing or malformed 'date:' (YYYY-MM-DD)"
done

# --- 6. Rules tier (design-doc 0004) ------------------------------------------
if [ -d .claude/rules ]; then
  found_rule=0
  for f in .claude/rules/*.md; do
    [ -e "$f" ] || continue
    found_rule=1
    name=$(basename "$f")
    case "$name" in
      [0-9][0-9]-*.md) : ;;
      *) err "rule not named NN-slug.md: .claude/rules/$name" ;;
    esac
    grep -q '^## Do not' "$f" \
      || err "rule missing '## Do not' section: .claude/rules/$name"
  done
  [ "$found_rule" -eq 1 ] || err ".claude/rules/ exists but contains no rules"
else
  err "missing required path: .claude/rules"
fi

# --- 7. Relative link integrity in all markdown --------------------------------
for md in *.md $(find docs -name '*.md'); do
  [ -e "$md" ] || continue
  dir=$(dirname "$md")
  for link in $(grep -oE '\]\([^)[:space:]]+\)' "$md" \
                | sed -E 's/^\]\(//; s/\)$//; s/#.*$//'); do
    [ -n "$link" ] || continue
    case "$link" in
      http://*|https://*|mailto:*) continue ;;
    esac
    [ -e "$dir/$link" ] || err "broken link in $md: $link"
  done
done

if [ "$FAIL" -eq 0 ]; then
  echo "harness check passed"
fi
exit "$FAIL"
