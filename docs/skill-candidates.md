# 추가 도입 후보 스킬 검토

현재 번들(`karpathy-guidelines`, `ponytail`, `test-driven-development`,
`systematic-debugging`, `verification-before-completion`)에 더할 만한 스킬을 조사한
결과다.

조사 대상은 실제 저장소를 받아서 확인했다. 블로그 요약이 아니라 `SKILL.md` 본문을 읽고
판정했다.

- `obra/superpowers` (`b36e0829c6d0`) — 14개 스킬, 이 중 3개를 이미 쓰고 있다
- `anthropics/skills` (`3b3fad9`) — 19개 스킬

## 판정 기준

Orca orchestration 가이드의 **Tool Boundary** 절이 결정적이다:

> Do not substitute non-Orca subagent tools, generic agent-spawn APIs, or chat-only parallel
> worker features. Those may create useful workers, but they do not create Orca task/dispatch
> provenance, injected lifecycle preambles, `worker_done` authority, or decision gates.

Claude Code의 서브에이전트를 띄우는 스킬은 이 경계를 넘는다. Orca가 태스크를 추적하지
못하는 워커가 생기고, 코디네이터의 `check --wait`는 그 워커를 볼 수 없다.

두 번째 기준은 **opencode 워커에서도 되는가**, 세 번째는 **Windows에서 되는가**다.

## 요약

| 스킬 | 판정 | 이유 |
|---|---|---|
| `brainstorming` | **권장** | 순수 텍스트 지침, 충돌 0건 |
| `receiving-code-review` | **권장** | 순수 텍스트 지침, 충돌 0건 |
| `using-git-worktrees` | **조건부** | 네이티브 도구 우선 원칙이 이미 있음 |
| `writing-plans` | **조건부** | 서브에이전트 스킬을 필수 하위 스킬로 지정 |
| `requesting-code-review` | **비권장** | Claude 서브에이전트 디스패치 |
| `subagent-driven-development` | **비권장** | Orca orchestration과 정면 충돌 |
| `dispatching-parallel-agents` | **비권장** | 동일 |
| `executing-plans` | **비권장** | 서브에이전트 전제 |
| `writing-skills` | 보류 | 스킬 제작용, 개발 워크플로와 무관 |
| `using-superpowers` | 제외 | superpowers 설치 전제의 인덱스 스킬 |
| `finishing-a-development-branch` | 보류 | 병합 정책이 회사 규칙에 달림 |
| `ponytail` | **도입됨** | 이 조사 밖에서 별도로 검토해 규약 1-2번으로 들어갔다 |

