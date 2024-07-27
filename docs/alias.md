---
title: Alias | The Mirin Template
---
[Back to main page](..)
# Alias
```lua
alias {'modnickname', 'modinternalname'}
```
The `alias` function tells the game to treat two different mod names as the same mod name. The game will internally use the second provided name.

Arguments:

| ------------------------- | ------------------------------ |
| `modnickname: string`     | The name of the mod to rename. |
| `modinternalname: string` | The new name of the mod.       |

Example:
```lua
alias {'confusionzoffset', 'confusionoffset'}
```
