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

### Orca 번들 스킬 — `stablyai/orca` `53899251` (2026-10-04)

Orca가 `orca skills install`로 설치하는 스킬 전부다. 8종이고, 이름은 설치된 Orca의
`orca skills list --json`이 내놓는 목록과 맞춰 확인한다.

커밋은 `6729f1b8`에서 `53899251`로 올렸지만 **파일은 하나도 바뀌지 않았다.** 그 사이
439커밋 중 `skills/`를 건드린 것이 없어 두 커밋의 `skills/` 트리 해시가 같다. 커밋만 올린
것은 v1.4.220 릴리스(2026-10-04)까지 대조했다는 기록을 남기기 위해서다.

**v1.4.219(`e705cac04a`)·v1.4.220(`a7927b28ce`)·v1.4.221(`9dd8812384`)·v1.4.222
(`4bb6f2072b`)·v1.4.223(`5272afeda6`) 태그의 `skills/` 트리 해시는 `d606be3a`와 같다.** 즉
v1.4.211부터 v1.4.223까지 릴리스된 앱이 설치하는 stub은 모두 같고, 이 브랜치의 stub과도
같다. 릴리스 태그는 릴리스 브랜치라 `merge-base --is-ancestor`로는 판정할 수 없으므로 트리
해시를 대조해 확인한다.

```bash
git rev-parse v1.4.223:skills   # 53899251:skills, d606be3a:skills 와 같다
```

