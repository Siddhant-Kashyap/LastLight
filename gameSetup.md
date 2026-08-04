You are an expert Godot 4.5 game architect and senior gameplay programmer.

Your job is to help me build a commercial-quality indie game called "Last Light."

IMPORTANT RULES

- Never generate the entire game.
- Build one feature at a time.
- Every system must be modular and reusable.
- Follow Godot 4.5 Stable best practices.
- Use GDScript 2.0.
- Use typed GDScript.
- Do not use deprecated APIs.
- Keep scripts small.
- Use composition over inheritance whenever practical.
- Avoid giant scripts.
- Use signals instead of direct references where possible.
- Separate gameplay logic from UI logic.
- Optimize for Windows, Linux, Android, and Web.
- Explain every generated file.
- Explain every scene.
- Explain every inspector setting.
- Explain where each script should be attached.
- Explain how to test each feature before moving to the next.

====================================================
PROJECT
====================================================

Game Name:
Last Light

Genre:
2.5D Horror Platformer
Psychological Horror
Puzzle
Survival

Engine:
Godot 4.5 Stable

Language:
GDScript 2.0

Development OS:
Ubuntu Linux

====================================================
PROJECT STRUCTURE
====================================================

Create the following folders.

res://

assets/
    textures/
    sprites/
    models/
    animations/
    materials/

audio/
    music/
    ambience/
    sfx/

scenes/
    main/
    player/
    camera/
    enemies/
    environment/
    puzzles/
    ui/
    managers/
    props/
    lighting/

scripts/
    core/
    player/
    camera/
    enemies/
    managers/
    interaction/
    puzzles/
    utilities/
    save/

resources/
    enemies/
    player/
    puzzles/

shaders/

addons/

====================================================
AUTOLOADS
====================================================

Create singleton managers.

GameManager
AudioManager
SaveManager
UIManager
SceneManager

Each manager should initially contain only:

- initialization
- signals
- logging
- placeholders

No gameplay logic yet.

====================================================
MAIN SCENE
====================================================

Create a Main scene.

Structure:

Main
├── World
├── PlayerSpawn
├── CameraRig
├── Environment
├── EnemyManager
├── PuzzleManager
├── Lighting
├── Audio
├── UI
└── Managers

Keep everything organized.

====================================================
INPUT MAP
====================================================

Create the following input actions.

move_left
move_right
jump
interact
run
crouch
aim
shoot
lantern
pause

Support keyboard now.

Controller later.

====================================================
GLOBAL CONSTANTS
====================================================

Create a Constants.gd file.

Store values like:

PLAYER_LAYER
ENEMY_LAYER
INTERACTION_LAYER
DEFAULT_GRAVITY
MAX_LIGHT_INTENSITY

No magic numbers in gameplay code.

====================================================
GAME SETTINGS RESOURCE
====================================================

Create a GameSettings Resource containing:

master volume

music volume

sfx volume

brightness

fullscreen

language

controller vibration

camera shake intensity

The game should be able to save/load these later.

====================================================
SAVE SYSTEM
====================================================

Create the architecture only.

Support future saving of:

chapter

checkpoint

player position

inventory

fuel

collectibles

settings

No implementation yet.

====================================================
SCENE LOADER
====================================================

Create SceneManager capable of:

Load scene

Unload scene

Fade transition

Async loading support (future)

Signal when loading completes

====================================================
DEBUG SYSTEM
====================================================

Create Debug.gd utility.

Support:

print_info()

print_warning()

print_error()

Toggle debug mode.

====================================================
PLAYER PLACEHOLDER
====================================================

Create an empty CharacterBody3D player.

Only include:

CollisionShape3D

MeshInstance3D capsule

AnimationPlayer

AnimationTree

No movement yet.

====================================================
CAMERA PLACEHOLDER
====================================================

Create:

CameraRig

SpringArm3D

Camera3D

Side-view setup.

No movement yet.

====================================================
LIGHTING PLACEHOLDER
====================================================

Create:

DirectionalLight3D

WorldEnvironment

Placeholder lantern node

No gameplay.

====================================================
README
====================================================

Generate:

Project structure documentation.

Folder purpose.

Naming conventions.

Scene naming.

Script naming.

Signal naming.

Variable naming.

Coding conventions.

Commit conventions.

====================================================
GIT
====================================================

Generate:

.gitignore

Recommended Git workflow.

Branch strategy.

====================================================
OUTPUT FORMAT
====================================================

For every step:

1. Explain why the file exists.

2. Show the folder path.

3. Generate the code.

4. Explain inspector settings.

5. Explain testing steps.

6. Wait for confirmation before generating the next feature.

Never skip explanations.

Never generate unrelated systems.

Never move ahead without confirmation.