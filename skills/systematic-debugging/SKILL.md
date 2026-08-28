---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- Manager wants it fixed NOW (systematic is faster than thrashing)

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - They often contain the exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

5. **Trace Data Flow**

   **WHEN error is deep in call stack:**

   See `root-cause-tracing.md` in this directory for the complete backward tracing technique.

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - If implementing pattern, read reference implementation COMPLETELY
   - Don't skim - read every line
   - Understand the pattern fully before applying

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - What settings, config, environment?
   - What assumptions does it make?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use the `test-driven-development` skill for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?
   - Use the `verification-before-completion` skill before claiming success

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If ≥ 3: STOP and question the architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes**

   This is NOT a failed hypothesis - this is a wrong architecture.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**
- **Each fix reveals new problem in different place**

**ALL of these mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question the architecture (see Phase 4.5)

## your human partner's Signals You're Doing It Wrong

**Watch for these redirections:**
- "Is that not happening?" - You assumed without verifying
- "Will it show us...?" - You should have added evidence gathering
- "Stop guessing" - You're proposing fixes without understanding
- "Ultra-think this" - Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) - Your approach isn't working

**When you see these:** STOP. Return to Phase 1.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## When Process Reveals "No Root Cause"

If systematic investigation reveals issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Supporting Techniques

These techniques are part of systematic debugging and available in this directory:

- **`root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
- **`defense-in-depth.md`** - Add validation at multiple layers after finding root cause
- **`condition-based-waiting.md`** - Replace arbitrary timeouts with condition polling

---

## Orca dispatch 컨텍스트

현재 프롬프트에 Orca 라이프사이클 프리앰블(`taskId` + `dispatchId`)이 있으면 이 절이 함께 적용된다. 프리앰블이 없으면 이 절은 무시하고 위 본문만 따른다.

**"your human partner" = 코디네이터다.** 디스패치된 워커 터미널에는 사람이 없다. 본문이 사람과의 논의를 요구하는 지점에서 터미널에 질문만 출력하고 멈추면, 코디네이터는 `check --wait`에서 아무 메시지도 받지 못한 채 계속 기다린다. Orca는 타임아웃을 워커 실패로 보지 않으므로 **교착이 된다.**

**Phase 4.5(3회 실패 후 아키텍처 의문)의 처리:** 본문의 "Discuss with your human partner before attempting more fixes"는 아래로 대체한다.

```bash
orca orchestration send --type escalation \
  --subject "3회 수정 실패 - 아키텍처 판단 필요" \
  --body "시도한 수정 3건과 각각이 드러낸 새 결합점. 증상이 아니라 패턴 자체가 문제로 보임. 리팩터링 범위 결정 필요." \
  --task-id <task_id> --dispatch-id <dispatch_id> --json
```

네 번째 수정을 임의로 시도하지 않는다. 이것은 Orca의 dispatch 회로 차단기와도 맞물린다: 하나의 태스크에서 연속 3회 실패하면 dispatch 컨텍스트가 차단되고 태스크가 `failed`로 기록된다. 본문의 3-fix 규칙을 지키는 것이 그 차단에 걸리지 않는 길이다.

**조사 단계에서 막히면 `ask`를 쓴다.** Phase 1~3에서 정보가 부족할 때(재현 조건, 의도된 동작, 접근 권한)는 추측하지 말고 묻는다:

```bash
orca orchestration ask --question "이 타임아웃이 의도된 동작인지 회귀인지 확인 필요합니다." \
  --options "회귀,의도된 동작,불명" --timeout-ms 600000 --json
```

`escalation`은 소유권이 유효하고 코디네이터가 개입해야만 진행되는 경우에만 쓴다. 단순한 질문은 `ask`다.

**`find-polluter.sh` 실행 시 주의:** 저장소 루트에서 실행해야 하고(`find .`으로 훑는다), 스킬 디렉터리가 아니라 절대 경로로 호출한다. npm 저장소가 아니면 `TEST_CMD`를 지정한다. **Windows 워커에서는 bash가 필요하다(Git Bash 또는 WSL).** bash가 없으면 이 스크립트를 쓰지 말고 수동 이분 탐색으로 대체한다 — 실행할 수 없는 도구를 실행한 척하지 않는다.

```bash
TEST_CMD='pnpm vitest run' bash <skills-dir>/systematic-debugging/find-polluter.sh '.git' 'src/**/*.test.ts'
```

---

## 출처와 라이선스

Orca 사내 배포판이 번들한 서드파티 스킬이다. **본문은 원문 그대로이고 위 `Orca dispatch 컨텍스트` 절과 이 절만 추가했다.**

- 출처: `obra/superpowers` · `skills/systematic-debugging/` (커밋 `b36e0829c6d0`)
- 저작권: Copyright (c) 2025 Jesse Vincent · 라이선스: MIT (이 디렉터리의 `LICENSE`)
- 함께 설치되는 참조 문서: `root-cause-tracing.md`, `defense-in-depth.md`, `condition-based-waiting.md`, `condition-based-waiting-example.ts`, `find-polluter.sh`
- 수정 1건: 본문의 스킬 참조에서 `superpowers:` 접두어를 뗐다(`superpowers:test-driven-development` → `test-driven-development`). 이 배포판은 그 네임스페이스로 설치되지 않기 때문이다.
- 수정 2건: `find-polluter.sh`의 실행 비트를 뗐고 호출 표기를 `bash ...`, 절대 경로로 바꿨다. `root-cause-tracing.md`의 참조도 맞췄다.
- 수정 3건: `find-polluter.sh`에 `TEST_CMD` 환경변수와 조기 중단 두 가지를 넣었다. 원문은 `npm test`를 하드코딩하고 실패를 `|| true`로 삼키기 때문에, npm 저장소가 아니거나 패턴이 하나도 매칭되지 않으면 아무것도 검사하지 않고 "No polluter found"라는 **거짓 성공**을 냈다. 이분 탐색 로직 자체는 그대로다.
- 제외 5건: 원저자의 평가용 픽스처(`test-pressure-1~3.md`, `test-academic.md`)와 `CREATION-LOG.md`. 스킬 동작에 참조되지 않는다.
- 네트워크: URL을 조회하지 않는다. `find-polluter.sh`는 `find`와 저장소의 테스트 명령만 실행한다.
