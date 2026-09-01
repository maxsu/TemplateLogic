#!/usr/bin/env bash

[[ -z $1 ]] && echo "usage: ${0##*/} <script-under-test>" && exit 1

# validate test script
TEST_SCRIPT=$(realpath "$1")
[[ ! -f "$TEST_SCRIPT" ]] && echo "error: $TEST_SCRIPT is not a file" && exit 1
[[ ! -x "$TEST_SCRIPT" ]] && echo "error: $TEST_SCRIPT is not executable" && exit 1

# work inside a tempdir
tmp=$(mktemp -d)
cd "$tmp"

# cleanup on exit
trap 'rm -rf "$tmp"' EXIT

# setup test repository
git init -q repo && cd repo || exit 1
git config user.email t@t && git config user.name t
git commit -q --allow-empty -m 'feat: ✨ first thing'
git commit -q --allow-empty -m 'fix(core): 🐛 second thing'
git commit -q --allow-empty -m "Merge branch 'side thing'"
git commit -q --allow-empty -m 'chore: forgot the emoji'
FIRST_COMMIT=$(git rev-parse HEAD~3)

# setup message files
printf '# comment 1\n#comment 2\n   feat: ✨ trimmed subject   \nbody\n' >msg1
printf 'fix: 🐛 handle #42 case\n' >msg2
printf 'bad commit\n' >msg3

# test runner
TEST_NO=0 FAILED=0
run() {
	TEST_NO=$((TEST_NO + 1))
	local expected=$1 && shift
	out=$("$TEST_SCRIPT" "$@" 2>&1)
	code=$?
	[[ $code == "$expected" ]] && return
	FAILED=$((FAILED + 1))
	echo "${BASH_LINENO[0]}: FAIL  [$*] exit=$code expected=$expected"
	echo "$out"
}

# test failure cases
run 1 --message
run 1 --range
run 1 --
run 1 --frobnicate x
run 1 a b c

# test message mode
run 0 --message 'feat: ✨ add new thing'
run 0 -m 'fix(api.v2): 🐛 handle edge case'
run 0 -m 'feat: ✨ subject only\n\nbody ignored'
run 0 -m "Merge branch 'main' into dev"
run 0 -m 'Revert "feat: ✨ add thing"'
run 1 -m 'feat: add thing'
run 1 -m 'bad: ✨ nope'
run 1 -m 'feat:✨ no space'
run 1 -m 'feat: ✨ ab'
run 1 -m 'feat(API): ✨ upper scope'
run 1 -m 'feat: ✨ ab'
run 1 -m 'feat: ✨ ✨'
run 1 -m ''
run 1 -m
run 1 -m 'feat: ✨ add new thing' 'extra arg'

# test file mode
run 0 msg1
run 0 msg2
run 1 msg3
run 1 msg2 "extra arg"
run 1 /no/such/file

# test range mode
run 0 --range "$FIRST_COMMIT..HEAD~1"
run 1 -r "$FIRST_COMMIT..HEAD"
run 1 -r 'nope..nada'
run 1 -r 'HEAD..HEAD'

# report results
printf '%d passed, %d failed\n' $((TEST_NO - FAILED)) "$FAILED"
exit $((FAILED > 0))
