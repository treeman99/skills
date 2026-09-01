# Orca 사내 배포판 스킬 번들

회사에 설치된 Orca에 그대로 넣어 쓰는 스킬 모음이다. `orchestration`으로 작업을 지시하면
엔지니어링 규율 스킬들이 별도 지시 없이 적절한 시점에 걸리도록 `orchestration`을
커스터마이징해 두었다.

**Orca 소스는 수정하지 않는다.** 이 저장소의 `skills/` 아래 폴더들을 복사만 하면 동작한다.

설치 후 실제로 어떤 동작이 일어나는지는 **[동작 설명서](docs/how-it-works.md)** 에
흐름도와 함께 정리해 두었다. 워커가 밟는 게이트 순서, 스킬이 워커에 닿는 두 경로,
교착이 생기는 지점, 실패 모드별 확인 방법을 다룬다.

번들에 더할 스킬을 검토한 결과는 **[추가 도입 후보](docs/skill-candidates.md)** 에 있다.
Orca orchestration과 충돌하는 스킬이 있어 판정 근거를 함께 적어 두었다.

## 구성

```
skills/
  orchestration/                  stablyai/orca 원문 + 품질 스킬 라우팅 (커스터마이징)
  orca-cli/                       stablyai/orca 원문
  karpathy-guidelines/            범위 통제, 가정 명시, 검증 가능한 성공 기준
  test-driven-development/        구현 전 실패 테스트
  systematic-debugging/           수정 제안 전 근본 원인 추적
  verification-before-completion/ 완료 주장 전 증거
```

## 어디에 넣나

`skills/` **아래의 6개 폴더**를 아래 경로에 통째로 복사한다. `skills/` 폴더 자체가 아니라
그 안의 내용물이다.

| 경로 (Windows) | 경로 (macOS/Linux/WSL) | 넣는 이유 |
|---|---|---|
| `%USERPROFILE%\.agents\skills\` | `~/.agents/skills/` | Orca가 "Agent skills home"으로 인식하는 공용 경로. **필수** |
| `%USERPROFILE%\.claude\skills\` | `~/.claude/skills/` | Claude 워커가 읽는 경로 |
| `%USERPROFILE%\.config\opencode\skills\` | `~/.config/opencode/skills/` | opencode 워커가 읽는 경로 |

**세 곳 모두 넣는 것을 권한다.** `.agents\skills`는 Orca가 스킬을 인식하는 경로이고,
나머지 둘은 워커 에이전트가 실제로 스킬을 로드하는 경로다. 쓰지 않는 에이전트의 경로는
건너뛰어도 된다.

복사 후 이런 모양이 되어야 한다:

```
%USERPROFILE%\.agents\skills\
  orchestration\SKILL.md
  orca-cli\SKILL.md
  karpathy-guidelines\SKILL.md
  systematic-debugging\SKILL.md
  test-driven-development\SKILL.md
  verification-before-completion\SKILL.md
```

같은 이름의 스킬이 이미 있으면 **폴더째 지우고 새로 복사한다.** 파일만 덮어쓰면 상류에서
제거된 참조 문서가 남아 스킬이 없는 파일을 가리키게 된다.

### PowerShell로 한 번에

```powershell
# 저장소를 받은 폴더에서 실행
$src = ".\skills"
foreach ($dst in @(
    "$env:USERPROFILE\.agents\skills",
    "$env:USERPROFILE\.claude\skills",
    "$env:USERPROFILE\.config\opencode\skills"
)) {
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Get-ChildItem $src -Directory | ForEach-Object {
        $target = Join-Path $dst $_.Name
        if (Test-Path $target) { Remove-Item $target -Recurse -Force }
        Copy-Item $_.FullName $target -Recurse -Force
    }
    Write-Host "설치: $dst"
}
```

## 설치 확인

복사했다고 동작하는 것이 아니다. 아래 순서로 확인한다.

```bash
# 1. Orca가 스킬을 인식하는가
orca skills installed | grep -E 'karpathy|test-driven|systematic-debug|verification-before'

