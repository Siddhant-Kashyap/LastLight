LAST LIGHT — PHASE 2: PLAYER CONTROLLER V1

We have completed and validated the project foundation for Last Light.

Godot: 4.5 Stable
Language: GDScript 2.0
Player base: CharacterBody3D
Game: 2.5D horror platformer

The existing project structure, managers, input map, Constants, Debug utility,
Main scene, Player placeholder, CameraRig placeholder, and Lighting placeholder
are already working.

DO NOT recreate or restructure the project foundation.

Your task is ONLY:

Build a polished Player Controller V1.

==================================================
GOAL
==================================================

Create responsive 2.5D platforming movement suitable for a commercial
cinematic horror platformer.

The player uses CharacterBody3D.

Movement must remain constrained to a 2.5D plane.

For now the player can only:

Move
Jump
Double Jump
Fall

Do not implement unrelated gameplay systems.

==================================================
MOVEMENT
==================================================

Implement:

- Left/right movement
- Smooth acceleration
- Smooth deceleration
- Air control
- Gravity
- Maximum fall speed
- Ground detection
- Movement constrained to the game's side-view plane

The player must NEVER drift into the depth axis.

Use move_and_slide() correctly for Godot 4.5 CharacterBody3D.

Do not manually multiply velocity by delta when passing movement to
move_and_slide().

==================================================
JUMP SYSTEM
==================================================

Implement:

Jump

Coyote Time

Allow jumping briefly after walking off a platform.

Export:

coyote_time: float = 0.12


Jump Buffering

If jump is pressed slightly before landing, automatically jump when the player
touches the ground.

Export:

jump_buffer_time: float = 0.12


Variable Jump Height

Holding jump produces a higher jump.

Releasing jump early produces a shorter jump.


Double Jump

Export:

enable_double_jump: bool = true

When enabled:

Ground Jump
↓
Air Jump

When disabled:

Only ground jump.

Reset available air jumps after landing.

==================================================
MOVEMENT CONFIGURATION
==================================================

Expose important tuning values in the Inspector.

Example starting values:

move_speed
ground_acceleration
ground_deceleration
air_acceleration
air_deceleration
jump_velocity
gravity
max_fall_speed
coyote_time
jump_buffer_time
jump_cut_multiplier
enable_double_jump

Organize exported properties using categories/groups where appropriate.

Do not scatter magic numbers throughout the controller.

==================================================
INPUT
==================================================

Use the existing Input Map.

move_left
move_right
jump

Use Input.get_axis("move_left", "move_right") for horizontal input.

Do not recreate input actions unless they are actually missing.

==================================================
2.5D CONSTRAINT
==================================================

The game is visually 3D but mechanically side-scrolling.

Choose one horizontal world axis for player movement based on the existing
scene orientation.

For example:

X = horizontal movement
Y = vertical movement
Z = depth

If the existing project uses this orientation, permanently constrain player
movement along Z.

Do not blindly assume the axis.

Inspect the existing Player/Main/CameraRig scene orientation first.

Explain the chosen coordinate convention.

==================================================
ARCHITECTURE
==================================================

Keep PlayerController focused on locomotion.

Suggested responsibility:

PlayerController.gd
    Input
    Movement
    Jumping
    Ground/Air state information

Do NOT put:

Camera logic
Lantern logic
Health
Inventory
Weapons
Audio
UI
Enemy interaction
Save logic

inside PlayerController.

Expose useful signals if appropriate, such as:

landed
jumped
started_falling
facing_changed

Do not create signals unless they have a clear future consumer.

==================================================
PLAYER STATE
==================================================

Expose enough state for future animation code to determine:

Idle
Running
Jumping
Falling

Do NOT build a complex generic state machine yet.

Movement does not require one at this stage.

Prefer simple locomotion state information that AnimationController can consume
later.

==================================================
FACING
==================================================

Track whether the player is facing left or right.

Do not rotate the CharacterBody3D physics root unnecessarily.

Keep visual orientation separate from physics orientation where practical.

If the Player scene does not already have a visual child/container, create a
clean VisualRoot Node3D for future character models.

==================================================
PLACEHOLDER VISUALS
==================================================

Continue using the placeholder player mesh.

Do not download assets.

Do not create final animations.

If AnimationPlayer/AnimationTree already exist, preserve them.

Do not over-engineer animation until actual character animations exist.

==================================================
PHYSICS
==================================================

Ensure:

- No depth-axis drift
- Stable ground movement
- Stable slopes if encountered
- No accidental infinite jumping
- Double jump resets correctly
- Coyote time cannot be exploited for extra jumps
- Jump buffering works correctly
- Holding jump does not repeatedly trigger jumps
- Falling velocity is capped
- Player does not retain unwanted velocity after landing

Use _physics_process(delta).

==================================================
CODE QUALITY
==================================================

Use typed GDScript.

Godot 4.5 APIs only.

No deprecated APIs.

Use descriptive names.

Keep methods small.

Example structure:

_physics_process()
_read_input()
_update_timers()
_apply_horizontal_movement()
_apply_gravity()
_handle_jump()
_update_locomotion_state()
_apply_depth_constraint()

You may improve this structure if there is a cleaner implementation.

Do not create abstractions merely for the sake of abstraction.

==================================================
DEBUGGING
==================================================

Integrate with the existing Debug utility only if useful.

Do not print every frame.

Useful temporary events may include:

Player jumped
Double jump
Player landed

Debug output must be disableable.

Do not create test utilities or temporary debugging scenes.

==================================================
MANUAL TESTING
==================================================

Do not create a separate test level or development scene.

Do not generate automated tests, validation scripts, or testing utilities.

Assume I will manually test the feature by running the game inside the Godot
editor.

Focus only on implementing the production-ready Player Controller.

==================================================
DOCUMENTATION
==================================================

After implementation, report:

FILES CREATED

FILES MODIFIED

SCENE TREE CHANGES

INPUT ACTIONS USED

EXPORTED VARIABLES

DEFAULT VALUES

SIGNALS

COORDINATE CONVENTION

INSPECTOR SETTINGS

MANUAL TESTING CHECKLIST

KNOWN LIMITATIONS

The manual testing checklist should briefly describe what I should verify in the
game (movement, jump, coyote time, jump buffering, double jump, depth
constraint, etc.).

Do not proceed to Camera, Lantern, Interaction, Enemies, UI, Audio,
or any other feature.

Stop after Player Controller V1 is implemented and wait for my next request.