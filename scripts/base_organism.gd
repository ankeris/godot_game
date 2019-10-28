extends KinematicBody
#onready var global = get_node("/root/global")
#onready var networking = get_node("/root/networking")

const MAX_SLOPE_ANGLE = deg2rad(40)
const MAX_STAMINA = 200

# HP Health Points
puppet var hp: int = 100
var hp_max: int = 100
puppet var hp_regenerable: int = 100
var hp_regeneration: int = 1
var hp_regeneration_interval: int = 5
signal hp_changed(hp, hp_reg, hp_max)

# Dodge
puppet var dodging: bool = false
var dodge_stamina: float = 10
var dodge_speed: float = 8

# Jump
puppet var jumping: bool = false
var jump_stamina: float = 15
var jump_speed: float = 10

# Run
puppet var running: bool = false
var run_stamina: float = 5
var run_speed: float = 7.5

# Walk
puppet var walking: bool = false
var walk_speed: float = 5

# Attack
puppet var attacking: bool = false
var attack_speed: float = 1

# Time since latest damage
var time_hit: float = 0

# State
var dead: bool = false
var direction: Vector3 = Vector3()
var velocity: Vector3 = Vector3()

# Other
var interpolation_factor: float = 10  # how fast we interpolate rotations
var animation_node: AnimationPlayer
var previous_origin: Vector3 = Vector3()