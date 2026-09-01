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
  terminal control, lightweight terminal prompts, shell commands, Orca
  worktree management, reading or waiting on terminals, and automation of the
  browser embedded inside Orca. Use Computer Use for external browser windows,
  webviews, Orca app UI, or desktop UI outside Orca's embedded browser only when
  the task requires OS/window-level control such as focus, menus, dialogs,
  coordinates, or screenshots. Use `orca-cli` for Orca's embedded pages and a
  page-automation tool such as Playwright or CDP for external pages.
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

## Working files

**This binds whenever this skill is loaded** — a coordinator dispatching workers, a
dispatched worker, and equally a session that never dispatches anything and just works in
the user's project. It is not part of the dispatch contract's conditional half.

A plan, a scratch analysis, a review note, a long-form report — none of these are what was
asked for, and an agent left to its own judgment picks its own location and its own name.
That is how a project ends up with `PLAN-auth.md` at the repo root, `notes.md` beside
whatever file was being read at the time, and a folder invented on the spot for the rest.
The person whose project it is then sorts them out of a diff that should have carried the
actual change only.

**Every working file goes under `.orca/artifacts/` in the worktree being worked in.** Never
the repo root, never `docs/`, never beside the code being read, and never a new top-level
folder invented for the purpose.

| Situation | Folder |
|---|---|
| Dispatched worker with a `taskId` | `.orca/artifacts/<task_id>/` |
| No `taskId` — working directly, or a full handoff | `.orca/artifacts/<short-slug>/` |

The task id is preferred because it is the one identifier the coordinator, the `worker_done`
payload, and `dispatch-show` already share, so a stray file always traces back to the task
that wrote it. Without one, any short name that identifies the work will do. Inside the
folder, names are free.

- **Deliverables are exempt.** Source, tests, and documentation that were actually asked for
  belong where the project keeps them. This rule covers only the scaffolding produced in
  order to do the job.
- **`--report-path` points inside it** when there is a dispatch:
  `--report-path .orca/artifacts/<task_id>/report.md`. Letting the coordinator open the long
  form without searching for it is the reason that flag exists.
- **`.orca/` is already Orca's workspace namespace** — `.orca/drops`, `.orca/templates`,
  `.orca/browser-downloads`, `.orca/issue-command` — so a project that ignores `.orca` keeps
  all of this out of `git status` with one entry. Whether to add that entry is the project
  owner's call; do not edit a project's ignore file to make this rule tidier.

**A dispatched worker only sees the spec.** It never reads this file, so the rule has to
travel in the text the coordinator sends: that is what item 1-1 of the QUALITY CONTRACT is.
A worker that was never told writes wherever it likes, which is the whole failure this exists
to stop.

The served guide does not carry this rule. Nothing in `ORCA skills get orchestration` says
where to put a plan file; `--report-path` appears there as an optional flag with no
convention attached. Drop this section if a future guide specifies one, and follow the guide.

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
and a coordinator that reports completion follows `verification-before-completion`. The
working-files rule above applies here too — a coordinator's own plan or scratch analysis goes
under `.orca/artifacts/` like anyone else's.

### If you are dispatching to workers

Workers differ in how they load skills. A Claude worker resolves skills from their
descriptions; opencode and other agents either lack that mechanism or apply it differently.
Naming a skill in the spec and expecting it to load silently drops the gate on some workers.

**Inline the contract into the spec.** Append this verbatim after the task body in
`task-create --spec`, keeping the wording — workers key off this shape:

