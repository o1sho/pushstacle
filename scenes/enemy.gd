extends RigidBody2D



func take_damage(direction: Vector2, force: float):
	apply_central_impulse(direction * force)
