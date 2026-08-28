#!/usr/bin/env bash
# 이 저장소의 skills/ 폴더를 Orca 워커가 읽는 스킬 홈에 설치한다.
#
#   ~/.agents/skills          항상 설치 (Orca가 "Agent skills home"으로 인식하는 공용 경로)
#   ~/.claude/skills          해당 디렉터리가 이미 있을 때만
#   ~/.config/opencode/skills 해당 디렉터리가 이미 있을 때만
#
# 사용법:
#   bash install.sh            # 감지된 곳에만 설치
#   bash install.sh --all      # 에이전트 홈이 없어도 전부 생성해서 설치
#   bash install.sh --dry-run  # 무엇을 할지만 출력

set -euo pipefail

ALL=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --all)     ALL=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "알 수 없는 옵션: $arg" >&2; exit 1 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "skills 폴더를 찾을 수 없습니다: $SOURCE_DIR" >&2
  exit 1
fi

SKILLS=()
for d in "$SOURCE_DIR"/*/; do
  [ -f "$d/SKILL.md" ] || continue
  SKILLS+=("$(basename "$d")")
done

if [ ${#SKILLS[@]} -eq 0 ]; then
  echo "설치할 스킬이 없습니다. skills/<name>/SKILL.md 구조를 확인하세요." >&2
  exit 1
fi

echo "설치할 스킬 ${#SKILLS[@]}개: ${SKILLS[*]}"
echo

# label|path|always
TARGETS=(
  "Agent skills home|$HOME/.agents/skills|1"
  "Claude home|$HOME/.claude/skills|0"
  "OpenCode home|$HOME/.config/opencode/skills|0"
)

installed_any=0

for entry in "${TARGETS[@]}"; do
  IFS='|' read -r label path always <<< "$entry"
  parent="$(dirname "$path")"

  if [ "$always" -eq 0 ] && [ ! -d "$path" ] && [ ! -d "$parent" ] && [ "$ALL" -eq 0 ]; then
    echo "건너뜀  $label: $path (미설치 에이전트)"
    continue
  fi

  echo "설치    $label: $path"
  [ "$DRY_RUN" -eq 1 ] || mkdir -p "$path"

  for s in "${SKILLS[@]}"; do
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "          [dry-run] $s"
      continue
    fi
    # 같은 이름의 기존 스킬은 통째로 교체한다. 남은 파일이 섞이면 상류에서
    # 제거된 참조 문서가 살아남아 스킬이 없는 파일을 가리킨다.
    rm -rf "$path/$s"
    cp -R "$SOURCE_DIR/$s" "$path/$s"
    echo "          $s"
  done

  installed_any=1
  echo
done

if [ "$installed_any" -eq 0 ]; then
  echo "설치된 곳이 없습니다. --all 로 다시 실행하세요." >&2
  exit 1
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "dry-run 이었습니다. 실제로 설치하려면 --dry-run 없이 실행하세요."
  exit 0
fi

echo "완료. 확인:"
echo "  orca skills installed | grep -E 'karpathy|test-driven|systematic-debug|verification-before'"
echo
echo "orchestration 라우팅이 실렸는지 확인:"
echo "  grep -c 'QUALITY CONTRACT' \"\$HOME/.agents/skills/orchestration/SKILL.md\""
