---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

# Verification Before Completion

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness

---

## Orca dispatch 컨텍스트

현재 프롬프트에 Orca 라이프사이클 프리앰블(`taskId` + `dispatchId`)이 있으면 이 절이 함께 적용된다. 프리앰블이 없으면 이 절은 무시하고 위 본문만 따른다.

**게이트 위치:** `worker_done` 전송 직전이 이 스킬의 마지막 게이트다. Gate Function 5단계를 통과하지 못한 상태에서 `--outcome succeeded`를 보내는 것은 이 스킬 위반이다.

**증거를 보고서에 담는다.** `worker_done`의 `--body`에 실행한 검증 명령과 그 결과(테스트 통과 수, 종료 코드)를 적는다. 코디네이터는 워커 터미널을 읽지 않고 이 보고서로 판단하므로, 본문에 없는 증거는 존재하지 않는 것과 같다.

**실패를 산문에만 담지 않는다.** 검증이 통과하지 않았다면 `--outcome failed`로 보고한다. 제목이나 본문에만 실패를 적고 `--outcome succeeded`를 보내면 Orca는 태스크를 성공으로 기록한다. 부분 성공도 실패다.

```bash
# 통과: 증거와 함께
orca orchestration send --type worker_done --outcome succeeded \
  --subject "로그인 검증 버그 수정" \
  --body "npm test 실행: 34/34 통과(exit 0). npm run lint: 0 errors. 원 증상 재현 테스트 auth.test.ts:88 red→green 확인." \
  --task-id <task_id> --dispatch-id <dispatch_id> --files-modified "src/auth.ts,src/auth.test.ts" --json

# 미통과: 프리앰블이 있어도 succeeded로 포장하지 않는다
orca orchestration send --type worker_done --outcome failed \
  --subject "로그인 검증 버그 - 미해결" \
  --body "npm test: 31/34 통과, 3건 실패(세션 만료 경로). 근본 원인 미확정. 시도한 가설 3건과 기각 근거는 아래." \
  --task-id <task_id> --dispatch-id <dispatch_id> --json
```

**"에이전트가 성공했다고 보고함"은 증거가 아니다.** 위 본문의 Agent delegation 항목은 코디네이터에게도 그대로 적용된다. 워커의 `worker_done --outcome succeeded`를 받은 코디네이터는 VCS diff나 검증 명령으로 독립 확인한 뒤에만 완료를 주장한다.

---

## 출처와 라이선스

Orca 사내 배포판이 번들한 서드파티 스킬이다. **본문은 원문 그대로이고 위 `Orca dispatch 컨텍스트` 절과 이 절만 추가했다.**

- 출처: `obra/superpowers` · `skills/verification-before-completion/SKILL.md` (커밋 `b36e0829c6d0`)
- 저작권: Copyright (c) 2025 Jesse Vincent · 라이선스: MIT (이 디렉터리의 `LICENSE`)
- 원문 수정: 없음.
- 네트워크: URL을 조회하지 않고 패키지를 설치하지 않는다. 실행하는 것은 사용자 저장소의 검증 명령(테스트·린트·빌드)뿐이다.
