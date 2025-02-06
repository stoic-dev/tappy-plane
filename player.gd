extends RigidBody2D

var impulse_force: int = 600

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('click'):
		apply_central_impulse(Vector2.UP * impulse_force)
