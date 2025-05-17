extends NodeState

@export var character: NonPlayableCharacter
@export var navigation_agent_2d: NavigationAgent2D

@export var push_state_time_interval: float = 1.5
@onready var push_state_timer: Timer = Timer.new()
var push_state_timeout: bool = false

var current_impulse := Vector2.ZERO
@export var impulse_decay_rate := 0.9  # Скорость затухания (0.9 = 10% потерь за кадр)
@export var impulse_threshold := 10.0  # Минимальная сила для остановки

func _ready() -> void:
	character.is_pushed.connect(on_pushed)
	
	push_state_timer.wait_time = push_state_time_interval
	push_state_timer.timeout.connect(on_push_state_timeout)
	add_child(push_state_timer)

func _physics_process(delta: float) -> void:
	# Применяем импульс к скорости
	if current_impulse.length() > impulse_threshold:
		character.velocity += current_impulse
		current_impulse *= impulse_decay_rate  # Постепенное затухание
		character.move_and_slide()
	else:
		current_impulse = Vector2.ZERO

func _on_next_transitions() -> void:
	if push_state_timeout:
		transition.emit("Walk")

func _on_enter() -> void:
	character.velocity = Vector2.ZERO
	navigation_agent_2d.velocity = Vector2.ZERO
	
	animated_sprite_2d.play("push")
	character.velocity = Vector2.ZERO
	
	push_state_timeout = false
	push_state_timer.start()

func _on_exit() -> void:
	animated_sprite_2d.stop()
	push_state_timer.stop()

func on_push_state_timeout() -> void:
	push_state_timeout = true

func on_pushed(direction: Vector2, force: float):
	current_impulse += direction.normalized() * force
