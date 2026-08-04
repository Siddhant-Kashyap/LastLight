extends Node

# Physics layers (matches Project Settings > Layer Names > 3D Physics)
const PLAYER_LAYER: int = 1
const ENEMY_LAYER: int = 2
const INTERACTION_LAYER: int = 3
const ENVIRONMENT_LAYER: int = 4

# Physics
const DEFAULT_GRAVITY: float = 9.8

# Lighting
const MAX_LIGHT_INTENSITY: float = 10.0
const MIN_LIGHT_INTENSITY: float = 0.0
const DEFAULT_LANTERN_ENERGY: float = 2.0

# Player stats
const MAX_HEALTH: float = 100.0
const MAX_SANITY: float = 100.0
const MAX_FUEL: float = 100.0

# Item IDs
const ITEM_BULLET: String = "bullet"
const ITEM_KEY_PREFIX: String = "key_"
const ITEM_LOG_PREFIX: String = "log_"

# Kill plane
const KILL_PLANE_Y: float = -12.0

# Persistence
const SAVE_FILE_VERSION: int = 1
const SAVE_PATH: String = "user://save_data.tres"
const SETTINGS_PATH: String = "user://game_settings.tres"
