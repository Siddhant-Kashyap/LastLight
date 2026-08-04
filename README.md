# Last Light

A 2.5D psychological horror platformer built in Godot 4.7.

---

## Project Structure

```
res://
├── assets/         # Raw art assets (textures, sprites, models, animations, materials)
├── audio/          # Sound files (music, ambience, sfx)
├── scenes/         # All .tscn scene files, organized by domain
├── scripts/        # All .gd script files, organized by domain
├── resources/      # Saved .tres/.res resource instances
├── shaders/        # .gdshader files
└── addons/         # Third-party plugins
```

### scenes/ subfolders

| Folder | Purpose |
|--------|---------|
| `main/` | Root scene and entry point |
| `player/` | Player character scene |
| `camera/` | Camera rig scene |
| `enemies/` | Enemy scenes |
| `environment/` | Level geometry and environment |
| `puzzles/` | Puzzle scenes |
| `ui/` | HUD, menus, overlays |
| `managers/` | Manager scenes (if scene-based) |
| `props/` | Interactive objects |
| `lighting/` | Lighting setup scene |

### scripts/ subfolders

| Folder | Purpose |
|--------|---------|
| `core/` | Constants, Debug, base utilities |
| `player/` | Player movement, state, abilities |
| `camera/` | Camera behaviour |
| `enemies/` | Enemy AI and behaviours |
| `managers/` | Autoload singleton managers |
| `interaction/` | Interactable system |
| `puzzles/` | Puzzle logic |
| `utilities/` | Reusable helper functions |
| `save/` | Save data structures |

---

## Autoloads (Singletons)

Loaded in this order to respect dependencies:

| Name | Path | Purpose |
|------|------|---------|
| `Constants` | `scripts/core/Constants.gd` | Global constants, no magic numbers |
| `Debug` | `scripts/core/Debug.gd` | Logging with toggle |
| `GameManager` | `scripts/managers/GameManager.gd` | Game state, pause, chapters |
| `AudioManager` | `scripts/managers/AudioManager.gd` | Music and SFX |
| `SaveManager` | `scripts/managers/SaveManager.gd` | Save and load |
| `UIManager` | `scripts/managers/UIManager.gd` | UI stack management |
| `SceneManager` | `scripts/managers/SceneManager.gd` | Scene transitions with fades |

---

## Naming Conventions

### Files

| Type | Convention | Example |
|------|-----------|---------|
| Scenes | PascalCase | `PlayerHUD.tscn` |
| Scripts | PascalCase | `PlayerController.gd` |
| Shaders | snake_case | `lantern_glow.gdshader` |
| Resources | snake_case | `player_default.tres` |
| Audio | snake_case | `ambience_cave_loop.ogg` |
| Textures | snake_case | `player_idle_sheet.png` |

### GDScript

| Symbol | Convention | Example |
|--------|-----------|---------|
| Classes | PascalCase | `class_name EnemyState` |
| Variables | snake_case | `var health_points` |
| Constants | UPPER_SNAKE_CASE | `const MAX_HEALTH` |
| Functions | snake_case | `func take_damage()` |
| Signals | snake_case, past tense | `signal health_changed` |
| Private | leading underscore | `var _is_dead`, `func _on_timer_timeout()` |
| Enums | PascalCase name, UPPER values | `enum State { IDLE, WALKING }` |

### Signals

Use past tense verbs to indicate something that already happened:

```gdscript
signal health_changed(new_value: float)
signal enemy_died(enemy: Node)
signal checkpoint_reached(checkpoint_id: String)
```

---

## Coding Conventions

- Use typed GDScript everywhere (`var x: float`, `func foo() -> void`)
- No magic numbers — use `Constants.*`
- One responsibility per script
- Use `@export` for inspector-configurable values
- Prefer signals over direct node references across systems
- Separate UI logic from gameplay logic
- Private functions and variables prefixed with `_`
- Call `Debug.print_info()` / `print_warning()` / `print_error()` instead of bare `print()`

---

## Commit Conventions

Format: `type(scope): short description`

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change without behavior change |
| `style` | Formatting only |
| `docs` | Documentation |
| `assets` | Art, audio, or raw asset files |
| `chore` | Build, config, tooling |

Examples:
```
feat(player): add jump and coyote time
fix(audio): resolve music not looping on scene reload
assets(environment): add cave tileset sprites
```

---

## Git Workflow

### Branch Strategy

```
main          ← stable, release-ready
develop       ← integration branch
feature/*     ← new features (branch from develop)
fix/*         ← bug fixes (branch from develop or main)
assets/*      ← asset additions (branch from develop)
```

### Flow

1. Branch off `develop`: `git checkout -b feature/player-movement`
2. Commit often with conventional commits
3. Open PR → `develop`
4. Merge to `main` only for releases

### Recommended Aliases

```bash
git config alias.lg "log --oneline --graph --decorate"
git config alias.st "status -sb"
```
