# Orca 사내 배포판 스킬 번들

회사에 설치된 Orca에 그대로 넣어 쓰는 스킬 모음이다. `orchestration`으로 작업을 지시하면
엔지니어링 규율 스킬들이 별도 지시 없이 적절한 시점에 걸리도록 `orchestration`을
커스터마이징해 두었다.

**Orca 소스는 수정하지 않는다.** 이 폴더만 설치하면 동작한다.

## 구성

```
skills/
  orchestration/                  stablyai/orca 원문 + 품질 스킬 라우팅 (커스터마이징)
  orca-cli/                       stablyai/orca 원문
  karpathy-guidelines/            범위 통제, 가정 명시, 검증 가능한 성공 기준
  test-driven-development/        구현 전 실패 테스트
  systematic-debugging/           수정 제안 전 근본 원인 추적
  verification-before-completion/ 완료 주장 전 증거
install.ps1                       Windows 설치
install.sh                        macOS / Linux / WSL 설치
```

## 설치

저장소를 받아서 설치 스크립트를 실행한다.

**Windows (PowerShell)**

```powershell
git clone <이 저장소> orca-skills
cd orca-skills
.\install.ps1
```

**macOS / Linux / WSL**

```bash
git clone <이 저장소> orca-skills
cd orca-skills
bash install.sh
```

스크립트는 `skills/` 아래 6개 디렉터리를 아래 경로에 복사한다.

| 경로 | 설치 조건 | 용도 |
|---|---|---|
| `~/.agents/skills` | 항상 | Orca가 "Agent skills home"으로 인식하는 공용 경로 |
| `~/.claude/skills` | 디렉터리가 이미 있을 때 | Claude 워커 |
| `~/.config/opencode/skills` | 디렉터리가 이미 있을 때 | opencode 워커 |

없는 에이전트의 설정 디렉터리를 새로 만들지 않기 위해 조건부로 설치한다. 전부 만들려면
`-All`(PowerShell) 또는 `--all`(bash)을 준다. `-DryRun` / `--dry-run`으로 미리 볼 수 있다.

스크립트를 쓰지 않고 `skills/` 아래 디렉터리들을 위 경로에 직접 복사해도 동일하다.

## 동작 방식

품질 스킬은 **두 경로로** 워커에 도달한다. 하나가 실패해도 나머지가 동작한다.

**1. spec 인라인 (정본).** 코디네이터가 `task-create --spec`에 QUALITY CONTRACT 블록을
이어붙인다. 워커 종류와 무관하게 프롬프트로 들어가므로 opencode 워커에도 적용된다.

**2. 스킬 자동 로드 (보강).** Claude 워커는 스킬 description을 보고 필요한 시점에 스스로
로드한다. 각 스킬에는 `Orca dispatch 컨텍스트` 절이 있어 이 경로로 로드되어도 워커
환경에 맞게 동작한다.

경로 1만으로도 최소 게이트가 서고, 경로 2가 붙으면 세부 규칙까지 적용된다.
**스킬 이름만 적고 규약 본문을 빼면 안 되는 이유가 이것이다** — opencode에는 경로 2가 없다.

### 라우팅

| 스킬 | 걸리는 시점 |
|---|---|
| `karpathy-guidelines` | 모든 코딩 작업, 범위를 정하는 순간부터 |
| `test-driven-development` | 구현 코드를 쓰거나 고치기 전 |
| `systematic-debugging` | 버그·테스트 실패·예상 밖 동작이 나타났을 때 |
| `verification-before-completion` | 완료 주장, `worker_done`, 커밋, PR 직전 |

코디네이터 자신이 코드를 짤 때도 동일하게 적용된다. orchestration이 로드되어 있다는 것이
면제 사유가 아니다.

## 검증

설치했다고 동작하는 것이 아니다. 아래 순서로 확인한다.

```bash
# 1. Orca가 스킬을 인식하는가
orca skills installed | grep -E 'karpathy|test-driven|systematic-debug|verification-before'

# 2. orchestration에 라우팅이 실렸는가 (1 이상이어야 한다)
grep -c 'QUALITY CONTRACT' ~/.agents/skills/orchestration/SKILL.md

# 3. 실제 디스패치 1건 — 워커의 worker_done --body에 실행한 검증 명령과
#    결과가 들어 있는지 본다. 없으면 규약이 spec에 안 실린 것이다.
orca orchestration task-list --json
```

**3번이 진짜 검증이다.** 1·2번이 통과해도 코디네이터가 spec에 블록을 붙이지 않으면
아무 효과가 없다.

## 갱신 시 주의

`orchestration`과 `orca-cli`는 업스트림과 이름·경로가 같다.
`orca skills update --skill orchestration`을 실행하면 커스터마이징이 업스트림 원문으로
덮인다. 갱신은 이 저장소에서 내려받아 `install` 스크립트를 다시 실행하는 방식으로만 한다.

## Windows 주의사항

- `systematic-debugging/find-polluter.sh`는 bash가 필요하다(Git Bash 또는 WSL). 없으면
  이 스크립트를 쓰지 말고 수동 이분 탐색으로 대체한다. 스킬 본문에도 같은 내용이 있다.
- 저장소 루트에서 절대 경로로 호출한다. npm 저장소가 아니면 `TEST_CMD`를 지정한다:
  `TEST_CMD='pnpm vitest run' bash <skills-dir>/systematic-debugging/find-polluter.sh '.git' 'src/**/*.test.ts'`
- 나머지 스킬은 순수 텍스트 지침이라 OS 의존성이 없다.

## 상류 원본

본문은 원문 그대로이고, 각 스킬에 `Orca dispatch 컨텍스트` 절과 출처절만 추가했다.
수정한 곳은 각 스킬의 출처절에 건별로 적혀 있다.

| 스킬 | 상류 | 커밋 | 라이선스 |
|---|---|---|---|
| `orchestration` | `stablyai/orca` | `94e75866` | 상류 저장소 라이선스 |
| `orca-cli` | `stablyai/orca` | `94e75866` | 상류 저장소 라이선스 |
| `karpathy-guidelines` | `multica-ai/andrej-karpathy-skills` | `2c606141936f` | MIT |
| `test-driven-development` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `systematic-debugging` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `verification-before-completion` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |

상류를 갱신할 때는 위 커밋에서 diff를 떠서 원문 변경분만 반영하고, 추가한 두 절은
유지한다. `superpowers:` 네임스페이스 접두어는 이 배포판이 그 네임스페이스로 설치되지
않으므로 다시 들어오지 않게 확인한다.
