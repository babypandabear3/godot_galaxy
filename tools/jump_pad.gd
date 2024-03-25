extends MeshInstance3D

@export var force : float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_jump_pad_area_body_entered(body):
	if body.has_method("apply_central_impulse"):
		body.apply_central_impulse(global_basis.y * force)
	pass # Replace with function body.
