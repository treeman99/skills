---
name: orchestration
description: >-
  Coordinate supervised Orca workers: threaded messages, blocking ask/reply,
  task dispatch, worker_done/escalation waits, task DAGs, decision gates,
  coordinator loops, and decomposing work across agents. Use `orca-cli` for full
  ownership handoffs — "hand off", "handoff", "handover", "give this to another
  agent", "another worktree" — unless asked to supervise, monitor, or coordinate
  a DAG, and for terminal control, lightweight terminal prompts, shell commands,
  Orca worktree management, and reading or waiting on terminals. Use Computer
  Use for external browser windows, webviews, Orca app UI, or desktop UI outside
  Orca's embedded browser only when the task requires OS/window-level control
  such as focus, menus, dialogs, coordinates, or screenshots. Use `orca-cli` for
  Orca's embedded pages and a page-automation tool such as Playwright or CDP for
  external pages.
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

## Load the version-matched guide before running Orca commands

```text
ORCA skills get orchestration
```

That prints the compact, version-matched guide for the exact binary that will handle your
next commands. It covers the normal local coordinator loop. For a conditional action gate
such as remote placement, uncertain release recovery, or expanded DAG work, load only the
reference that gate names with
`ORCA skills get orchestration --reference references/<file>.md`
(`--references` lists the names). If that binary rejects `--reference`, run
`ORCA skills get orchestration --full` and read the named bundled reference before acting.

Prefer `--json`. Use the selected executable's `--help` for commands or flags the guide does
not cover. If a command reports that Orca is not running, start it with `ORCA open --json`
and retry. If `skills get` is unknown, explain that updating Orca restores the guide; use
`--help` for read-only discovery and do not guess unsupported commands.

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
| Coordinator writing an opencode worker's spec file, before `task-create` has run | `.orca/artifacts/<short-slug>/dispatch-spec.md` |

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

This distribution ships five engineering-discipline skills alongside orchestration. They are
part of how work gets done here, not optional extras, and they apply whether you are doing
the work yourself or dispatching it to workers.

| Skill | Fires when |
|---|---|
| `karpathy-guidelines` | Any coding task, from the moment scope is being settled |
| `ponytail` | Scope is settled and the solution shape is being picked, before any code is written |
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

Do not rely on the worker loading the skill. Claude and opencode both resolve skills from
their descriptions, but that path depends on the worker host: a stale copy, an agent that was
not restarted after install, or a permission rule silently removes it. Naming a skill in the
spec and expecting it to load drops the gate with no signal that it happened.

**Inline the contract into the spec.** Append this verbatim after the task body in
`task-create --spec`, keeping the wording — workers key off this shape. For an opencode
worker the task body and this block go into the spec file instead, and `--spec` carries only
the pointer to it — see the opencode section below; the block itself does not change:

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
1-2. 코드를 쓰거나 고치는 태스크는, 무엇을 만들지 정할 때 아래 사다리에서 처음 성립하는
   칸에 멈춘다. (1) 존재해야 하는가 - 추측성 요구면 만들지 말고 한 줄로 그렇게 적는다.
   (2) 이 코드베이스에 이미 있는가 - 있으면 재사용한다. (3) 표준 라이브러리가 하는가.
   (4) 플랫폼 기본 기능이 덮는가. (5) 이미 설치된 의존성이 해결하는가 - 몇 줄로 되는
   일에 새 의존성을 넣지 않는다. (6) 한 줄로 되는가. (7) 아니면 동작하는 최소 구현.
   요청하지 않은 추상화와 나중을 위한 스캐폴딩은 만들지 않는다. 사다리는 문제를 이해한
   뒤에 오르는 것이지 이해를 대신하지 않는다 - 고칠 코드와 실제 흐름을 먼저 읽는다.
   입력 검증, 데이터 유실을 막는 에러 처리, 보안, 접근성, 스펙이 명시한 것은 어느
   칸에서도 깎지 않는다. [ponytail]
   이 항목은 해법의 크기만 정한다. 테스트를 쓸지와 그 순서는 2번이 정하고 2번이 이긴다.
   보고 분량은 6번이 정한다 - 검증 명령과 그 결과를 사다리를 근거로 줄이지 않는다.
   리뷰·조사 태스크에는 적용하지 않는다.
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

