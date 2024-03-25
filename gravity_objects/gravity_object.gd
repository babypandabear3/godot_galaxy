class_name Gravity_Object
extends Area3D

enum _GRAVITY_TYPE {
	LOCAL_DOWN,
	SPHERE,
	PATH3D
}

@export var gravity_type : _GRAVITY_TYPE = _GRAVITY_TYPE.LOCAL_DOWN

var path : Path3D
var curve : Curve3D

func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	
	var tmp = find_children("*", "Path3D")
	if tmp.size() > 0:
		path = tmp.front()
		curve = path.curve
		
func _body_entered(body):
	if body.has_method("set_gravity_object"):
		body.set_gravity_object(self)
	
func _body_exited(body):
	if body.has_method("set_gravity_object"):
		body.set_gravity_object(null)
		
func get_gravity_dir(body_position):
	match gravity_type:
		_GRAVITY_TYPE.LOCAL_DOWN:
			return -global_transform.basis.y
		_GRAVITY_TYPE.SPHERE:
			return body_position.direction_to(global_position)
		_GRAVITY_TYPE.PATH3D:
			return get_path_gravity_dir(body_position)

func get_path_gravity_dir(body_position):
	var local_t = path.to_local(body_position)
	var closest = curve.get_closest_point(local_t)
	var global_closest = path.to_global(closest)  #closest_transform.origin
	var gravity_dir = body_position.direction_to(global_closest)
	return gravity_dir
