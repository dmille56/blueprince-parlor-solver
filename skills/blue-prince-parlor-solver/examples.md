# Blue Prince Parlor Solver Examples

## Example 1

Input:

```text
Left/Blue: The gems are in the white box.
Center/White: The black box is empty.
Right/Black: The gems are in the blue box.
```

Evaluation:

| Candidate | Blue text | White text | Black text | Valid? |
| --- | --- | --- | --- | --- |
| blue | false | true | true | yes |
| white | true | true | false | yes |
| black | false | false | false | yes |

Output:

```text
Ambiguous: blue, white, and black all satisfy the stated rules.
Reason: each candidate has at least one all-true box and at least one all-false box.
```

## Example 2

Input:

```text
Left/Blue: The gems are in this box.
Center/White: The gems are in the black box.
Right/Black: The blue box is empty.
```

Evaluation:

| Candidate | Blue text | White text | Black text | Valid? |
| --- | --- | --- | --- | --- |
| blue | true | false | false | yes |
| white | false | false | true | yes |
| black | false | true | true | yes |

Output:

```text
Ambiguous: blue, white, and black all satisfy the stated rules.
Reason: each candidate has at least one all-true box and at least one all-false box.
```

## Example 3

Input:

```text
Left/Blue: The gems are in the white box.
Center/White: The gems are not in the black box.
Right/Black: The gems are in the white box.
```

Evaluation:

| Candidate | Blue text | White text | Black text | Valid? |
| --- | --- | --- | --- | --- |
| blue | false | true | false | yes |
| white | true | true | true | no, no all-false box |
| black | false | false | false | no, no all-true box |

Output:

```text
Gems: blue
Reason: Only the blue candidate has at least one all-true box and at least one all-false box.
```

## Example 4

Input:

```text
Left/Blue: This box is empty. The gems are in the white box.
Center/White: The black box is empty.
Right/Black: The gems are in the blue box.
```

Evaluation note:

Under `gems in blue`, the blue box has one false statement and one false statement, the white box is true, and the black box is true. This candidate is valid. Continue evaluating the other candidates before returning an answer.

Output style:

```text
Gems: <unique valid color, if unique>
Reason: <brief candidate elimination summary>
```
