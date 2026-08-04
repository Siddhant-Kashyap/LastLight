# LAST LIGHT --- GAME DESIGN BLUEPRINT (v1.0)

## 1. Vision

**Last Light** is a commercial-quality 2.5D cinematic horror platformer
where **light is the core mechanic**.

The game is built around atmosphere, exploration, environmental
storytelling, puzzles, and psychological horror---not combat.

The player is vulnerable, resources are scarce, and every mechanic
reinforces the relationship between **light and darkness**.

------------------------------------------------------------------------

# 2. Genre

-   2.5D Platformer
-   Psychological Horror
-   Survival Horror
-   Environmental Puzzle
-   Story-driven Adventure

------------------------------------------------------------------------

# 3. Target Platforms

-   Windows
-   Linux
-   Steam Deck
-   Android (later optimization)
-   Web (experimental/demo)

------------------------------------------------------------------------

# 4. Engine

-   Godot 4.7 Stable
-   GDScript 2.0

------------------------------------------------------------------------

# 5. Core Gameplay Loop

``` text
Explore

↓

Discover Environment

↓

Solve Puzzle

↓

Restore Power

↓

Avoid Darkness

↓

Reach Safe Room

↓

Save Progress

↓

Continue Deeper
```

The gameplay loop should remain consistent throughout the game while
introducing new mechanics chapter by chapter.

------------------------------------------------------------------------

# 6. Core Pillars

## Exploration

Players are rewarded for exploring.

Areas contain:

-   Memory Logs
-   Hidden rooms
-   Fuel
-   Story clues
-   Environmental storytelling
-   Secret collectibles

## Survival

The player is never powerful.

Resources are intentionally limited.

Manage:

-   Lantern fuel
-   One bullet
-   Safe locations
-   Environmental hazards

## Horror

Fear should come from:

-   Darkness
-   Audio
-   Uncertainty
-   Environmental storytelling
-   Enemy behavior

Avoid cheap jump scares.

## Puzzle Solving

Every chapter introduces puzzles using:

-   Electricity
-   Machinery
-   Mirrors
-   Light beams
-   Pressure switches
-   Physics
-   Rotating mechanisms
-   Environmental interactions

------------------------------------------------------------------------

# 7. Core Mechanic --- Light

Everything revolves around light.

Light affects:

-   Enemy behavior
-   Puzzles
-   Navigation
-   Hidden paths
-   Story events
-   Atmosphere

The lantern is the central gameplay system.

------------------------------------------------------------------------

# 8. Player

## Character

**Elias Ward**

-   Age: 34
-   Occupation: Electrical Engineer

No military training. No superpowers.

The player survives through intelligence rather than combat.

## Player Abilities

### Current

-   Walk
-   Run
-   Jump
-   Double Jump
-   Coyote Time
-   Jump Buffer
-   Variable Jump
-   Ledge Detection (later)
-   Push Objects
-   Pull Objects
-   Climb Small Obstacles
-   Interact

### Future Mechanics

-   Lantern focus mode
-   Mirror aiming
-   Generator repair
-   Valve rotation
-   Electrical routing

------------------------------------------------------------------------

# 9. Lantern System

The lantern is the game's signature mechanic.

Features:

-   Dynamic light
-   Fuel consumption
-   Flickering
-   Intensity control
-   Radius control
-   Shadow casting
-   Darkness interaction

Future improvements:

-   Longer burn time
-   Wider beam
-   Stable light

No combat upgrades.

------------------------------------------------------------------------

# 10. Enemy Philosophy

No zombies.

Enemies are manifestations of darkness.

Each enemy follows unique gameplay rules.

Examples:

-   Shadow
-   Listener
-   Watcher
-   Mimic
-   Hanging One
-   Echo

Every enemy should feel mechanically distinct.

------------------------------------------------------------------------

# 11. Combat

Combat is extremely limited.

Weapon:

-   Rusty Pistol

Maximum ammunition:

-   One Bullet

The bullet is primarily used for puzzles or emergencies.

Most encounters should encourage avoidance, stealth, or problem solving.

------------------------------------------------------------------------

# 12. Chapters

