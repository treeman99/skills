---
name: karpathy-guidelines
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
license: MIT
---

# Karpathy Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## Orca dispatch 컨텍스트

현재 프롬프트에 Orca 라이프사이클 프리앰블(`taskId` + `dispatchId`)이 있으면 이 절이 함께 적용된다. 프리앰블이 없으면 이 절은 무시하고 위 본문만 따른다.

**§1 "If uncertain, ask"의 수신자는 코디네이터다.** 디스패치된 워커에는 사람이 없다. 터미널에 질문을 출력하고 기다리면 코디네이터는 그 질문을 보지 못한 채 계속 대기한다:

```bash
orca orchestration ask --question "캐시 계층을 새로 두는 것과 기존 쿼리를 고치는 것 중 어느 쪽을 원하시나요?" \
  --options "캐시 추가,쿼리 수정" --timeout-ms 600000 --json
```

**묻기 전에 스펙을 먼저 읽는다.** 태스크 스펙에 이미 답이 있는 질문을 `ask`로 보내면 코디네이터의 대기 루프만 소모한다. 스펙으로 결정할 수 있으면 가정을 명시하고 진행한 뒤, 그 가정을 `worker_done --body`에 기록한다. `ask`는 어느 쪽을 고르냐에 따라 결과물이 실질적으로 달라질 때만 쓴다.

**§3 Surgical Changes는 워커 병렬 실행에서 더 강하게 적용된다.** 같은 워크트리에서 여러 워커가 동시에 움직일 수 있다. 스펙 범위 밖 파일을 "김에" 손보면 다른 워커의 작업과 충돌하고, 충돌 원인을 코디네이터가 추적하기 어렵다. 변경한 파일은 전부 `worker_done --files-modified`에 적는다.

**§4 Goal-Driven Execution의 성공 기준은 스펙에서 온다.** 태스크 스펙의 완료 조건을 그대로 검증 가능한 체크리스트로 바꾸고, `worker_done`을 보내기 전에 항목별로 확인한다. 기준이 스펙에 없으면 지어내지 말고 `ask`로 확정한다.

---

## 출처와 라이선스

Orca 사내 배포판이 번들한 서드파티 스킬이다. **본문은 원문 그대로이고 위 `Orca dispatch 컨텍스트` 절과 이 절만 추가했다.**

- 출처: `multica-ai/andrej-karpathy-skills` · `skills/karpathy-guidelines/SKILL.md` (커밋 `2c606141936f`)
- 원 출처: Andrej Karpathy의 LLM 코딩 관찰 (x.com/karpathy · status 2015883857489522876)
- 라이선스: MIT (frontmatter의 `license` 필드 / 이 디렉터리의 `LICENSE`)
- 상류 리포에는 `LICENSE` 파일이 없다(README에 "MIT"만 명시). 배포에 라이선스 원문이 필요하므로 표준 MIT 전문을 이 디렉터리에 재구성해 두었다.
- 원문 수정: 없음.
- 네트워크: URL을 조회하지 않고 명령을 실행하지 않는다. 순수 행동 지침이다.
