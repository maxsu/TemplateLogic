#!/usr/bin/env bun

const RE =
  /^(feat|fix|docs|style|refactor|perf|test|build|ci|chore)(\([a-z0-9][a-z0-9.-]*\))?:\s+\S*\p{Extended_Pictographic}\S*\s+.{3,}$/u

const usage = (): never => {
  console.error('usage: validate-commit-msg (-r <range> | -m <msg> | <file>)')
  process.exit(1)
}

const [mode = '', value = '', ...extra] = process.argv.slice(2)

extra.length == 0 || usage()

let subject_lines: string[] = []

switch (mode) {
  case '--range':
  case '-r':
    subject_lines = Bun.spawnSync(['git', 'log', '--format=%s', value]).stdout.toString().trim().split('\n')
    break

  case '--message':
  case '-m':
    subject_lines = [value.split('\n')[0]]
    break

  default: // File mode
    !value || usage()
    subject_lines = [(await Bun.file(mode).text()).match(/^\s*([^#\s].*?)\s*$/m)?.[1] ?? '']
}

process.exit(+!subject_lines.every((s) => /^(Merge|Revert) /i.test(s) || RE.test(s)))
