# Parlor Puzzle Rules And Statement Guide

## Game Rules

The puzzle has three boxes: blue, white, and black.

Fixed layout:

- Blue box = left
- White box = center
- Black box = right

- There will always be at least one box which displays only true statements.
- There will always be at least one box which displays only false statements.
- Only one box has a prize within. The other two are always empty.

## Truth-Table Method

Test the three possible worlds:

| Candidate world | Blue box | White box | Black box |
| --- | --- | --- | --- |
| Gems in blue | full | empty | empty |
| Gems in white | empty | full | empty |
| Gems in black | empty | empty | full |

For each world, evaluate the text on all three boxes. The correct world is the only one where at least one box has only true statements and at least one box has only false statements.

## Common Statement Forms

These examples show how to evaluate common wording under a candidate world.

| Statement | True when |
| --- | --- |
| `The gems are in the blue box.` | candidate is blue |
| `The blue box is empty.` | candidate is not blue |
| `This box contains the gems.` | candidate is the color of the current box |
| `This box is empty.` | candidate is not the color of the current box |
| `The gems are not in the white box.` | candidate is not white |
| `The black box is empty.` | candidate is not black |
| `The statement on the white box is true.` | the white box text evaluates to all true |
| `The statement on the blue box is false.` | the blue box text evaluates to all false |

## Multiple Statements On One Box

Some boxes may contain more than one sentence.

- The box is `all true` if every sentence is true.
- The box is `all false` if every sentence is false.
- The box is mixed if at least one sentence is true and at least one sentence is false.

Mixed boxes do not satisfy either required rule, but they can still exist in a valid candidate world.

## Self-Reference And Cross-Reference

Handle references to another box's truthfulness by evaluating consistently within each candidate world. If direct evaluation creates a paradox or multiple stable interpretations, report that the wording is ambiguous and ask for exact text.

Do not invent hidden game rules beyond the three stated rules.
