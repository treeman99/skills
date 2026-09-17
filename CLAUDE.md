# Orca 사내 배포판 스킬 번들

`skills/` 아래 폴더를 회사에 설치된 Orca에 복사해 쓰는 배포물이다. 사용자용 설명은
`README.md`, 절차와 고장 사례는 `docs/how-it-works.md`에 있다. 이 파일은 **이 저장소를
고칠 때** 참조한다.

## 브랜치

- **`orca_skill`이 작업 브랜치다.** 커스터마이징은 전부 여기서만 한다. 커밋·푸시도 여기로
  하고 끝낸다
- **`main`은 상류 원본 보관용이다.** `stablyai/orca`와 ponytail 등의 원문을 손대지 않은 채
  두고, 상류가 갱신되면 sync만 한다. 이 저장소의 커스터마이징은 main에 올리지 않는다 —
  원본에 작업이 섞이면 diff 기준이 사라져 복구 브랜치가 복구에 쓰이지 못한다
- **main 머지나 PR을 제안하지 않는다.** 사용자가 명시적으로 요청할 때만 한다

## 스킬 업데이트

스킬을 업데이트해달라는 요청을 받으면 다음 순서를 지켜 진행한다.

1. `main` 브랜치에 스킬들의 최신 버전 내용을 적용 후 깃에 푸시한다(원본 그대로)
2. `orca_skill` 브랜치에 `main`에 적용된 스킬 내용을 머지한다
3. 기존에 `orca_skill` 브랜치에 작업되었던 내용에 변화가 없는지 체크한다. `orca-cli`
   description에 스킬 공유 문구가 되살아나지 않았는지도 본다(아래 규약) —
   `awk '/^---$/{n++; next} n==1' skills/orca-cli/SKILL.md | grep -ciE 'skill sharing|share skills'`가
   0이어야 한다. 출처절에도 두 문구가 있으므로 파일 전체를 grep하면 안 된다
4. 새로 추가된 내용이 외부 URL 접근을 필요로 하는지 체크한다

## 배포 대상

**배포 대상은 회사에 설치되는 Orca이고, 편집 머신이 아니다.** 로컬 설치 여부,
`~/.claude/skills`·`~/.agents/skills` 설치본과 저장소본의 일치 여부는 배포 대상의 상태와
무관하다 — 규칙의 근거나 검토 결론으로 올리지 않는다. 동작 검증은 배포 대상 환경에서 한다.

편집 머신에서 쓸 수 있는 근거는 둘뿐이다.

- `orca skills get <name>` — 설치된 바이너리가 서비스하는 전체 가이드(400줄 이상).
  `skills/<name>/SKILL.md`(발견용 stub)와 **다른 문서다.** 이걸로 stub을 덮지 말 것.
  상류 원문이 필요하면 `stablyai/orca`의 `skills/`에서 받는다
- Orca 동작을 소스에서 확인할 때는 **사내 포크**를 본다 — 포크 소스
  `/Users/daegun/Workspace/orca`의 `enterprise/samsungds` 브랜치, 또는 Windows 설치본의
  `resources/app.asar`를 `npx asar extract <asar> <dir>`로 푼 것(`out/shared/`는 미압축,
  `out/main/index.js`는 압축돼 있다). **`/Applications/Orca.app`은 쓰지 않는다** — 그 앱은
  1.4.199에서도 업스트림 빌드라 포크가 고친 내용(`promptDeliveryMode`, `worker-pane-main`,
  `waitForAgentComposerReady` 등)이 전부 "없다"로 나온다. 이 착오로 opencode 워커 우회
  규칙을 한 번 잘못 세운 적이 있다(orchestration 출처절 5·5-2번)

## 규약

- Orca 동작을 근거로 규칙을 쓰면 **앱 버전·확인 경로·삭제 조건**을 그 스킬의
  `출처와 커스터마이징 기록` 절에 남긴다. 상류가 같은 내용을 문서화하면 커스터마이징을
  지우고 상류를 따른다
- `skills/orchestration/SKILL.md` 본문은 영어, QUALITY CONTRACT 블록과 출처절은 한국어
- frontmatter `description`은 손대지 않는다 — Orca가 이 필드로 스킬을 라우팅한다
  (Agent Skills 상한 1024자). **예외는 하나다:** `orca-cli` description에서 `skill sharing`과
  `"share skills"`를 뺀다. 사용자가 의도한 수정이다. 사내 빌드는 스킬 공유를 제거했으므로
  (포크 `eb3d9545a6`, v1.4.188-samsungds부터 Share Skills 페인과 `orca skills share`가
  없다) 이 두 문구는 없는 기능을 광고한다. 범위는 이 두 문구뿐이고 나머지 description은
  상류를 따른다. 포크 stub이 더한 다른 트리거 문구는 가져오지 않는다. 상류 머지로 두 문구가
  되살아나면 다시 뺀다. 근거와 삭제 조건은 `orca-cli` 출처절에 있다
- QUALITY CONTRACT 번호(1-1, 1-2, 2~6)는 `README.md`와 `docs/how-it-works.md`가 참조한다.
  뒤 번호를 밀지 말 것
- `SKILL.md`의 디스패치 흐름을 바꾸면 `README.md`와 `docs/how-it-works.md`의 mermaid
  다이어그램·실패 모드 표도 같이 고친다

## 하지 말 것

- `orca skills update|install --skill orchestration`(`orca-cli`도 같다) — 커스터마이징을
  덮는다. Orca Settings의 스킬 설치·업데이트 버튼도 같은 경로로 귀결된다
