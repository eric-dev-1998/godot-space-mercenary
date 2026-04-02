# Godot game: Space Mercenary (WIP)
This is my second Godot game project.
It is a small 16-bit style shoot'em up game meant to prove my self and my own skills.

## Current features:
### Enemies behavior:
A single script is used to design multiple enemies behaviors by selecting a preset and poking its settings. This makes enemies easy to implement.
This also applies to boss enemies by following the same paradigm.

### Dialogue system:
This one is pretty basic as it should be on a 16-bit sytle game.

## Features to add in the future:
### Score board:
A score board would come nice, this can promote replayability.

### Level modular design:
Right now, levels structure is pretty much basic and follows a scheme like the following:
```Text
Level/Content/Obstacles
Level/Content/Enemies
```
A level advances by continously moving the content node over the y axis. This actually works, but it entails some performance problems and limitations.
So a better aproach will be to build the level with modules or stages, this can ensure the level is beign rendered in parts rather than having the whole thing eating the ram.
Making a modular design makes the level build process smoother and gives more fexibility which results on more dynamic and natural experiences.