```text
--- QUALITY CONTRACT (Orca dispatch 전용) ---
1. 착수 전: 스펙의 완료 조건을 검증 가능한 체크리스트로 바꾼다. 스펙 범위 밖의 파일은
   고치지 않는다. 판단이 필요한 지점은 가정을 명시하고 진행하되 보고서에 남긴다.
   단, 빌드 설정·의존성 매니페스트·공통 설정처럼 다른 워커도 건드릴 파일을 고쳐야 하면
   가정으로 처리하지 말고 5번의 ask로 묻는다. 같은 워크트리에서 다른 워커가 동시에
   작업 중일 수 있고, 그 파일을 양쪽이 고치면 서로의 작업을 덮는다. [karpathy-guidelines]
1-1. 산출물이 아닌 파일 - 계획, 중간 분석, 리뷰 노트, 장문 리포트 - 은 전부
   `.orca/artifacts/<task_id>/` 아래에 쓴다. 폴더가 없으면 만든다. 저장소 루트,
   `docs/`, 읽고 있던 코드 옆에 두지 않고, 다른 이름의 폴더를 새로 만들지 않는다.
   태스크가 산출물로 요구한 것(소스, 테스트, 문서)은 작업 파일이 아니므로 프로젝트가
   두는 자리에 둔다. taskId를 받지 못했다면 `.orca/artifacts/` 아래에 작업을 알아볼 수
   있는 짧은 폴더명을 쓴다. 장문 리포트를 냈으면 그 경로를 6번의 --report-path로 넘긴다.
2. <<태스크 유형에 맞는 줄을 아래 표에서 골라 이 자리에 넣는다>>
3. 작업 도중 버그, 테스트 실패, 예상 밖 동작을 만나면 수정을 제안하기 전에 근본 원인을
   추적한다. 한 번에 하나씩 고친다 - 여러 변경을 묶어 시도하면 무엇이 효과가 있었는지
   알 수 없다. 같은 문제에 수정 3회가 실패하면 네 번째를 시도하지 말고 escalation으로
   보고한다. [systematic-debugging]
4. 완료를 주장하기 전에 근거를 직접 확인한다. 검증 명령이 있으면 실제로 실행하고 출력을
   읽는다. 명령이 없는 태스크(리뷰·조사)는 주장하는 내용을 재현하거나 코드에서 짚어
   확인한다. 실행하지 않은 명령의 결과나 확인하지 않은 사실을 추측해서 적지 않는다.
   "아마", "~일 것이다", "~로 보인다", "고쳐졌을 것"으로 완료를 말하지 않는다. 게이트를
   건너뛰는 것은 검증이 아니라 거짓 보고다. [verification-before-completion]
5. 질문은 사람이 아니라 코디네이터에게 보낸다:
   orca orchestration ask --question "<질문>" --timeout-ms 600000 --json
   터미널에 질문만 출력하고 기다리면 코디네이터는 그것을 보지 못하고, 양쪽이 서로를
   기다리는 교착이 된다. 스펙으로 결정할 수 있는 것은 묻지 말고 가정으로 처리한다.
6. worker_done의 --body에 실행한 검증 명령과 그 결과(통과 수, 종료 코드)를 적는다.
   검증이 통과하지 않았으면 --outcome failed로 보고한다. 실패를 본문에만 적고
   succeeded를 보내면 Orca는 태스크를 성공으로 기록한다.
   단, 검증 명령이 환경 문제로 실행 자체가 안 되면(도구 미설치, 권한, 네트워크)
   failed가 아니라 escalation을 보낸다. 그 원인은 재시도해도 그대로라, failed로
   보고하면 같은 실패가 쌓여 3회에서 dispatch 회로가 차단된다.
위 대괄호 안의 스킬이 설치되어 있으면 열어서 세부 규칙까지 따른다.
이 블록은 taskId와 dispatchId가 주어진 dispatch에서만 유효하다. 그 두 값이 없는 채로
이 블록을 받았다면 5번과 6번은 실행할 수 없다. 그 둘을 빼고 1~4번만 따른 뒤, 완료를
지시한 사람에게 직접 보고한다.
--- END QUALITY CONTRACT ---
```

**Line 2 is a slot, not a line to send as-is.** Replace the `<<...>>` placeholder with the
row matching the task, keeping the `2.` number:

