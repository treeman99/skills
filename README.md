# Orca 스킬 — 원본 보관 및 복구용 (main)

이 브랜치는 **손대지 않은 업스트림 스킬 원본**을 담는다. 커스터마이징한 스킬이 문제를
일으켰을 때 되돌리기 위한 것이고, 커스터마이징이 원문에서 무엇을 바꿨는지 diff로
확인하기 위한 기준선이기도 하다.

| 브랜치 | 내용 | 용도 |
|---|---|---|
| `main` (여기) | 업스트림 원본 18종 | 복구·대조 기준선 |
| `orca_skill` | 커스터마이징 6종 | 실제 사용 |

**여기서는 아무것도 수정하지 않는다.** `skills/` 아래 파일은 아래 표의 커밋에 있는
원문과 바이트 단위로 같다. 수정본이 필요하면 `orca_skill` 브랜치에 둔다.

## 무엇이 들어 있나

### Orca 번들 스킬 — `stablyai/orca` `c5d43b8a` (2026-08-31)

Orca가 `orca skills install`로 설치하는 스킬 전부다. 8종이고, Orca 1.4.192의
`orca skills list --json`이 내놓는 목록과 이름이 일치한다.

**본문은 설치된 앱보다 상류 쪽이 앞서 있을 수 있다.** 2026-08-31 시점에 Orca 1.4.192가
번들하는 `computer-use`·`orca-cli`·`orchestration` description은 아직 상류 `3d0bd6a3`
판이고, 여기 담긴 것은 `c5d43b8a` 판이다. 바뀐 것은 computer-use와 orca-cli의 역할
경계를 가르는 라우팅 문구뿐이라 복구용으로 쓰는 데는 지장이 없다. 앱이 상류를 따라잡으면
같아진다.

| 스킬 | `orca_skill`이 쓰나 |
|---|---|
| `orchestration` | **예** (커스터마이징) |
| `orca-cli` | **예** (원문 그대로) |
| `computer-use` | 아니오 |
| `linear-tickets` | 아니오 — `orca-linear`의 레거시 별칭 |
| `orca-linear` | 아니오 |
| `orca-emulator` | 아니오 |
| `orca-emulator-android` | 아니오 |
| `orca-per-workspace-env` | 아니오 |

`orca_skill`이 쓰지 않는 6종도 담아 둔다. Orca 업데이트가 번들 스킬을 덮어썼을 때
되돌릴 원본이 여기 있어야 하기 때문이다.

### 품질 스킬 — 서드파티

| 스킬 | 상류 | 커밋 | 라이선스 |
|---|---|---|---|
| `karpathy-guidelines` | `multica-ai/andrej-karpathy-skills` | `2c606141936f` | MIT |
| `test-driven-development` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `systematic-debugging` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `verification-before-completion` | `obra/superpowers` | `b36e0829c6d0` | MIT (Jesse Vincent) |
| `ponytail` 외 5종 | `DietrichGebert/ponytail` | `2ed6c52c9d7e` | MIT (Dietrich Gebert) |

`orca_skill`은 이 4종에 `Orca dispatch 컨텍스트` 절과 출처절을 덧붙여 쓴다. 무엇이
덧붙었는지는 이 브랜치와 diff를 뜨면 그대로 나온다.

```bash
git diff main:skills/karpathy-guidelines/SKILL.md orca_skill:skills/karpathy-guidelines/SKILL.md
```

`skills/systematic-debugging/`에는 상류가 함께 배포하는 `CREATION-LOG.md`와
`test-*.md`가 그대로 들어 있다. `orca_skill`은 이것들을 빼고 배포하지만, 여기서는
원문을 손대지 않는 것이 원칙이라 남겨 둔다.

**ponytail은 6종을 다 담고 `orca_skill`은 `ponytail` 하나만 배포한다.** 나머지 다섯
(`ponytail-review`, `-audit`, `-debt`, `-gain`, `-help`)은 사람이 슬래시로 직접 부르는
용도라 orchestration 라우팅에 걸 자리가 없다. 나중에 쓰기로 하면 원문이 여기 있다.

**상류 저장소의 훅·플러그인은 담지 않는다.** ponytail은 `hooks/`와 opencode 플러그인으로
매 턴 규칙을 주입하는 경로도 제공하지만, 이 배포판은 `SKILL.md`만 쓴다. 워커 호스트마다
플러그인을 설정해야 하고, Claude Code용 `SessionStart` 훅이 statusline 설정을 제안하는
지시를 세션에 주입해서 무인 워커의 작업을 흐트러뜨리기 때문이다.

### 라이선스 원문

`licenses/superpowers-LICENSE` — `obra/superpowers` 저장소 루트의 MIT 라이선스 전문.
상류가 스킬 폴더 안에 라이선스 파일을 두지 않으므로, 스킬 폴더를 원문과 바이트 단위로
같게 유지하려고 밖에 뒀다.

`licenses/ponytail-LICENSE` — `DietrichGebert/ponytail` 저장소 루트의 MIT 라이선스
전문. 여기도 상류가 스킬 폴더 안에 라이선스 파일을 두지 않는다.

`multica-ai/andrej-karpathy-skills`는 저장소에 LICENSE 파일이 없다. MIT임은
`.claude-plugin/plugin.json`의 `"license": "MIT"`와 `SKILL.md` frontmatter의
`license: MIT`에 적혀 있다.

## SKILL.md 는 stub 이다 — 통째로 뜨지 말 것

`orchestration`과 `orca-cli`의 `SKILL.md`는 **발견용 stub**이다. 실제 사용법 본문은
`orca` 바이너리가 서비스한다. 바이너리와 문서가 어긋나지 않게 하려고 상류가 일부러
본문을 파일에서 뺐다.