The numbering is the worker's time order, so read it top to bottom: settle scope (1), pick
the smallest solution that holds (1-2), do the work under the rule for this task type (2),
trace root causes for anything that surprises you along the way (3), verify (4), and report
(5-6). Item 1 is first because a test written before scope is settled tests the wrong thing.
Items 1-1 and 1-2 ride with it — where the working files go and how big the solution may be
are both part of settling the setup — and they are numbered under 1 rather than appended at
the end so the later numbers keep the meaning the rest of this distribution refers to. Item 2
holds the task-type rule because that is when the work itself happens. Item 3 is not a stage
but a conditional rule that fires whenever a bug surfaces mid-task. Item 4 is the gate
immediately before `worker_done`.

**Item 1-2 yields to items 2 and 6 where they overlap, and the contract says so on its own
line.** Upstream ponytail lets trivial code ship without a test and caps explanation at three
lines; both are wrong for a dispatched worker, which owes the coordinator a failing test
first and a `worker_done --body` carrying the verification command and its output. Without
that precedence line a worker reads two rules of equal weight and picks whichever it saw
last. Item 1-2 also scopes itself out of review and investigation tasks, which have no
solution to size.

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

`worktree create --prompt` and a free-form `terminal send` deliver no lifecycle preamble, so
a worker there has no `ask` or `worker_done` target. Handing off ownership hands off the
quality contract with it. The opencode path below is still `worker-start`; only the spec
moves into a file, so it is a dispatch like any other.

## opencode workers go through `worker-start`, with the spec as a file pointer

An opencode worker starts the same way as a `claude` or `codex` worker: through the composed
`worker-start`. That is the only path that gives the worker a supervised row, a dispatch
capability, a delivery receipt, the auto-close on settlement, and the pane placement that
splits the worker next to the coordinator instead of adding a tab. **Do not build an opencode
worker out of `terminal create` or `worktree create --agent opencode` plus `terminal send`.**
A terminal created that way is an ordinary terminal — no anchor, no supervision — and the
renderer just appends a tab to the active group.

What differs for opencode is the shape of the spec. **The task body and the QUALITY CONTRACT
do not go into `--spec`.** Write them to a file in the worker's worktree first, and give
`--spec` only a pointer to that file. Four steps, in this order:

```text
<write the task body + QUALITY CONTRACT verbatim to <worktree>/.orca/artifacts/<short-slug>/dispatch-spec.md>
ORCA orchestration task-create --task-title "<short title>" --spec "Read <abs path to that file> in full and follow it exactly. It is your task spec, QUALITY CONTRACT included." --json
ORCA orchestration worker-start --task <task_id> --worktree current --agent opencode --json
ORCA orchestration worker-read --dispatch <dispatch_id> --limit 50 --json
```

`worker-start --spec "<that same pointer>" --task-title "<short title>" --worktree current
--agent opencode --json` folds the middle two commands into one when the task needs no
`--deps`. `--worktree` takes the same selectors as for any other agent, and `current` is the
default placement. Do not pass `new-child` or `new-top-level` here: those create the worktree
and deliver the prompt in one step, leaving no moment to write the file in between. If the
worker needs a fresh worktree, create it first without an agent, write the file into it, then
`worker-start --worktree <exact selector> --agent opencode`.

The folder is `<short-slug>`, not `<task_id>`, because the file has to exist before
`task-create` runs and there is no task id yet. That is the third row of the Working files
table. Once the worker has its `taskId` it keeps its own files under `.orca/artifacts/<task_id>/`
per item 1-1; both folders trace back to the task, one through the spec pointer and one
through the id.

Four things the file step has to get right:

- **The path in `--spec` is absolute.** opencode resolves a relative path against its own cwd,
  which is not necessarily the worktree root.
- **The pointer is one line.** No newlines, no blank lines, no second sentence on its own line.
  Pass `--task-title` too: without it Orca derives the title from the first line of `--spec`,
  which is now the pointer, and every opencode task in `task-list` starts with `Read /...`.