`ponytail`(`DietrichGebert/ponytail`)은 위 두 저장소가 아니라 별도 요청으로 검토했고,
번들에 들어갔다. 판정 근거와 기존 규약과 겹치는 자리의 우선순위는 [README의 스킬별 실행
절](../README.md#ponytail--사다리에서-처음-성립하는-칸에-멈춘다)에 있다.

---

## 권장

### `brainstorming`

착수 전에 요구사항을 구조화된 질문으로 좁힌다. `SKILL.md` 250줄, 보조 파일 7개.
충돌 키워드 0건 — 서브에이전트도 worktree도 건드리지 않는 순수 지침이다.

현재 번들과 겹치지 않는 자리를 채운다. `karpathy-guidelines`는 "가정을 명시하라"까지만
말하고, 그 가정을 어떻게 뽑아내는지는 다루지 않는다.

**규약 연결:** 코디네이터가 `task-create` 전에 쓰는 스킬이라 워커 spec에는 넣지 않는다.
규약 1(범위 확정)의 앞 단계다.

### `receiving-code-review`

리뷰 피드백을 받았을 때 무비판 수용도 무시도 하지 않게 한다. 205줄 단일 파일, 충돌 0건.

`verification-before-completion`이 "에이전트 보고를 믿지 말라"고 하는 것과 짝이 된다.
이쪽은 사람이 준 피드백을 다룬다.

**규약 연결:** 코디네이터가 리뷰 전용 워커의 `worker_done`을 받아 처리할 때 유용하다.

---

## 조건부

### `using-git-worktrees`

이 스킬은 이미 이렇게 쓰여 있다:

> Prefer your platform's native worktree tools. Fall back to manual git worktrees only when
> no native tool is available. Using `git worktree add` when you have a native tool creates
> phantom state your harness can't see or manage.

**충돌이 아니라 호환 설계다.** Orca가 바로 그 "네이티브 도구"이므로 원칙이 맞아떨어진다.

다만 본문이 Orca를 이름으로 알지 못한다. 그대로 넣으면 워커가 네이티브 도구를 못 찾고
`git worktree add`로 빠질 수 있다. 도입한다면 `orca worktree create`를 네이티브 경로로
지목하는 절을 덧붙여야 한다. 현재 번들에 한 것과 같은 방식이다.

### `writing-plans`

계획을 2~5분 단위 작업으로 쪼갠다. 규약과 상성이 좋지만 두 가지를 고쳐야 한다.

1. 본문이 `superpowers:subagent-driven-development`를 **REQUIRED SUB-SKILL**로 지정한다.
   그 스킬은 아래 비권장 항목이다. 이 지정을 Orca `task-create` + `worker-start`로
   바꿔야 한다.
2. `superpowers:` 네임스페이스 참조가 있다. 이 배포판은 그 네임스페이스로 설치되지
   않으므로 접두어를 떼야 한다. 현재 번들에 한 것과 같다.

수정량이 적지 않아, 도입한다면 별도 커밋으로 분리하고 시뮬레이션을 다시 돌리는 것을 권한다.

---

## 비권장 — Orca와 충돌

### `subagent-driven-development`, `requesting-code-review`, `dispatching-parallel-agents`, `executing-plans`

넷 다 Claude Code의 서브에이전트를 띄우는 것을 전제로 한다. 실제 본문:

- `subagent-driven-development`: "Dispatch implementer subagent", "dispatch task reviewer",
  "Dispatch final code reviewer" — 서브에이전트 언급 27건
- `requesting-code-review`: "Dispatch a `general-purpose` subagent, filling the template at
  code-reviewer.md"

Orca 가이드가 명시적으로 금지하는 경로다. 이대로 설치하면 워커가 Orca 밖에서 또 다른
에이전트를 띄우고, 코디네이터는 그 작업을 추적하지 못한다. `worker_done` 권한도, 태스크
provenance도 생기지 않는다.

**대안:** 이 스킬들이 하려는 일은 Orca orchestration이 이미 한다.

| 이 스킬이 하려는 것 | Orca에서의 대응 |
|---|---|
| 작업마다 새 서브에이전트 | `task-create` + `worker-start` (태스크당 워커) |
| 작업 사이 리뷰 | 리뷰 전용 태스크를 별도 dispatch |
| 병렬 작업 분배 | 독립 태스크를 만들고 워커를 동시에 start |
| 최종 통합 리뷰 | 마지막 리뷰 태스크 + decision gate |

즉 **번들에 넣을 게 아니라, 규약에 "리뷰 전용 태스크" 유형을 이미 넣어둔 것으로 충분하다.**
현재 orchestration 스킬의 2번 슬롯 표에 리뷰 전용 행이 있다.

---

## anthropics/skills 쪽

19개 중 코드 품질과 직접 관련된 것은 적다. 대부분 문서·아티팩트 생성용
(`docx`, `pptx`, `xlsx`, `pdf`, `canvas-design`, `theme-factory` 등)이다.

| 스킬 | 메모 |
|---|---|
| `webapp-testing` | Playwright로 로컬 웹앱을 띄워 테스트. 웹 프로젝트라면 검토 가치 있음. Windows에서 Playwright 설치 필요 |
| `mcp-builder` | MCP 서버를 만들 때만 해당 |
| `skill-creator` | 이 번들을 유지보수할 때 유용. 개발 워크플로용은 아님 |

`webapp-testing` 외에는 지금 목적과 맞지 않는다. widget처럼 Swift 데스크톱 앱이 대상이면
`webapp-testing`도 해당 없다.

## 이미 갖고 있는 것

Claude Code에 내장된 `/code-review`와 `/security-review`는 별도 설치 없이 쓸 수 있다.
코디네이터가 워커 결과를 검수할 때 이쪽을 쓰는 편이 `requesting-code-review` 스킬을
설치하는 것보다 안전하다 — 서브에이전트 경계를 넘지 않는다.

## 권장 도입 순서

1. **`brainstorming`, `receiving-code-review`** — 충돌이 없고 수정도 필요 없다. 현재 번들에
   한 것처럼 `Orca dispatch 컨텍스트` 절과 출처절만 붙이면 된다.
2. **`using-git-worktrees`** — Orca를 네이티브 도구로 지목하는 절을 추가한 뒤.
3. **`writing-plans`** — 하위 스킬 지정을 Orca 경로로 바꾼 뒤. 시뮬레이션 재실행 권장.

1번만 해도 착수 단계(brainstorming)와 리뷰 수용 단계(receiving-code-review)가 메워져,
현재 규약이 다루지 않는 양 끝이 채워진다.

## 도입 시 반드시 할 것

새 스킬을 넣을 때마다 현재 번들에 한 것과 같은 처리가 필요하다.

- `superpowers:` 네임스페이스 접두어 제거 — 이 배포판은 그 이름으로 설치되지 않는다
- "your human partner" 지점에 `Orca dispatch 컨텍스트` 절 추가 — 없으면 워커가 사람을
  기다리다 교착한다
- Windows에서 실행되는 스크립트가 있는지 확인 — bash 스크립트는 Git Bash/WSL 전제
- 출처·라이선스 절 추가

절차는 [동작 설명서](how-it-works.md)와 [README](../README.md)의 갱신 항목을 따른다.