| Task type | Text for line 2 |
|---|---|
| Feature, or any task that writes code | `2. 구현 전에 실패하는 테스트를 먼저 쓰고, 실패하는 것을 실제로 확인한 뒤 구현한다. 테스트를 나중에 쓰지 않는다. 구현을 먼저 써버렸다면 지우고 테스트부터 다시 시작한다. [test-driven-development]` |
| Bugfix | Same as above, plus on its own line: `   원 증상을 재현하는 테스트를 남긴다. 그 테스트가 수정 전에는 실패하고 수정 후에는 통과하는 것을 확인한다.` |
| Refactor | `2. 손대기 전에 기존 테스트가 통과하는 것을 먼저 확인해 기준선을 잡는다. 겉보기 동작을 바꾸지 않는 작업이므로 새 테스트를 만들지 않는다. 리팩터링 후 같은 테스트가 그대로 통과해야 한다. 통과하지 않으면 리팩터링이 아니라 동작 변경이므로 되돌리고 다시 한다. [test-driven-development]` |
| Review-only, no file edits | `2. 파일을 고치지 않는다. 발견 사항만 보고하고, 수정은 코디네이터가 배정한다. 각 발견 사항은 재현하거나 코드에서 짚어 확인한 것만 적고, 근거를 경로:줄로 남긴다. 확인하지 못한 의심은 의심이라고 표시한다.` |
| Investigation whose deliverable is a report | `2. 읽은 파일과 근거를 경로:줄 형식으로 남긴다. 코드를 읽어서 안 것과 실제로 실행해 확인한 것을 구분해 적는다. 확인하지 못한 것은 확인하지 못했다고 적는다.` |

Never dispatch a spec that still contains the `<<...>>` placeholder.

The numbering is the worker's time order, so read it top to bottom: settle scope (1), do the
work under the rule for this task type (2), trace root causes for anything that surprises you
along the way (3), verify (4), and report (5-6). Item 1 is first because a test written before
scope is settled tests the wrong thing. Item 1-1 rides with it because where the working
files go is part of settling the setup, and it is numbered under 1 rather than appended at
the end so the later numbers keep the meaning the rest of this distribution refers to. Item 2
holds the task-type rule because that is when the work itself happens. Item 3 is not a stage
but a conditional rule that fires whenever a bug surfaces mid-task. Item 4 is the gate
immediately before `worker_done`.

Item 4 binds every task type, not just the ones that run a command. A review or an
investigation has no test suite to execute, but it still makes claims, and an unreproduced
claim is a guess. Reading code and saying what it appears to do is not the same as confirming
it does that — the task-type rows for those two say so explicitly.

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

**Confirm before `worker-release`, not after.** Release closes that dispatch's agent
terminal. Once it is gone, a report that turns out to be wrong costs a fresh worker and a
fresh dispatch, and whatever was only in that terminal's scrollback is unrecoverable. The
order is: read the `worker_done`, check the claim against the diff or the verification
command, and only then decide between handing the terminal to a follow-up Dispatch and
releasing it.

Check the `--files-modified` list against the actual diff. A worker that reports files it
did not touch, or touched files it did not report, has given you an unreliable report even
when the outcome says `succeeded`.

### Do not attach this to full handoffs

`worktree create --prompt` and `terminal send` deliver no lifecycle preamble, so a worker
there has no `ask` or `worker_done` target. Handing off ownership hands off the quality
contract with it.

## Coordinator field notes

Two things the served guide does not cover that cost real coordinator time. Both were
confirmed against a running binary rather than inferred, and both are Orca behavior rather
than distribution policy — recheck them if the served guide starts documenting either.

### Title every task explicitly

The served guide shows `task-create` as `--spec` with `--deps`/`--parent`/`--json`, so it is
easy to miss that the CLI also accepts `--task-title` and `--display-name`:

```text
ORCA orchestration task-create --task-title "<short title>" --spec "<full spec>" --json
```

With no `--task-title`, Orca derives the title from the spec: **the first non-empty line**,
whitespace runs collapsed to single spaces, truncated to 80 characters with a trailing `...`.
`--display-name` falls back to that title and allows 160.

So a spec that opens with a path, a constraint, or a bracketed header turns the task list into
rows that all begin with the same boilerplate, and `task-list --brief` stops working as the
coordinator's external memory. Pass `--task-title` unless the spec's first line already reads
as a title on its own.

