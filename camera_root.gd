class_name Camera_Root
extends Node3D

@export var player_path : NodePath
var player : Player
@onready var axis_y = $axis_y
@onready var axis_x = $axis_y/axis_x

@export var mouse_sensitivity : float = 0.01
@export var vertical_angle_min : float = -80.0
@export var vertical_angle_max : float = 35.0

func _ready():
	player = get_node_or_null(player_path)
	if player:
		player.camera = self
	vertical_angle_min = deg_to_rad(vertical_angle_min)
	vertical_angle_max = deg_to_rad(vertical_angle_max)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player:
		return
		
	global_position = player.global_position
	global_basis = global_basis.slerp(player.global_basis, 0.5)

func _input(event):
	if event is InputEventMouseMotion:
		axis_y.rotation.y = wrapf(axis_y.rotation.y - event.relative.x * mouse_sensitivity, -PI, PI)
		axis_x.rotation.x = axis_x.rotation.x - event.relative.y * mouse_sensitivity
		axis_x.rotation.x = clamp(axis_x.rotation.x, vertical_angle_min, vertical_angle_max)

func get_camera_basis_for_controller():
	return axis_y.global_basis