가이드(`skill-guides/`, 이 브랜치가 담지 않는다)는 이번 구간에 **릴리스됐다.** 앞 갱신에서
"v1.4.218 태그 뒤 상류 main에서 바뀌었고 아직 릴리스되지 않았다"고 적은 세 커밋이
v1.4.219부터 담겼다 — v1.4.219의 `skill-guides/` 트리 해시가 `6729f1b8`과 같다.
`e03870403e`(#23982)·`9afd1101ff`(#23994)가 워커 보고에서 dispatch capability를 빼고(호스트가
더는 발급하지 않는다, 구버전 호스트의 프리앰블은 `--dispatch-capability`를 계속 붙인다),
`3047353017`(#23983)이 `worker-abandon`의 정착 규칙과 태스크 취소 절차
(`task-update --status failed --result cancelled`)를 더했다. v1.4.220은 여기에
`6e7e964705`(#22636)를 더했다 — `ORCA status --json`이 자기 Orca 세션 ID를
`caller.orcaSessionId`로 보여 준다는 한 줄이다.

v1.4.220 태그 뒤 상류 main에서 바뀐 `orca-cli` 가이드는 v1.4.221에 담겼다 — v1.4.221의
`skill-guides/` 트리 해시가 `53899251`과 같다. `bde1c09866`·`2fc517c1c6`·`c1d403a47b`가
`repo set --external-worktree-visibility`, `worktree set --unread/--read`,
`worktree create|set`의 `--pr`·`--gitlab-issue`·`--gitlab-mr` 링크 플래그를 더했다.

앞 갱신에서 미릴리스라고 적은 `8e5080c132`(#24624)는 **v1.4.222부터 릴리스됐다.**
v1.4.222·v1.4.223의 `skill-guides/` 트리 해시가 같고(`fc5d9338`), v1.4.221과 다른 곳은
`references/coordinator-loop.md`의 opencode 문단 하나다. opencode도 기존 워크트리에서는
실행 호스트가 CLI 버전과 모델을 확인하면 `--model`을 받고, 새 워크트리를 만들면서 모델을
지정하는 것과 effort는 지원하지 않는다. 그래서 아래 "opencode 등 나머지 에이전트는
`--model`을 거절한다"는 v1.4.221까지의 서술이다.

v1.4.223 태그 뒤 상류 main에서는 `55eb48c137`(#26659)가 `orca-cli`의
`references/automations.md`에 `--extra-agent-args` 한 줄을 더했고 아직 릴리스되지 않았다.

그 전 갱신 `d606be3a` → `6729f1b8`(v1.4.218)과 `dac82f61` → `d606be3a`(v1.4.216)도 파일
변경 없이 커밋만 올렸다.

그 전 갱신 `76d87604` → `dac82f61`은 stub 8종의 끝 문단에 `runtime_access_denied` 안내
한 문장이 붙었다(위 `9af6a3d798`). frontmatter `description`은 8종 모두 그대로였다.

그 전 갱신 중 `0d23ea6e` → `76d87604`(v1.4.206)과 `bba68b1b` → … → `78609330`
(v1.4.200~v1.4.204)은 stub이 그대로였고, `78609330` → `0d23ea6e`는 description 3종이
바뀌었다(`12d744f2`, #21069, v1.4.206에 담김).

그 전에 가이드는 `76d87604` 뒤로 두 번 바뀌었고, 둘 다
v1.4.211부터 릴리스에 담겼다 — `eb92222e7f`(#21705)와 `52a1e2875b`(#22383)가
`references/coordinator-loop.md`의 `--model` 허용 에이전트 목록에 Antigravity와 Muse를
더하고, opencode 등 나머지 에이전트는 `--model`을 거절하므로 자기 설정의 모델을 쓴다고
적었다.

**본문은 설치된 앱보다 상류 쪽이 앞서 있을 수 있다.** `runtime_access_denied` 문단이 그
예였다(상류 main에 들어간 뒤 v1.4.211에서야 릴리스됐다). 그 전 본문의 큰 변경은
`bba68b1b`였다 — 8종의 description을 압축하고, "이건
stub이다"라는 설명·`skills get` 안내·구버전 바이너리용 부트스트랩 블록을 한 문단으로
합쳤다. `orchestration`에는 참조 문서 분할 로딩(`skills get orchestration --reference
references/<file>.md`, `--references`, `--full`)이 새로 들어갔다. 이 플래그를 모르는
구버전 바이너리를 만나면 stub 자신이 `--full`로 폴백하라고 적어 두었으므로, 앱이 상류보다
뒤처져 있어도 복구용으로 쓰는 데는 지장이 없다.

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
| `test-driven-development` | `obra/superpowers` | `8ca22dba9a` | MIT (Jesse Vincent) |
| `systematic-debugging` | `obra/superpowers` | `8ca22dba9a` | MIT (Jesse Vincent) |
| `verification-before-completion` | `obra/superpowers` | `8ca22dba9a` | MIT (Jesse Vincent) |
| `ponytail` 외 5종 | `DietrichGebert/ponytail` | `9cc65d03aa2d` | MIT (Dietrich Gebert) |

ponytail의 커밋은 `552acd5efd0a`에서 `9cc65d03aa2d`(v5.1.0, 2026-10-08)로 올렸고, **담는
6종이 모두 바뀌었다.** 이번에는 `orca_skill`이 배포하는 `ponytail/SKILL.md`도 바뀌었다.
`LICENSE`는 바이트 단위로 같다. 그 사이 4커밋 중 `skills/`를 건드린 것은 둘이고, 나머지
둘은 릴리스 커밋(v5.0.0, v5.1.0)이다.

- `01cbf81`(#1061, v5.0.0) — Ponytail 5. `ponytail/SKILL.md`를 다시 썼다.
  `## Persistence`·`## The ladder`·`## Rules`·`## Output`·`## Intensity`·
  `## When NOT to be lazy`·`## Boundaries`가 없어지고 `## Before you write`·
  `## The smallest complete change`·`## Levels` 세 절이 됐다.
  - 사다리가 7칸에서 6칸이 됐다. 표준 라이브러리와 플랫폼 기능이 한 칸으로 합쳐졌고
    "프로젝트에 자기 것이 있으면 그것을 쓴다, 사내 컴포넌트가 네이티브 위젯보다 낫다"가
    붙었다. 재사용 칸에는 "주변 코드가 쓰는 방식대로"가 붙었다.
  - 착수 전에 변경이 닿아야 할 곳(호출부·테스트·픽스처·설정·export)을 꼽게 하고, "해법에는
    게으르되 변경에는 게으르지 않다 — 변경이 깨뜨리는 호출부·테스트·픽스처까지 끝낸다"를
    새로 넣었다.
  - 출력 규칙("코드 먼저, 그 뒤 최대 3줄")이 없어지고 "답 끝에 건너뛴 것·확인하지 않은
    것·사용자가 알아야 할 위험을 한두 줄"이 됐다. 질문은 `ultra` 레벨로만 남았다("만들기
    전에 필요가 정당화하지 못하는 부분에 반문한다").
  - 사소한 변경에 테스트가 필요 없다는 문장은 남았다. 비사소한 로직은 작은 테스트나
    assert 자가검사 하나를 남긴다.
  - frontmatter `description`이 825자에서 366자로 짧아졌다.

  `ponytail-review`·`-audit`은 과잉 설계만 보던 리뷰에서 정확성·보안·부하·테스트·속도·
  군더더기를 차례로 보는 전체 품질 리뷰가 됐다. 지적마다 "무엇·문제·수정·안 고치면"을
  쉬운 영어로 적고, `Must fix`·`Should fix`·`Nice to have`로 묶는다. `-gain`은 Ponytail 5
  벤치마크(Opus 5.5, 39태스크 × 5회, 18태스크에 숨은 정확성·안전 검사)로 수치를 바꿨다.
  `-help`는 위에 맞춰 표를 고쳤다.
- `2a1fe84`(#1068, v5.1.0) — 의도적 단순화를 표시하는 주석이 `ponytail:`에서
  `shortcut: <한계>, <업그레이드 시점>`으로 바뀌었다. `ponytail-debt`는 새 마커와 옛 마커를
  모두 찾고, 사용자가 준 단어(`/ponytail-debt TODO`)로도 찾으며, 키보드 단축키 메모처럼 미룬
  일이 아닌 것은 건너뛴다.

`skills/plugin.json`은 버전 문자열만 바뀌었고 이번에도 담지 않는다. 나머지 변경은 훅,
벤치마크, 번역 README·이미지, 다른 호스트용 규칙 사본, 테스트로, 이 브랜치가 담지 않는
경로다. 훅에는 두 가지가 생겼다. `SessionStart` 훅이 규칙 뒤에 **코드베이스 맵**을 붙인다
(`hooks/ponytail-map.js` — `git ls-files`로 소스 파일을 훑어 최상위 함수·클래스·export를
폴더별 한 줄로, 최대 2,000자. `PONYTAIL_MAP=0`으로 끈다). 이 훅이 `child_process`로 `git`을
실행하는데, 로컬 명령이고 네트워크는 쓰지 않는다. statusline 제안 주입은 그대로 남았다.

그 전 갱신 `c982cd411abb` → `552acd5efd0a`(v4.13.0 뒤 2커밋)에서는 4종이 바뀌었다 —
`ponytail-review`·`-audit` 지적 항목 번호(`1b1a0c5`, #523), `-gain`의 에이전트 벤치마크
평균(`8c0cccf`, #1029), `-help`의 Codex 표기 `$ponytail:ponytail`(`8cc7bec`, #1035).
`skills/plugin.json`(Grok 마켓플레이스 매니페스트)이 생겼고, statusline이 지워진 경로를
가리키면 "STATUSLINE BROKEN" 안내를 넣는 분기가 더해졌다(`c8f8f14`, #1033).

그 전 갱신 `e3ba2aa6f1e6`(v4.10.0) → `c982cd411abb`(v4.10.3 뒤 10커밋)에서도 4종이
바뀌었다 — `ponytail-review`·`-audit`에 `reuse:` 태그(`446e4ad`, `003cd40`), `-audit`의
`delete:` 전 저장소 전체 grep(`6f7a570`), `-debt` 원장 grep의 블록 주석·빌드 폴더
처리(`b52dd9b`), `-help`의 Codex 표기 `@ponytail` → `$ponytail`(`ad14110`).

그 전 갱신 `356918eba965` → `e3ba2aa6f1e6`(v4.10.0)과 `2ed6c52c9d7e` → `356918eba965`는
`skills/`와 `LICENSE`가 그대로였다(Cursor 훅 추가, README 로고 파일 이름).

superpowers의 커밋은 `5bf4e78011`(v6.4.1)에서 `8ca22dba9a`(v6.4.2, 2026-09-25)로 올렸지만
**담는 3종과 `LICENSE`는 바이트 단위로 같다.** 그 사이 커밋은 릴리스 하나(#2384)뿐이고,
바뀐 스킬은 `writing-plans`(`SKILL.md` 축약, `plan-document-reviewer-prompt.md` 삭제)라
이 배포판이 담는 3종 밖이다. 나머지는 플러그인 매니페스트 버전과 릴리스 노트다.

그 전 갱신 `b36e0829c6d0` → `5bf4e78011`(v6.4.1)에서는 **담는 3종 중 2종의 파일이
바뀌었다.**

- `test-driven-development/SKILL.md` — GREEN 단계 "Other tests fail? Fix now." 뒤에
  문단이 하나 붙었다. "other tests"는 방금 쓴 테스트 파일이 아니라 **프로젝트 전체
  스위트**를 뜻하고, 태스크가 파일 하나만 지목했더라도 프로젝트 테스트 명령(`pytest`,
  `npm test`, `cargo test`)을 돌리며, 자기가 내지 않은 실패까지 이름을 적어 보고하라는
  내용이다. 태스크의 범위 서술은 산출물을 한정할 뿐 검증을 한정하지 않는다고 못박는다.
- `systematic-debugging/root-cause-tracing.md` — `./find-polluter.sh` 호출이
  `bash ./find-polluter.sh`로 바뀌었다. 실행 비트가 없어도 돌게 하는 한 줄 수정이다.
- `verification-before-completion`은 바이트 단위로 같다.

v6.4.1이 더한 새 스킬(`diagnosing-superpowers` 등)은 이 배포판이 담는 3종 밖이라
가져오지 않는다.

`DietrichGebert/ponytail`(`e3ba2aa6f1e6`)과 `multica-ai`(`2c606141936f`)는
**2026-09-21 재확인 시점에도 커밋이 그대로다.** 두 저장소 HEAD가 그때 표에 적힌 커밋이었다.

**2026-09-23(v1.4.209) 재확인에서는 품질 스킬 세 상류 모두 HEAD가 위 표의 커밋 그대로다**
(`5bf4e78011`·`2c606141936f`·`e3ba2aa6f1e6`). 그 갱신은 Orca stub만 바뀌었다.

**2026-09-29(v1.4.216) 재확인에서는 superpowers만 커밋이 올라갔고(위 v6.4.2), ponytail
(`e3ba2aa6f1e6`)과 karpathy(`2c606141936f`)는 HEAD가 그대로다.** 그 갱신은 Orca와
superpowers 모두 커밋만 올렸고 파일 변경은 없다.

**2026-10-04(v1.4.220) 재확인에서는 ponytail만 커밋이 올라갔고(위 `c982cd411abb`),
superpowers(`8ca22dba9a`)와 karpathy(`2c606141936f`)는 HEAD가 그대로다.** 이번 갱신에서
파일이 바뀐 것은 `orca_skill`이 배포하지 않는 ponytail 스킬뿐이고, Orca는 커밋만
올렸다.

**2026-10-06(v1.4.221) 재확인에서도 ponytail만 커밋이 올라갔고(위 `552acd5efd0a`),
superpowers(`8ca22dba9a`)와 karpathy(`2c606141936f`)는 HEAD가 그대로다.** 이번에도 파일이
바뀐 것은 `orca_skill`이 배포하지 않는 ponytail 스킬뿐이다(위 목록). Orca는 v1.4.221 태그의
`skills/` 트리가 `53899251`과 같아 기준 커밋을 올리지 않았다.

**2026-10-09(v1.4.223) 재확인에서도 ponytail만 커밋이 올라갔고(위 `9cc65d03aa2d`),
superpowers(`8ca22dba9a`)와 karpathy(`2c606141936f`)는 HEAD가 그대로다.** 이번에는
`orca_skill`이 배포하는 `ponytail/SKILL.md`가 바뀌었다(위 목록). Orca는 v1.4.222·v1.4.223
태그의 `skills/` 트리가 `53899251`과 같아 기준 커밋을 올리지 않았다.

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
