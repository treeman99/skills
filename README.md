# Orca 스킬 — 원본 보관 및 복구용 (main)

이 브랜치는 **손대지 않은 Orca 번들 스킬 원본**을 담는다. 커스터마이징한 스킬이 문제를
일으켰을 때 되돌리기 위한 것이다.

| 브랜치 | 내용 | 용도 |
|---|---|---|
| `main` (여기) | `orchestration`, `orca-cli` 원본 | 복구 |
| `orca_skill` | 커스터마이징 + 품질 스킬 4종 | 실제 사용 |

원본 출처: `stablyai/orca` 커밋 `94e75866`. `skills/` 아래 파일은 그 저장소의
`skills/` 내용과 바이트 단위로 같다. 여기서는 **아무것도 수정하지 않는다.**

## 무엇이 설치되어 있나

`orca_skill` 브랜치를 설치하면 스킬 홈에 6개가 들어간다. 성격이 둘로 나뉘고,
**복구 방법도 다르다.**

| 스킬 | 원래 있던 것인가 | 복구 방법 |
|---|---|---|
| `orchestration` | **예** — Orca 번들 스킬을 덮어썼다 | 원본으로 되돌린다 |
| `orca-cli` | **예** — 동일 | 원본으로 되돌린다 |
| `karpathy-guidelines` | 아니오 — 새로 추가 | 지운다 |
| `test-driven-development` | 아니오 | 지운다 |
| `systematic-debugging` | 아니오 | 지운다 |
| `verification-before-completion` | 아니오 | 지운다 |

**핵심:** 앞의 둘은 지우기만 하면 안 된다. Orca가 원래 쓰던 스킬이라 없으면
orchestration 기능 자체를 못 쓴다. 원본으로 채워 넣어야 한다.
뒤의 넷은 원래 없던 것이라 지우면 끝이다.

## 설치 경로

복구할 위치는 설치할 때 넣은 곳과 같다.

| 경로 (Windows) | 경로 (macOS/Linux/WSL) |
|---|---|
| `%USERPROFILE%\.agents\skills\` | `~/.agents/skills/` |
| `%USERPROFILE%\.claude\skills\` | `~/.claude/skills/` |
| `%USERPROFILE%\.config\opencode\skills\` | `~/.config/opencode/skills/` |

세 곳 다 넣었다면 세 곳 다 복구한다. 한 곳만 넣었다면 그곳만 하면 된다.

## 복구 방법 A — Orca가 다시 설치하게 한다 (권장)

가장 확실하다. Orca가 자기 버전에 맞는 원본을 직접 넣는다.

```bash
# 1. 추가했던 품질 스킬 4종을 지운다
rm -rf ~/.agents/skills/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion}
rm -rf ~/.claude/skills/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion}
rm -rf ~/.config/opencode/skills/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion}

# 2. 커스터마이징한 orchestration, orca-cli 도 지운다
rm -rf ~/.agents/skills/{orchestration,orca-cli}
rm -rf ~/.claude/skills/{orchestration,orca-cli}
rm -rf ~/.config/opencode/skills/{orchestration,orca-cli}

# 3. Orca 가 원본을 다시 설치한다
orca skills install --skill orchestration --skill orca-cli
```

PowerShell:

```powershell
$names = @('karpathy-guidelines','test-driven-development','systematic-debugging',
           'verification-before-completion','orchestration','orca-cli')
foreach ($root in @("$env:USERPROFILE\.agents\skills",
                    "$env:USERPROFILE\.claude\skills",
                    "$env:USERPROFILE\.config\opencode\skills")) {
    foreach ($n in $names) {
        $p = Join-Path $root $n
        if (Test-Path $p) { Remove-Item $p -Recurse -Force; Write-Host "삭제: $p" }
    }
}
orca skills install --skill orchestration --skill orca-cli
```

`orca skills install`은 설치된 에이전트를 감지해 각 홈에 넣는다. 이 명령이 성공하면
복구는 끝이다. 네트워크가 막혀 있거나 이 명령이 실패하면 방법 B로 간다.

**3단계가 실패했다면 그 상태로 두지 않는다.** 2단계에서 이미 지웠기 때문에
`orchestration`과 `orca-cli`가 없는 상태이고, 그러면 Orca의 orchestration 기능을 쓸 수
없다. 방법 B로 넘어가 파일을 직접 넣는다.

## 복구 방법 B — 이 브랜치의 파일을 직접 넣는다

네트워크 없이도 된다.

```bash
# 1. 이 브랜치를 받는다
git clone -b main https://github.com/treeman99/skills.git orca-skills-original
cd orca-skills-original

# 2. 원본이 실제로 있는지 먼저 확인한다. 이 확인 없이 3단계로 넘어가면,
#    복사할 원본이 없는 상태에서 기존 스킬만 지워 아무것도 없게 된다.
test -f skills/orchestration/SKILL.md && test -f skills/orca-cli/SKILL.md \
  || { echo "원본을 찾을 수 없다. 클론한 디렉터리 안에서 실행하는지 확인한다."; exit 1; }

