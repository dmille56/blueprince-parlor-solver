I'd like to make a blue prince parlor game solver skill that works when used with Claude Code, Opencode, and Pi coding agent.  The skill should contain a nix derivation for both nixos and home manager installation as well as a non nix based install to be used on nix systems.  The game has 3 boxes (one each of blue, white, and black).  The objective of the game is to locate which box of the three contains the gems.  The skill when called should take an input of the words written on the three boxes and output which box contains the gems.

Here are the explicit rules from the game:
"There will always be at least one box which displays only true statements."
"THere will always be at least one box which displays only false statements."
"Only one box has a prize within.  THe other 2 are always empty."

Please refer to skill documentation at the following places when building/designing the skill:
Claude code skill documentation: https://code.claude.com/docs/en/skills
Opencode skill documentation: https://opencode.ai/docs/skills/
Pi coding agent skill documentation: https://pi.dev/docs/latest/skills

Refer to the following website for more in depth information about the parlor game: https://blue-prince.fandom.com/wiki/Parlor_Puzzle