그래서 이 명령으로 파일을 갱신하면 **안 된다.**

```bash
orca skills get orchestration > skills/orchestration/SKILL.md   # 틀렸다
```

`orca skills get`은 stub이 아니라 **전체 가이드**(400줄 이상)를 내놓는다. 그 결과를
`SKILL.md`에 쓰면 설치본과 다른 파일이 되어 복구용으로 못 쓴다. 갱신은 아래
"이 브랜치를 갱신하려면" 절의 방법으로 한다.

## 무엇이 설치되어 있나

`orca_skill` 브랜치를 설치하면 스킬 홈에 7개가 들어간다. 성격이 둘로 나뉘고,
**복구 방법도 다르다.**

| 스킬 | 원래 있던 것인가 | 복구 방법 |
|---|---|---|
| `orchestration` | **예** — Orca 번들 스킬을 덮어썼다 | 원본으로 되돌린다 |
| `orca-cli` | **예** — 동일 | 원본으로 되돌린다 |
| `karpathy-guidelines` | 아니오 — 새로 추가 | 지운다 |
| `test-driven-development` | 아니오 | 지운다 |
| `systematic-debugging` | 아니오 | 지운다 |
| `verification-before-completion` | 아니오 | 지운다 |
| `ponytail` | 아니오 | 지운다 |

**핵심:** 앞의 둘은 지우기만 하면 안 된다. Orca가 원래 쓰던 스킬이라 없으면
orchestration 기능 자체를 못 쓴다. 원본으로 채워 넣어야 한다.
뒤의 다섯은 원래 없던 것이라 지우면 끝이다.

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
rm -rf ~/.agents/skills/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion,ponytail}
rm -rf ~/.claude/skills/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion,ponytail}
rm -rf ~/.config/opencode/skills/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion,ponytail}

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
           'verification-before-completion','ponytail','orchestration','orca-cli')
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
  rm -rf "$root"/{karpathy-guidelines,test-driven-development,systematic-debugging,verification-before-completion,ponytail}
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

**품질 스킬 4종은 복사하지 않는다.** 이 브랜치에 원문이 들어 있지만 복구 대상이
아니다. 원래 설치되어 있지 않던 스킬이라 지우는 것이 복구다. 여기 있는 원문은
대조와 재도입용이다.

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

## 이 브랜치를 갱신하려면

Orca를 업데이트했거나 상류 품질 스킬이 바뀌었다면, 이 브랜치도 맞춰 둬야 복구가
의미 있다. **상류 저장소에서 직접 받는다.** 앞의 "SKILL.md 는 stub 이다" 절에서
설명했듯 `orca skills get`으로는 갱신할 수 없다.

### Orca 번들 스킬

```bash
# 이 저장소의 main 체크아웃 안에서 실행한다
tmp=$(mktemp -d)
git clone --filter=blob:none --no-checkout --depth 1 https://github.com/stablyai/orca "$tmp/orca"
git -C "$tmp/orca" sparse-checkout set --no-cone skills
git -C "$tmp/orca" checkout
git -C "$tmp/orca" log -1 --format='%H %ad' --date=short   # 이 커밋을 위 표에 적는다

# 스킬이 추가·삭제될 수 있으므로 폴더째 갈아 끼운다
for s in "$tmp"/orca/skills/*/; do
  n=$(basename "$s")
  rm -rf "skills/$n"
  cp -R "$s" "skills/$n"
done
rm -rf "$tmp"
git status   # 바뀐 게 있으면 커밋
```

설치된 Orca가 어떤 스킬을 번들하는지는 `orca skills list --json`으로 확인한다.
상류 `skills/` 목록과 다르면 Orca 앱이 상류보다 오래된 것이다.

### 품질 스킬

```bash
tmp=$(mktemp -d)
git clone --filter=blob:none --depth 1 https://github.com/obra/superpowers "$tmp/sp"
git clone --filter=blob:none --depth 1 https://github.com/multica-ai/andrej-karpathy-skills "$tmp/ka"
git -C "$tmp/sp" log -1 --format='%H %ad' --date=short   # 이 커밋들을 위 표에 적는다
git -C "$tmp/ka" log -1 --format='%H %ad' --date=short

for n in test-driven-development systematic-debugging verification-before-completion; do
  rm -rf "skills/$n"; cp -R "$tmp/sp/skills/$n" "skills/$n"
done
rm -rf skills/karpathy-guidelines
cp -R "$tmp/ka/skills/karpathy-guidelines" skills/karpathy-guidelines
cp "$tmp/sp/LICENSE" licenses/superpowers-LICENSE
rm -rf "$tmp"
git status
```

### ponytail

```bash
tmp=$(mktemp -d)
git clone --filter=blob:none --depth 1 https://github.com/DietrichGebert/ponytail "$tmp/pt"
git -C "$tmp/pt" log -1 --format='%H %ad' --date=short   # 이 커밋을 위 표에 적는다

for n in ponytail ponytail-review ponytail-audit ponytail-debt ponytail-gain ponytail-help; do
  rm -rf "skills/$n"; cp -R "$tmp/pt/skills/$n" "skills/$n"
done
cp "$tmp/pt/LICENSE" licenses/ponytail-LICENSE
rm -rf "$tmp"
git status
```

### 갱신 후 확인

`skills/` 아래가 상류와 바이트 단위로 같아야 한다. 커밋 전에 확인한다.

```bash
git diff --stat            # 의도한 파일만 바뀌었는가
git status --short         # 상류가 추가·삭제한 파일이 반영되었는가
```

상류가 스킬을 삭제했다면 이 브랜치에서도 지운다. 남겨 두면 없어진 스킬을 복구해
넣는 사고가 난다.
