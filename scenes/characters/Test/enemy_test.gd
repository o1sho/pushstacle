extends NonPlayableCharacter



func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)

func _physics_process(delta: float) -> void:
	pass