- **The file holds the full spec verbatim.** Task body, then the QUALITY CONTRACT with item 2
  already substituted. A file that was trimmed, reflowed, or summarized starts the worker on
  half a spec, and `task-list --json | grep -c '<<'` cannot see into it — check the file.
- **Write the file before `task-create` or `worker-start`**, not after. The pointer is useless
  to a worker that reads it before the file exists, and opencode reports a missing file rather
  than waiting.

### Why the spec is a pointer

What arrives in opencode's composer is typed. On the company fork the prompt goes in as plain
text rather than bracketed paste — opencode's composer mis-handles the paste wrapper — so every
newline in the injected text is a key event, and whether the composer keeps accumulating or
submits mid-text is decided by opencode's own paste-burst inference. Where that inference
breaks depends on the opencode build, the pane size, and how busy the machine is, so there is
no byte threshold to name and no size-dependent branch here.

The pointer removes the variable part from the keystroke stream. What `worker-start` injects
is then Orca's fixed lifecycle header — about 2.7 KB on the fork's template — plus one line,
the same size for a ten-line task and a three-hundred-line one. The spec itself is read from
disk, whole or not at all. Orca does not truncate anything on the way: measured against
1.4.195 on macOS with a raw-mode reader, terminal input delivered every byte up to 200 KB, and
its only ceiling (`TERMINAL_INPUT_MAX_BYTES`, 16 MiB) rejects the call instead of delivering a
prefix.

### What `worker-start` gives back, and one warning that is normal

An earlier version of this section bypassed `worker-start` for opencode entirely. That cost
five things, all of which this path restores:

- **Dispatch capability.** Minted only by `--inject`, so `ask` and `worker_done` are
  authenticated again.
- **Delivery receipt.** The `worker-start --json` result reports the prompt write, and the
  created-terminal effect carries `paneAnchorTabId` when the worker pane was anchored to the
  coordinator's tab.
- **Supervised worker row.** `worker-show`, `worker-read`, `worker-list` report the Dispatch
  as supervised, and `worker-release` actually closes the terminal.
- **Auto-close on settlement.** The opt-in close-on-`worker_done` runs through the release
  path, so it only fires for a Dispatch that has a worker row.
- **Worker pane placement.** The pane splits beside the coordinator. The bypass produced the
  "opencode worker only adds a tab next to the coordinator" report, three times, with zero
  `worker-*` lines in the diagnostic log — two symptoms of the same missing `worker-start`.

The warning to expect: **on Windows the receipt may carry `submit: unverified`.** ConPTY
swallows opencode's OSC title, so Orca cannot observe the worker's turn start after Enter.
The fork no longer promotes that to a failure — the write succeeded, the Dispatch is live, the
capability was issued — it just says it could not confirm the submit. Treat it as a prompt to
run the `worker-read` on line four and look for the worker actually reading the spec file. If
the pointer is sitting unsubmitted in the composer, report that as a delivery failure; do not
run a second `worker-start` against the same task to fix it, because that creates a second
Dispatch, and do not fall back to `terminal send` with the spec text.

### Why this deviates from the served guide

The guide puts the full spec in `--spec`. That is right for `claude` and `codex`, whose
composers take the bracketed-paste path, and wrong for opencode for the reason above. This
section keeps the guide's command and moves only where the spec lives. The earlier bypass was
justified against the upstream macOS app, whose opencode path had no composer-readiness wait,
an open-loop settle timer, and a stall that the coordinator loop swallowed while the Dispatch
stayed active. The company fork closed all three (details in the 출처 section), which is why
the bypass is gone and the pointer stays.

This section is distribution policy, not Orca behavior, and it covers opencode only. Drop it
when the fork, or upstream, gives opencode a prompt path in which a long multi-line spec
cannot be submitted early by the composer — bracketed paste that opencode honors, or an
out-of-band spec delivery — and confirm that on the fork build, not on `/Applications/Orca.app`.

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

---

## 출처와 커스터마이징 기록

Orca 사내 배포판이 번들한 스킬이다. **업스트림 원문에 `Working files` 절, `Bundled quality skills` 절, `opencode workers go through worker-start, with the spec as a file pointer` 절, `Coordinator field notes` 절, 그리고 이 절만 추가했고, 나머지 본문과 frontmatter는 손대지 않았다.**