## Chapter 1 --- Surface

-   Tutorial
-   Movement
-   Lantern
-   Physics
-   No enemies

## Chapter 2 --- Maintenance

-   Fuel
-   First Shadow
-   First chase

## Chapter 3 --- Hospital

-   Psychological horror
-   Medical puzzles
-   The Surgeon

## Chapter 4 --- Subway

-   Moving trains
-   Electric rails
-   Power restoration

## Chapter 5 --- Factory

-   Machinery
-   Steam
-   Conveyors
-   The Welder

## Chapter 6 --- Mine

-   Near-total darkness
-   Sound mechanics
-   Echo enemy

## Chapter 7 --- Research Labs

Scientists created living darkness.

## Final Chapter --- Helios Core

Combines:

-   Platforming
-   Light
-   Stealth
-   Puzzle
-   Boss encounter

------------------------------------------------------------------------

# 13. Boss Design

Bosses are puzzle encounters.

Examples:

-   Tunnel Beast
-   Surgeon
-   Welder
-   Choir
-   The Darkness

------------------------------------------------------------------------

# 14. Collectibles

-   Memory Logs
-   Fuel Tanks
-   Photos
-   Hidden Rooms
-   Developer Secrets

------------------------------------------------------------------------

# 15. Save System

-   Safe Rooms
-   Manual Save
-   Checkpoints
-   Steam Cloud (future)

------------------------------------------------------------------------

# 16. Camera

-   Side-view
-   Smooth follow
-   Camera shake
-   Cinematic movement
-   Boss framing

------------------------------------------------------------------------

# 17. Audio

-   Minimal music
-   Heavy ambience
-   Environmental sounds
-   Silence as a design tool

------------------------------------------------------------------------

# 18. Visual Style

-   Dark industrial environments
-   Heavy fog
-   Long shadows
-   Warm lantern light
-   Cold ambient lighting
-   High contrast
-   Minimal UI

------------------------------------------------------------------------

# 19. UI Philosophy

Display only:

-   Fuel
-   Bullet
-   Interaction prompts

Hide UI whenever possible.

------------------------------------------------------------------------

# 20. Technical Architecture

## Managers

-   GameManager
-   AudioManager
-   SaveManager
-   UIManager
-   SceneManager

## Systems

-   Player
-   Camera
-   Lantern
-   Interaction
-   Inventory
-   Puzzle
-   Enemy AI
-   Dialogue
-   Save
-   Lighting

------------------------------------------------------------------------

# 21. Development Roadmap

## Foundation

-   ✅ Project Setup
-   ✅ Player Controller

## Core Gameplay

1.  Camera Follow System
2.  Lantern System
3.  Player Animation Controller
4.  Interaction System
5.  Inventory Framework
6.  Checkpoint System
7.  Dialogue & Memory Logs
8.  Environmental Objects
9.  Puzzle Framework

## World Systems

10. Doors
11. Elevators
12. Generators
13. Switches
14. Machinery
15. Physics Objects

## Enemy Framework

16. Base Enemy
17. Enemy State Machine
18. Shadow Enemy
19. Listener
20. Mimic
21. Hanging One
22. Watcher
23. Echo

## Horror Systems

24. Dynamic Darkness
25. Audio Events
26. Screen Effects
27. Camera Shake
28. Fear Events

## Chapter Development

29. Chapter 1
30. Chapter 2
31. Chapter 3
32. Chapter 4
33. Chapter 5
34. Chapter 6
35. Chapter 7
36. Final Chapter

## Polish

37. Save/Load
38. Settings
39. Achievements
40. Steam Integration
41. Controller Support
42. Optimization
43. Accessibility
44. Final Balancing
45. Release Candidate

------------------------------------------------------------------------

# 22. Development Principles

-   Build one feature at a time.
-   Never skip foundations.
-   Every system must be modular.
-   Gameplay systems must be reusable.
-   Prefer composition over inheritance.
-   Avoid giant scripts.
-   Keep gameplay logic separate from UI.
-   Use signals for communication.
-   Optimize continuously.
-   Every mechanic must reinforce the core theme of **light versus
    darkness**.
-   Avoid feature creep.
