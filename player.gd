class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera : Camera_Root

var gravity_object = null
var gravity_dir := Vector3.DOWN

var impulse := Vector3.ZERO

func _physics_process(delta):
	if not camera:
		return
		
	if gravity_object:
		gravity_dir = gravity_object.get_gravity_dir(global_position)
	else:
		gravity_dir = Vector3.DOWN
		
	up_direction = -gravity_dir
	var basis_target = global_basis
	basis_target.y = -gravity_dir
	basis_target.z = basis_target.z.slide(basis_target.y).normalized()
	basis_target.x = basis_target.y.cross(basis_target.z)
	global_basis = global_basis.slerp(basis_target, 0.5)
	
	# Add the gravity.
	if is_on_floor():
		velocity += gravity_dir * 0.1
	else:
		velocity += gravity_dir * gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity = velocity.slide(gravity_dir)
		velocity -= gravity_dir * JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var camera_basis = camera.get_camera_basis_for_controller()
	
	var direction = ((camera_basis.x * input_dir.x) + (camera_basis.z * input_dir.y)).normalized() #(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var h_velocity = velocity.slide(gravity_dir)
	var v_velocity = velocity.project(gravity_dir)
		
	if not input_dir.is_equal_approx(Vector2.ZERO):
		h_velocity = (direction * SPEED)
	else:
		h_velocity = h_velocity.move_toward(Vector3.ZERO, SPEED)
		
	h_velocity = h_velocity.slide(gravity_dir)
	
	velocity = h_velocity + v_velocity + impulse
	impulse = impulse.move_toward(Vector3.ZERO, SPEED)

	move_and_slide()

func apply_central_impulse(force):
	impulse = force

func set_gravity_object(obj):
	gravity_object = obj
	