- 출처: `stablyai/orca` · `skills/orchestration/SKILL.md` (커밋 `aac38d69`, 2026-09-09). 본문의 마지막 내용 변경은 `bba68b1b`이고, `aac38d69`까지 상류 stub 8종은 바이트 단위로 같다 — 커밋 표기만 대조 시점(2026-09-10 재확인)에 맞춰 올렸다.
- 상류 갱신(2026-09-08): `bba68b1b`가 stub 8종을 전부 줄였다. 이 스킬에서는 description이 압축되고, `Load the full guide` 절이 `Load the version-matched guide`로 바뀌면서 구버전 바이너리용 부트스트랩 절(`If an older Orca does not recognize skills get`)이 그 절 끝 한 문단으로 흡수됐다. 참조 문서 분할 로딩(`skills get orchestration --reference references/<file>.md`, `--references`)도 새로 들어갔는데, **설치된 1.4.198은 아직 이 플래그를 모른다** — `orca skills get orchestration --references`가 `Unknown flag --references ... Valid flags: --environment, --full, --help, --json, --pairing-code, --topic`으로 거절한다(2026-09-08 확인). stub이 그 경우 `--full`로 폴백하라고 적어 두었고, 1.4.198에서는 `--full`과 기본 출력이 449줄로 동일하다. 커스터마이징은 이 변경과 겹치지 않는다.
- 추가 1건: `Bundled quality skills` 절. 번들된 엔지니어링 규율 스킬을 언제 로드하고, 워커에게 디스패치할 때 태스크 spec에 무엇을 주입할지 정한다.
- 추가 2건: `Working files` 절과 규약 1-1번. 산출물이 아닌 작업 파일을 `.orca/artifacts/` 아래에만 쓰게 한다. 디스패치 여부와 무관하게 적용되므로 최상위 절로 뒀다 — 사용자가 겪은 문제는 디스패치 없이 그냥 자기 프로젝트에서 스킬을 쓸 때 폴더가 제멋대로 생기는 것이었다. 사내 Orca 체크아웃(`enterprise/samsungds`)에 같은 취지의 `Work Artifacts` 절이 `f1c3963d`로 커밋돼 있지만(2026-09-01 확인), 상류 main `bba68b1b`에도 없고, 1.4.198이 서비스하는 449줄 가이드에도 없다(2026-09-08 재확인 — `artifact`·`working file`·`report-path` 검색 결과가 워커 배치 문단과 `worker_done` 예시뿐이다). 그 빌드가 배포될 때까지는 이 절이 유일하게 실제로 걸리는 경로다. 규약 번호를 1-1로 둔 것은 뒤 번호를 밀지 않기 위해서다 — README와 `docs/how-it-works.md`가 2~6번을 그 번호로 참조한다. 상류가 이 규약을 릴리스하면 이 절을 지우고 가이드를 따른다.
- 추가 3건: `Coordinator field notes` 절. 업스트림 가이드가 다루지 않아 코디네이터가 실제로 시간을 버린 두 지점을 적었다 — `task-create`의 `--task-title`/`--display-name` 미문서화(없으면 spec 첫 줄에서 제목을 파생한다), `worker-list`의 `legacy_ambiguous` 행이 누수가 아니라는 것. Orca 1.4.191 소스(`src/shared/orchestration-task-display.ts`, `src/main/runtime/orchestration/db/worker-terminal/worker-terminal-release.ts`)와 실제 CLI 실행으로 확인했다(2026-08-29). 1.4.198이 서비스하는 449줄 가이드에도 `task-title`·`display-name`·`legacy_ambiguous`가 한 번도 나오지 않는다(2026-09-08 재확인). 업스트림 가이드가 이 둘을 문서화하면 이 절은 지운다.
- 추가 4건: 규약 1-2번과 라우팅 표의 `ponytail` 행. 해법의 크기를 정하는 사다리를 spec에 싣는다. 상류 ponytail(`DietrichGebert/ponytail` `356918eba965`)은 훅과 opencode 플러그인으로 매 턴 규칙 전문(~1,300 토큰)을 주입하는 경로도 제공하지만, 이 배포판은 쓰지 않는다 - 워커 호스트마다 설정이 필요하고, Claude Code용 `SessionStart` 훅이 statusline 설정을 제안하는 지시를 세션에 주입해 무인 워커의 작업을 흐트러뜨린다. 대신 사다리 본문만 규약에 인라인해 워커 종류와 설치 상태에 무관하게 걸리도록 했다. 상류 본문과 충돌하는 두 지점(테스트 생략 허용, 설명 3줄 상한)은 1-2번 안에서 2번과 6번이 이긴다고 명시했다.
- 추가 5건(2026-09-03, **2026-09-11에 되돌림 — 5-2번 참조**): 당시 제목은 `Hand opencode workers their prompt as a file, never as terminal text`였고, opencode 워커에는 `--inject`(따라서 `worker-start`)를 쓰지 않고 `worktree create --agent opencode` 또는 `terminal create` + `dispatch --return-preamble` + `terminal send`로 프롬프트를 전달하게 했다. 근거는 Orca 1.4.195·1.4.198 **업스트림** 앱의 `out/main/index.js`에서 확인한 두 지점이었다. ① `createAgentPromptRenderGate`가 `claude`·`codex`에만 붙고 나머지는 `getAgentPromptSubmitDelayMs` = `500ms + ceil(bytes/4096)`(win32는 `bytes/64`) 개루프 타이머로 Enter를 친다. ② Enter 뒤 최대 30초 동안 워커의 `working` 전환을 폴링하고 못 보면 `agent_prompt_stalled`을 던지며, 코디네이터 루프가 그것을 "turn start was not observed. The preamble is already in the pane"로 삼키고 dispatch를 active로 남긴다. 이 판단은 그 자체로는 맞았지만 **확인 대상이 틀렸다** — `/Applications/Orca.app`은 사내 포크가 아니라 업스트림 빌드라, 포크가 고친 내용이 전부 "없다"로 나온다.
- 추가 5-1건(2026-09-03, **파일 포인터 기법은 5-2번에서 유지**): 같은 절에서 프리앰블을 `terminal send --text`로 보내지 않고 파일에 쓴 뒤 경로 한 줄만 보내도록 바꿨다. 계기는 긴 프롬프트가 워커에 다 전달되지 않는다는 보고였고, **원인은 Orca가 아니다.** 1.4.195에 프로브 터미널(raw 모드 리더)을 붙여 실측한 결과 터미널 입력은 2 KB~200 KB에서 손실 0이었고, 유일한 상한 `TERMINAL_INPUT_MAX_BYTES`(16 MiB)는 자르는 게 아니라 거부한다. 잘리는 곳은 opencode의 composer다 — 개행이 전부 키 이벤트가 되고, 어느 이음매에서 붙여넣기 추론이 깨지는지는 opencode 빌드·pane 크기·머신 부하에 달려 있어 Orca가 이름 붙일 수 있는 바이트 임계값이 없다. 그래서 크기 분기를 두지 않는다. 이 사실은 포크의 평문 경로(5-2번)에서도 그대로다 — 평문 역시 키 입력이다.
- 추가 5-2건(2026-09-11): **opencode 워커도 `worker-start`로 띄우고, 스펙만 파일 포인터로 넘기도록 절을 다시 썼다.** 계기는 사내 Windows 빌드 v1.4.199-samsungds에서 "opencode 워커만 패널 자동 분할이 안 되고 조율자 옆에 탭만 추가된다, `orca-diagnostic.log`에 worker 줄이 0개"라는 신고가 3회째 들어온 것이다. 원인은 Orca가 아니라 5번 절의 우회였다. 포크 소스 `/Users/daegun/Workspace/orca`(브랜치 `enterprise/samsungds`, `git describe` = `v1.4.199-samsungds`)에서 확인한 사실: ⓐ 워커 패널 자동 분할 앵커(`paneGroupPlacement`, 리시트의 `paneAnchorTabId`)는 `worker-start`가 워커 터미널을 만들 때만 붙는다 — `src/main/runtime/rpc/methods/orchestration/worker/local-worker-start.ts` → `worker-pane-anchor-terminal.ts`(`worker-pane-main` 로그 줄)와 렌더러 `src/renderer/src/hooks/ipc-events/terminal-presentation-ipc-bridge.ts`(`worker-pane-renderer` 로그 줄). `terminal create`·`worktree create`는 일반 터미널 생성이라 앵커가 없고 활성 그룹에 탭만 추가된다. 완료 탭 자동 닫기(`src/main/runtime/orchestration/settled-worker-terminal-autoclose.ts`)도 `requestWorkerTerminalRelease(dispatchId)`를 타므로 감독 행이 있어야 동작한다. ⓑ 5번의 우회 근거 세 가지는 포크에서 해소됐다. opencode는 bracketed paste 대신 평문으로 쓴다(`src/shared/tui-agent-config.ts`의 `promptDeliveryMode: 'plain-text'`, 커밋 `6cd637684c`). 쓰기 전에 composer 준비 신호를 기다린다(`OrcaRuntimeService.waitForAgentComposerReady`, `worker-dispatch-input.ts`의 `awaitWorkerComposer`, 커밋 `28164e79d2`; `worker-prompt-composer … ready=` 로그 줄). 상태를 읽을 수 없는 pane에서는 stall을 실패로 승격하지 않는다(`src/main/runtime/agent-prompt-submit-evidence.ts`의 `assertAgentPromptRescuedIfStalled`; 리시트에 `submit: 'unverified'` 경고를 남기고 capability는 발급된다 — Windows ConPTY가 opencode의 OSC 제목을 삼켜 정상적으로 나온다). ⓒ 같은 커밋을 업스트림 앱에서 세면 `grep -a -c` 기준 `promptDeliveryMode` 0건, `worker-pane-main` 0건, `waitForAgentComposerReady` 0건이다 — `/Applications/Orca.app`(CFBundleShortVersionString 1.4.199)은 업스트림 빌드라 **포크 동작의 확인 경로로 쓰지 않는다.** 앞으로 Orca 동작 확인은 포크 소스 또는 Windows 설치본의 `resources/app.asar`에서 한다. 파일 포인터는 유지했다 — 평문 경로도 키 입력이라 긴 스펙의 중간 제출 위험은 그대로이고, 포인터로 넘기면 주입 텍스트가 고정 라이프사이클 헤더(`src/main/runtime/orchestration/preamble.ts` 템플릿 리터럴 합계 2,731 B)와 한 줄뿐이라 태스크 길이와 무관하다. 파일 폴더는 task-create 전이라 `<task_id>`가 없으므로 `.orca/artifacts/<short-slug>/dispatch-spec.md`로 두고 Working files 표에 행을 추가했다. 5번 절 끝의 삭제 조건("상류가 opencode에 정착 게이트·관측 가능한 상태·bracketed paste를 주면 지운다")은 포크 빌드 v1.4.194-samsungds 이후에서 앞의 둘이 충족됐고, 셋째는 평문 경로로 대체돼 더 이상 성립하지 않으므로 우회 자체를 지웠다. 남은 커스터마이징(파일 포인터)의 삭제 조건은 절 끝에 새로 적었다. 이 맥에는 opencode가 없고 앱도 업스트림이라 실제 전달 검증은 Windows 포크 빌드에서만 가능하다 — 확인 절차는 README의 opencode 절에 있다.
- 이 절이 유일한 정본이다. `orca skills get orchestration`이 서비스하는 가이드에는 품질 스킬 라우팅도 작업 파일 위치 규약도 없으므로(1.4.198이 서비스하는 449줄 가이드에 해당 내용 없음, 2026-09-08 확인), 이 스킬 파일만으로 자립 동작하도록 규약 본문을 그대로 담았다. Orca 소스를 수정할 필요가 없다.
- frontmatter의 `description`은 업스트림 그대로다. Orca가 이 필드로 스킬을 라우팅하므로 바꾸지 않는다.
- **주의:** 이 스킬은 업스트림과 이름·경로가 같다. `orca skills update --skill orchestration`을 실행하면 위 커스터마이징이 업스트림 원문으로 덮인다. 갱신은 이 저장소에서 내려받는 방식으로만 한다.