# 2. orchestration에 라우팅이 실렸는가 (1 이상이어야 한다)
grep -c 'QUALITY CONTRACT' ~/.agents/skills/orchestration/SKILL.md
```

PowerShell이면 2번은 이렇게:

```powershell
Select-String -Path "$env:USERPROFILE\.agents\skills\orchestration\SKILL.md" -Pattern 'QUALITY CONTRACT'
```

**3. 코디네이터가 만든 spec에 플레이스홀더가 남지 않았는지 본다.** 규약 2번은 태스크
유형에 따라 채워야 하는 자리다. `<<`가 남은 채로 디스패치되면 워커는 그 줄을 규칙이 아닌
빈칸으로 읽는다.

```bash
orca orchestration task-list --json | grep -c '<<'   # 0이어야 한다
```

**4. 실제 디스패치 1건으로 확인한다.** 워커의 `worker_done` 보고서(`--body`)에 실행한 검증
명령과 그 결과가 들어 있는지 본다. 없으면 규약이 spec에 실리지 않은 것이다.
1~3번이 통과해도 코디네이터가 spec에 블록을 붙이지 않으면 아무 효과가 없으므로,
이것이 진짜 검증이다.

## 동작 방식

품질 스킬은 **두 경로로** 워커에 도달한다. 하나가 실패해도 나머지가 동작한다.

**1. spec 인라인 (정본).** 코디네이터가 `task-create --spec`에 QUALITY CONTRACT 블록을
이어붙인다. 워커 종류와 무관하게 프롬프트로 들어가므로 opencode 워커에도 적용된다.

**2. 스킬 자동 로드 (보강).** Claude 워커는 스킬 description을 보고 필요한 시점에 스스로
로드한다. 각 스킬에는 `Orca dispatch 컨텍스트` 절이 있어 이 경로로 로드되어도 워커
환경에 맞게 동작한다.

경로 1만으로도 최소 게이트가 서고, 경로 2가 붙으면 세부 규칙까지 적용된다.
**스킬 이름만 적고 규약 본문을 빼면 안 되는 이유가 이것이다** — opencode에는 경로 2가 없다.

흐름도와 게이트별 상세는 [동작 설명서](docs/how-it-works.md)를 본다.

### 라우팅

| 스킬 | 걸리는 시점 |
|---|---|
| `karpathy-guidelines` | 모든 코딩 작업, 범위를 정하는 순간부터 |
| `test-driven-development` | 구현 코드를 쓰거나 고치기 전 |
| `systematic-debugging` | 버그·테스트 실패·예상 밖 동작이 나타났을 때 |
| `verification-before-completion` | 완료 주장, `worker_done`, 커밋, PR 직전 |

코디네이터 자신이 코드를 짤 때도 동일하게 적용된다. orchestration이 로드되어 있다는 것이
면제 사유가 아니다.

## 갱신 시 주의

`orchestration`과 `orca-cli`는 업스트림과 이름·경로가 같다.
`orca skills update --skill orchestration`을 실행하면 커스터마이징이 업스트림 원문으로
덮인다. 갱신은 이 저장소에서 내려받아 다시 복사하는 방식으로만 한다.

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
| `orchestration` | `stablyai/orca` | `c5d43b8a` | 상류 저장소 라이선스 |
| `orca-cli` | `stablyai/orca` | `c5d43b8a` | 상류 저장소 라이선스 |
| `karpathy-guidelines` | `multica-ai/andrej-karpathy-skills` | `2c606141936f` | MIT |
| `test-driven-development` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `systematic-debugging` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `verification-before-completion` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |

상류를 갱신할 때는 위 커밋에서 diff를 떠서 원문 변경분만 반영하고, 추가한 두 절은
유지한다. `superpowers:` 네임스페이스 접두어는 이 배포판이 그 네임스페이스로 설치되지
않으므로 다시 들어오지 않게 확인한다.
