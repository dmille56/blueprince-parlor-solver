---
name: blue-prince-parlor-solver
description: Solves Blue Prince Parlor Puzzle box riddles. Use when given the words on the blue, white, and black boxes and asked which box contains the gems.
license: MIT
compatibility: Claude Code, OpenCode, Pi coding agent, Agent Skills standard
metadata:
  game: Blue Prince
  puzzle: Parlor Puzzle
---

# Blue Prince Parlor Solver

Solve the Blue Prince Parlor Puzzle from the exact words written on the three boxes.

## Box Order

Use this fixed layout when interpreting input:

- Blue box = left
- White box = center
- Black box = right

## Required Input

Ask for missing box text before solving. You need all three in left-to-right order:

```text
Blue: <words on the blue box>
White: <words on the white box>
Black: <words on the black box>
```

## Rules

- There is exactly one prize box: blue, white, or black.
- The other two boxes are empty.
- At least one box displays only true statements.
- At least one box displays only false statements.

## Solve Method

Evaluate each possible gem location: blue, white, then black. Use the fixed box order above when summarizing or explaining the puzzle.

For each candidate location:

1. Treat the candidate box as containing the gems and the other two boxes as empty.
2. Evaluate every statement written on each box under that candidate.
3. Classify a box as `all true` only if every statement on it is true.
4. Classify a box as `all false` only if every statement on it is false.
5. Reject the candidate if no box is `all true`.
6. Reject the candidate if no box is `all false`.
7. Keep the candidate if it satisfies all rules.

Return the unique kept candidate.

## Output Format

Use this concise output:

```text
Gems: <blue|white|black>
Reason: <brief truth-table or elimination summary>
```

If there are zero valid candidates, say the box text is inconsistent with the rules and ask for the exact wording.

If there are multiple valid candidates, say the box text is ambiguous under the rules and list the possible boxes.

## Interpreting Statements

- Preserve exact wording. Do not silently rewrite ambiguous statements.
- Common forms are covered in [references/parlor-rules.md](references/parlor-rules.md).
- Worked examples are in [examples.md](examples.md).
- If a sentence cannot be evaluated as true or false from the three-box state and the written words alone, ask the user to clarify it.

## Important Constraints

- Do not assume a box has true statements because of its color.
- Do not assume exactly one truthful box or exactly one lying box; the rules say at least one of each.
- A box with mixed true and false statements is neither `all true` nor `all false` for the rule checks.
