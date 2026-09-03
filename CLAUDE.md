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

## 배포 대상

**배포 대상은 회사에 설치되는 Orca이고, 편집 머신이 아니다.** 로컬 설치 여부,
`~/.claude/skills`·`~/.agents/skills` 설치본과 저장소본의 일치 여부는 배포 대상의 상태와
무관하다 — 규칙의 근거나 검토 결론으로 올리지 않는다. 동작 검증은 배포 대상 환경에서 한다.

편집 머신에서 쓸 수 있는 근거는 둘뿐이다.

- `orca skills get <name>` — 설치된 바이너리가 서비스하는 전체 가이드(400줄 이상).
  `skills/<name>/SKILL.md`(발견용 stub)와 **다른 문서다.** 이걸로 stub을 덮지 말 것.
  상류 원문이 필요하면 `stablyai/orca`의 `skills/`에서 받는다
- `npx asar extract /Applications/Orca.app/Contents/Resources/app.asar <dir>` — Orca 동작을
  소스에서 확인할 때. `out/shared/`는 미압축, `out/main/index.js`는 압축돼 있다

## 규약

- Orca 동작을 근거로 규칙을 쓰면 **앱 버전·확인 경로·삭제 조건**을 그 스킬의
  `출처와 커스터마이징 기록` 절에 남긴다. 상류가 같은 내용을 문서화하면 커스터마이징을
  지우고 상류를 따른다
- `skills/orchestration/SKILL.md` 본문은 영어, QUALITY CONTRACT 블록과 출처절은 한국어
- frontmatter `description`은 손대지 않는다 — Orca가 이 필드로 스킬을 라우팅한다
  (Agent Skills 상한 1024자)
- QUALITY CONTRACT 번호(1-1, 1-2, 2~6)는 `README.md`와 `docs/how-it-works.md`가 참조한다.
  뒤 번호를 밀지 말 것
- `SKILL.md`의 디스패치 흐름을 바꾸면 `README.md`와 `docs/how-it-works.md`의 mermaid
  다이어그램·실패 모드 표도 같이 고친다

## 하지 말 것

- `orca skills update|install --skill orchestration` — 커스터마이징을 업스트림 원문으로
  덮는다. Orca Settings의 스킬 설치·업데이트 버튼도 같은 경로로 귀결된다