# 3. 추가했던 품질 스킬 4종을 지우고, orchestration/orca-cli 를 원본으로 교체한다
for root in ~/.agents/skills ~/.claude/skills ~/.config/opencode/skills; do
  [ -d "$root" ] || continue
  rm -rf "$root"/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion}
  rm -rf "$root"/orchestration "$root"/orca-cli
  cp -R skills/orchestration "$root"/orchestration
  cp -R skills/orca-cli      "$root"/orca-cli
  echo "복구: $root"
done
```

PowerShell:

```powershell
git clone -b main https://github.com/treeman99/skills.git orca-skills-original
cd orca-skills-original

# 원본이 실제로 있는지 먼저 확인한다. 이 확인 없이 아래로 넘어가면,
# 복사할 원본이 없는 상태에서 기존 스킬만 지워 아무것도 없게 된다.
if (-not ((Test-Path ".\skills\orchestration\SKILL.md") -and
          (Test-Path ".\skills\orca-cli\SKILL.md"))) {
    throw "원본을 찾을 수 없다. 클론한 디렉터리 안에서 실행하는지 확인한다."
}

$roots = @("$env:USERPROFILE\.agents\skills",
           "$env:USERPROFILE\.claude\skills",
           "$env:USERPROFILE\.config\opencode\skills")
$added = @('karpathy-guidelines','test-driven-development',
           'systematic-debugging','verification-before-completion')

foreach ($root in $roots) {
    if (-not (Test-Path $root)) { continue }
    foreach ($n in $added) {
        $p = Join-Path $root $n
        if (Test-Path $p) { Remove-Item $p -Recurse -Force }
    }
    foreach ($n in @('orchestration','orca-cli')) {
        $p = Join-Path $root $n
        if (Test-Path $p) { Remove-Item $p -Recurse -Force }
        Copy-Item ".\skills\$n" $p -Recurse -Force
    }
    Write-Host "복구: $root"
}
```

**주의:** 폴더를 지우고 새로 복사한다. 파일만 덮어쓰면 커스터마이징 버전에만 있던
파일이 남아 원본과 섞인다.

## 복구 확인

```bash
# 1. 커스텀 흔적이 사라졌는가 — 0 이어야 한다
grep -c 'QUALITY CONTRACT' ~/.agents/skills/orchestration/SKILL.md

# 2. 품질 스킬 4종이 사라졌는가 — 아무것도 안 나와야 한다
orca skills installed | grep -E 'karpathy|test-driven|systematic-debug|verification-before'

# 3. orchestration 과 orca-cli 는 남아 있는가 — 둘 다 나와야 한다
orca skills installed | grep -E '^(orchestration|orca-cli) '

# 4. Orca 가 정상 동작하는가
orca status --json
orca skills get orchestration | head -20
```

PowerShell이면 1번은 이렇게:

```powershell
Select-String -Path "$env:USERPROFILE\.agents\skills\orchestration\SKILL.md" -Pattern 'QUALITY CONTRACT'
```

아무것도 안 나오면 복구된 것이다.

**2번과 3번을 헷갈리지 않는다.** 4종은 없어야 하고, `orchestration`/`orca-cli`는
있어야 한다. 후자까지 사라졌다면 복구가 덜 된 것이니 방법 A의 3단계를 다시 실행한다.

## 부분 복구

전부 되돌릴 필요가 없을 때도 있다.

| 증상 | 최소 조치 |
|---|---|
| 워커가 규약을 이상하게 해석한다 | `orchestration`만 원본으로 교체. 품질 스킬 4종은 둬도 자동 로드만 될 뿐이다 |
| 특정 품질 스킬 하나가 문제다 | 그 스킬 폴더만 지운다. 규약은 "설치되어 있으면 연다"이므로 없으면 건너뛴다 |
| orchestration 기능 자체가 안 뜬다 | 방법 A 전체 |

## 되돌린 뒤 다시 쓰려면

`orca_skill` 브랜치를 다시 설치하면 된다. 설치 절차는 그 브랜치의 README에 있다.

```bash
git clone -b orca_skill https://github.com/treeman99/skills.git
```

## 이 브랜치를 최신 원본으로 갱신하려면

Orca를 업데이트해 번들 스킬이 바뀌었다면, 이 브랜치도 맞춰 둬야 복구가 의미 있다.

```bash
# 설치된 Orca 가 서비스하는 원본을 그대로 뜬다
orca skills get orchestration > skills/orchestration/SKILL.md
orca skills get orca-cli      > skills/orca-cli/SKILL.md
git diff   # 바뀐 게 있으면 커밋
```

또는 `stablyai/orca` 저장소의 `skills/` 디렉터리에서 직접 받는다.
