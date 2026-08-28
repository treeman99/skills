---
name: orchestration
description: >-
  Use Orca orchestration for structured multi-agent coordination: threaded
  messages, blocking ask/reply flows, task dispatch, worker_done/escalation
  waits, task DAGs, decision gates, coordinator loops, or decomposing work
  across agents. Use `orca-cli` instead for full ownership handoffs, including
  requests phrased as "hand off", "handoff", "handover", "give this to another
  agent", or "another worktree" when the user did not explicitly ask to
  supervise, monitor, wait for results, or coordinate a DAG. Use `orca-cli` for
  ordinary terminal control, lightweight terminal prompts, shell commands, Orca
  worktree management, reading or waiting on terminals, and automation of the
  browser embedded inside Orca. Use Computer Use for browser windows, webviews,
  Orca app UI, or desktop UI outside Orca's embedded browser.
---

# Orca Orchestration

This file is a discovery stub, not the usage guide. The full, version-matched Orca
orchestration reference is served by the `orca` binary itself — kept out of this file on
purpose so it can never drift from the binary that will actually run your commands.

Engage Orca orchestration whenever you need structured multi-agent coordination: threaded
messages, blocking ask/reply flows, task dispatch, worker_done/escalation waits, task DAGs,
decision gates, coordinator loops, or decomposing work across agents. Use the orca-cli skill
instead for full ownership handoffs ("hand off", "handoff", "handover", "give this to
another agent", "another worktree") when the user did not ask to supervise, monitor, wait
for results, or coordinate a DAG — and for ordinary terminal control, shell commands,
worktree management, and the built-in browser. Coordination requires real Orca runtime
state; never substitute a non-Orca subagent tool.

## Resolve the CLI for this session

Choose the executable once and reuse it for every later command:

- If the `ORCA_CLI_COMMAND` environment variable is set, use its value. Orca exports this
  for managed WSL sessions.
- Otherwise, in a dev checkout whose session exposes `ORCA_DEV_REPO_ROOT`, use `orca-dev`.
- Otherwise, on Linux outside an Orca-managed terminal, use `orca-ide`. Never run bare
  `orca` there — outside Orca's terminals it normally resolves to the
  GNOME Orca screen reader (`/usr/bin/orca`) and starts speech on the user's machine.
- Otherwise, use `orca`.

Below, `ORCA` is a placeholder for the executable you resolved. Substitute it before
running anything; do not create a shell variable or run `ORCA` literally. This works the
same way in POSIX shells, PowerShell, and cmd.exe.

If the selected executable cannot run, report its exact error and stop. Do not fall through
to another executable, which could silently target a different Orca build.

## Load the full guide before running Orca commands

```text
ORCA skills get orchestration
```

That prints the complete, version-matched guide for the exact binary that will handle your
next commands — task creation and dispatch, injected lifecycle preambles, worker_done
authority, decision gates, and coordinator loops. Read it first, then run the specific
command you need.

Don't guess subcommands or flags from memory or from a cached copy of this stub. They
change between Orca releases, and this file deliberately no longer lists them. Confirm the
app is up with `ORCA status --json` (start it with `ORCA open --json` if needed), and
prefer `--json` for agent-driven calls.

## Bundled quality skills

This distribution ships four engineering-discipline skills alongside orchestration. They are
part of how work gets done here, not optional extras, and they apply whether you are doing
the work yourself or dispatching it to workers.

| Skill | Fires when |
|---|---|
| `karpathy-guidelines` | Any coding task, from the moment scope is being settled |
| `test-driven-development` | Before writing or changing implementation code |
| `systematic-debugging` | A bug, test failure, or unexpected behavior appears |
| `verification-before-completion` | Before any completion claim, `worker_done`, commit, or PR |

The guide served by `ORCA skills get orchestration` does not carry this routing. **This
section is the authority for it** — do not go looking for it elsewhere, and do not skip it
because the guide is silent.

### If you are doing the work yourself

Load the matching skill at the trigger above and follow it. Orchestration being loaded does
not exempt the coordinator: a coordinator that writes code follows `test-driven-development`,
and a coordinator that reports completion follows `verification-before-completion`.

### If you are dispatching to workers

Workers differ in how they load skills. A Claude worker resolves skills from their
descriptions; opencode and other agents either lack that mechanism or apply it differently.
Naming a skill in the spec and expecting it to load silently drops the gate on some workers.

**Inline the contract into the spec.** Append this verbatim after the task body in
`task-create --spec`, keeping the wording — workers key off this shape:

```text
--- QUALITY CONTRACT ---
1. 착수 전: 스펙의 완료 조건을 검증 가능한 체크리스트로 바꾼다. 스펙 범위 밖의 파일은
   고치지 않는다. 판단이 필요한 지점은 가정을 명시하고 진행하되 보고서에 남긴다.
   [karpathy-guidelines]
2. <<태스크 유형에 맞는 줄을 아래 표에서 골라 이 자리에 넣는다>>
3. 작업 도중 버그, 테스트 실패, 예상 밖 동작을 만나면 수정을 제안하기 전에 근본 원인을
   추적한다. 같은 문제에 수정 3회가 실패하면 네 번째를 시도하지 말고 escalation으로
   보고한다. [systematic-debugging]
4. 완료를 주장하기 전에 검증 명령을 실제로 실행하고 출력을 읽는다. 실행하지 않은 명령의
   결과를 추측해서 적지 않는다. [verification-before-completion]
5. 질문은 사람이 아니라 코디네이터에게 보낸다:
   orca orchestration ask --question "<질문>" --timeout-ms 600000 --json
   터미널에 질문만 출력하고 기다리면 코디네이터는 그것을 보지 못하고, 양쪽이 서로를
   기다리는 교착이 된다. 스펙으로 결정할 수 있는 것은 묻지 말고 가정으로 처리한다.
6. worker_done의 --body에 실행한 검증 명령과 그 결과(통과 수, 종료 코드)를 적는다.
   검증이 통과하지 않았으면 --outcome failed로 보고한다. 실패를 본문에만 적고
   succeeded를 보내면 Orca는 태스크를 성공으로 기록한다.
위 대괄호 안의 스킬이 설치되어 있으면 열어서 세부 규칙까지 따른다.
--- END QUALITY CONTRACT ---
```

**Line 2 is a slot, not a line to send as-is.** Replace the `<<...>>` placeholder with the
row matching the task, keeping the `2.` number:

| Task type | Text for line 2 |
|---|---|
| Feature, or any task that writes code | `2. 구현 전에 실패하는 테스트를 먼저 쓰고, 실패하는 것을 실제로 확인한 뒤 구현한다. 테스트를 나중에 쓰지 않는다. [test-driven-development]` |
| Bugfix | Same as above, plus on its own line: `   원 증상을 재현하는 테스트를 남긴다. 그 테스트가 수정 전에는 실패하고 수정 후에는 통과하는 것을 확인한다.` |
| Refactor | Same as the feature row — existing tests passing before and after is the success criterion |
| Review-only, no file edits | `2. 파일을 고치지 않는다. 발견 사항만 보고하고, 수정은 코디네이터가 배정한다.` |
| Investigation whose deliverable is a report | `2. 읽은 파일과 근거를 경로:줄 형식으로 남긴다. 확인하지 못한 것은 확인하지 못했다고 적는다.` |

Never dispatch a spec that still contains the `<<...>>` placeholder.

The numbering is the worker's time order, so read it top to bottom: settle scope (1), do the
work under the rule for this task type (2), trace root causes for anything that surprises you
along the way (3), verify (4), and report (5-6). Item 1 is first because a test written before
scope is settled tests the wrong thing. Item 2 holds the task-type rule because that is when
the work itself happens. Item 3 is not a stage but a conditional rule that fires whenever a
bug surfaces mid-task. Item 4 is the gate immediately before `worker_done`.

### Line 5 is not optional

The bundled skills were written for interactive sessions and say things like "ask your human
partner" and "Discuss with your human partner". A dispatched worker terminal has no human.
Line 5 redefines that recipient; each bundled skill also carries an `Orca dispatch 컨텍스트`
section saying the same thing for workers that load the skill directly.

Without it a worker prints its question and idles without sending `worker_done`, while the
coordinator — correctly treating a `check --wait` timeout as a checkpoint rather than a
failure — keeps waiting. **Both sides wait for each other.** Keep line 5 in every spec.

### Reporting evidence on Windows

Line 6 asks for the verification command and its output in `worker_done --body`, which makes
that argument several lines long. `cmd.exe` cannot carry a newline inside a quoted argument
at all, and in PowerShell a plain double-quoted string across lines is fragile. Workers on
Windows should build the body as a here-string first:

```powershell
$body = @"
근본 원인: 쿠폰 중첩 시 할인 합계에 상한이 없어 subtotal을 초과했다.
검증: npm test 4/4 통과(exit 0). revert 시 exit 1 재현, 복원 후 exit 0.
"@
orca orchestration send --type worker_done --outcome succeeded `
  --subject "장바구니 음수 결제금액 수정" --body $body `
  --task-id <task_id> --dispatch-id <dispatch_id> --json
```

The closing `"@` must start at column 1. If a worker cannot produce a multi-line body in its
shell, keep the body on one line and separate the facts with `; ` — never drop the evidence
to make the command easier to quote.

### Coordinator side

`verification-before-completion` binds the coordinator too. A worker's
`worker_done --outcome succeeded` is a claim, not evidence: confirm it independently through
a VCS diff or the verification command before reporting completion to the user. A
`worker_done` whose `--body` carries no command output is an incomplete report — ask for the
evidence over `dispatch:<id>` rather than accepting it.

### Do not attach this to full handoffs

`worktree create --prompt` and `terminal send` deliver no lifecycle preamble, so a worker
there has no `ask` or `worker_done` target. Handing off ownership hands off the quality
contract with it.

## If an older Orca does not recognize `skills get`

Use this fallback only when the selected binary explicitly reports that `skills get` is an
unknown command. Another failure is not proof of an older binary; report it rather than
guessing or changing executables. For a confirmed pre-guide binary, use only this bounded,
read-only bootstrap to orient. Do not dead-end and do not invent commands:

```text
ORCA status --json
ORCA orchestration task-list --json
ORCA terminal list --json
```

Then tell the user that updating Orca restores the full, version-matched guide via
`ORCA skills get orchestration`. Beyond these commands, ask the user rather than guessing a
command surface this older binary may not support.

---

## 출처와 커스터마이징 기록

Orca 사내 배포판이 번들한 스킬이다. **업스트림 원문에 `Bundled quality skills` 절과 이 절만 추가했고, 나머지 본문과 frontmatter는 손대지 않았다.**

- 출처: `stablyai/orca` · `skills/orchestration/SKILL.md` (커밋 `94e75866`)
- 추가 1건: `Bundled quality skills` 절. 번들된 엔지니어링 규율 스킬을 언제 로드하고, 워커에게 디스패치할 때 태스크 spec에 무엇을 주입할지 정한다.
- 이 절이 유일한 정본이다. `orca skills get orchestration`이 서비스하는 가이드에는 품질 스킬 라우팅이 없으므로(업스트림 가이드 435줄에 해당 내용 없음), 이 스킬 파일만으로 자립 동작하도록 규약 본문을 그대로 담았다. Orca 소스를 수정할 필요가 없다.
- frontmatter의 `description`은 업스트림 그대로다. Orca가 이 필드로 스킬을 라우팅하므로 바꾸지 않는다.
- **주의:** 이 스킬은 업스트림과 이름·경로가 같다. `orca skills update --skill orchestration`을 실행하면 위 커스터마이징이 업스트림 원문으로 덮인다. 갱신은 이 저장소에서 내려받는 방식으로만 한다.
