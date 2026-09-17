---
name: orca-cli
description: >-
  Operate Orca-managed worktrees, folder contexts, terminals, repos, automations, artifacts,
  worktree comments, and Orca's embedded browser through the `orca` CLI. Use
  when the user says "$orca-cli", "Orca worktree", "child worktree", "spawn codex/claude in a
  worktree", "read/wait/send Orca terminal", "handoff" / "handover" / "give this to another
  agent", "Orca browser", or "orca artifacts". Prefer it over raw git
  worktree, ad hoc PTYs, or Computer Use when Orca state is involved. Use Computer Use only
  when a visible window needs GUI control that a CLI, filesystem, or API cannot do.
---

# Orca CLI

This discovery stub loads the version-matched guide from the Orca executable used for this session.

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
ORCA skills get orca-cli
```

Prefer `--json`. Use the selected executable's `--help` for commands or flags the guide does
not cover. If a command reports that Orca is not running, start it with `ORCA open --json`
and retry. If `skills get` is unknown, explain that updating Orca restores the guide; use
`--help` for read-only discovery and do not guess unsupported commands.

---

## 출처와 커스터마이징 기록

Orca 사내 배포판이 번들한 스킬이다. **업스트림 원문의 frontmatter `description`에서 스킬 공유 문구 두 개를 빼고 이 절을 추가했다. 나머지 description과 본문은 손대지 않았다.**

- 출처: `stablyai/orca` · `skills/orca-cli/SKILL.md` (커밋 `0d23ea6e`, 2026-09-17).
- 수정 1건(2026-09-17): `description`에서 다루는 대상 목록의 `skill sharing`과 트리거 문구 `"share skills"`를 뺐다. 사내 빌드는 스킬 공유를 제거했다 — 포크 커밋 `eb3d9545a6`(v1.4.188-samsungds부터)이 설정의 Share Skills 페인과 발행·링크 설치 흐름을 걷어냈고, `orca skills share` 명령도 없다(`src/cli/specs`의 `path: ['skills', 'share']`가 상류 v1.4.188·v1.4.198에는 있고 `v1.4.188-samsungds`부터 0건). 없는 기능을 description이 광고하면 스킬 공유 요청이 이 스킬로 라우팅되고, 에이전트는 없는 명령을 찾게 된다. 확인 경로는 포크 체크아웃 `/Users/daegun/Workspace/orca`의 `v1.4.204-samsungds`다. `skill-guides/orca-cli/references/publishing.md`가 "This fork removed `orca skills share`"라고 적고, `src/cli/specs/skills.test.ts`가 `skills share` 명령이 없음을 단언한다. 포크도 자기 stub에서 같은 두 문구를 뺐다(`config/fork-feature-ledger.json`의 `fork-orca-cli-skill-text`).
- 범위는 이 두 문구뿐이다. 포크 stub이 더한 다른 트리거 문구(`use orca cli`, `cardStatus` 등)는 가져오지 않았고, 나머지 description은 상류를 따른다. 상류 줄과 diff가 작게 남도록 줄바꿈도 다시 맞추지 않았다.
- 상류 머지 때: 상류가 description을 고치면 이 줄들에서 충돌이 나거나, 문장을 재배치한 경우 두 문구가 충돌 없이 되살아날 수 있다. 머지 뒤 `awk '/^---$/{n++; next} n==1' skills/orca-cli/SKILL.md | grep -ciE 'skill sharing|share skills'`가 0인지 본다(frontmatter만 검사한다 — 이 절에도 두 문구가 들어 있다).
- 삭제 조건: 사내 빌드가 스킬 공유를 되살리거나(`orca skills share`가 포크 CLI 스펙에 다시 생김), 상류가 description에서 두 문구를 빼면 이 수정을 지우고 상류를 따른다.
- **주의:** 이 스킬은 업스트림과 이름·경로가 같다. `orca skills update|install --skill orca-cli`는 이 사본을 덮어 수정과 이 절을 함께 지운다. 갱신은 이 저장소에서 내려받는 방식으로만 한다.