### `legacy_ambiguous` rows in `worker-list` are not leaks

`worker-list` may show settled dispatches carrying `ownershipState: external`,
`terminalState: retained`, and `retainedReason: legacy_ambiguous`. A schema migration
backfilled those rows for terminals created before Orca tracked worker terminal ownership.
It cannot prove who owns them, so it marks them external instead of claiming them.

They are not stuck workers, and there is no cleanup command for them. `worker-release` on
such a dispatch returns `retained` with that same reason and performs no process action —
deliberate, because Orca will not close a terminal it cannot prove it owns. Do not reach for
`terminal close` to tidy them up: the real owner is unknown and may be a terminal the user is
working in. Scope sweeps to the Run you are coordinating instead of reading the whole table.

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

Orca 사내 배포판이 번들한 스킬이다. **업스트림 원문에 `Working files` 절, `Bundled quality skills` 절, `Coordinator field notes` 절, 그리고 이 절만 추가했고, 나머지 본문과 frontmatter는 손대지 않았다.**

- 출처: `stablyai/orca` · `skills/orchestration/SKILL.md` (커밋 `c5d43b8a`)
- 추가 1건: `Bundled quality skills` 절. 번들된 엔지니어링 규율 스킬을 언제 로드하고, 워커에게 디스패치할 때 태스크 spec에 무엇을 주입할지 정한다.
- 추가 2건: `Working files` 절과 규약 1-1번. 산출물이 아닌 작업 파일을 `.orca/artifacts/` 아래에만 쓰게 한다. 디스패치 여부와 무관하게 적용되므로 최상위 절로 뒀다 — 사용자가 겪은 문제는 디스패치 없이 그냥 자기 프로젝트에서 스킬을 쓸 때 폴더가 제멋대로 생기는 것이었다. 사내 Orca 체크아웃(`enterprise/samsungds`)에 같은 취지의 `Work Artifacts` 절이 `f1c3963d`로 커밋돼 있지만(2026-09-01 확인), 상류 main `c5d43b8a`에는 없고 빌드 전이라 설치된 1.4.192가 서비스하는 가이드에도 없다. 그 빌드가 배포될 때까지는 이 절이 유일하게 실제로 걸리는 경로다. 규약 번호를 1-1로 둔 것은 뒤 번호를 밀지 않기 위해서다 — README와 `docs/how-it-works.md`가 2~6번을 그 번호로 참조한다. 상류가 이 규약을 릴리스하면 이 절을 지우고 가이드를 따른다.
- 추가 3건: `Coordinator field notes` 절. 업스트림 가이드가 다루지 않아 코디네이터가 실제로 시간을 버린 두 지점을 적었다 — `task-create`의 `--task-title`/`--display-name` 미문서화(없으면 spec 첫 줄에서 제목을 파생한다), `worker-list`의 `legacy_ambiguous` 행이 누수가 아니라는 것. Orca 1.4.191 소스(`src/shared/orchestration-task-display.ts`, `src/main/runtime/orchestration/db/worker-terminal/worker-terminal-release.ts`)와 실제 CLI 실행으로 확인했다(2026-08-29). 업스트림 가이드가 이 둘을 문서화하면 이 절은 지운다.
- 이 절이 유일한 정본이다. `orca skills get orchestration`이 서비스하는 가이드에는 품질 스킬 라우팅도 작업 파일 위치 규약도 없으므로(업스트림 가이드 435줄에 해당 내용 없음), 이 스킬 파일만으로 자립 동작하도록 규약 본문을 그대로 담았다. Orca 소스를 수정할 필요가 없다.
- frontmatter의 `description`은 업스트림 그대로다. Orca가 이 필드로 스킬을 라우팅하므로 바꾸지 않는다.
- **주의:** 이 스킬은 업스트림과 이름·경로가 같다. `orca skills update --skill orchestration`을 실행하면 위 커스터마이징이 업스트림 원문으로 덮인다. 갱신은 이 저장소에서 내려받는 방식으로만 한다.
