extends CharacterBody2D

@export var move_speed = 100
@export var rotation_speed = 3

@onready var shield: Area2D = $Shield
@export var shield_radius: float = 50.0

var is_shield_attacking = false
@export var shield_push_distance = 20.0
@export var shield_push_time = 0.05
@export var shield_return_time = 0.03

@export var recharge_time = 1.0
@onready var timer: Timer = $Shield/Timer

@export var push_force: float = 300.0

func _physics_process(delta: float) -> void:
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * move_speed
	
	if Input.is_action_just_pressed("push"):
		if timer.is_stopped():
			push_shield_position()
	
	move_and_slide()

	if !is_shield_attacking:
		rotate_shield_towards_mouse(delta)
		update_shield_position()

func rotate_shield_towards_mouse(delta):
	var mouse_pos = get_global_mouse_position()
	var local_mouse_pos = to_local(mouse_pos)
	
	var target_angle = local_mouse_pos.angle()
	
	# Плавный поворот с ограниченной скоростью
	var angle_diff = wrapf(target_angle - shield.rotation, -PI, PI)
	var rotation_step = rotation_speed * delta
	shield.rotation += clamp(angle_diff, -rotation_step, rotation_step)
	
func update_shield_position():
	# Позиционируем щит на окружности вокруг персонажа
	var offset = Vector2.RIGHT.rotated(shield.rotation) * shield_radius
	shield.position = offset

func push_shield_position():
	timer.start(recharge_time)
	
	is_shield_attacking = true
	var initial_pos = shield.position
	var target_pos = initial_pos + Vector2.RIGHT.rotated(shield.rotation) * shield_push_distance
	
	var tween = create_tween()
	tween.tween_property(shield, "position", target_pos, shield_push_time)
	tween.tween_property(shield, "position", initial_pos, shield_return_time)
	await tween.finished
	is_shield_attacking = false


func _on_shield_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") && is_shield_attacking:
		var direction = Vector2.RIGHT.rotated(shield.rotation)
		apply_push_effect(body, direction)

func apply_push_effect(target: Node2D, direction: Vector2):
	if target.has_method("on_pushed"):
		target.on_pushed(direction, push_force)
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		get_tree().call_deferred("reload_current_scene")
