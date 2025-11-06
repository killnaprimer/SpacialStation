extends Node3D
class_name LootContainer

const PICKUP = preload("uid://bsna0omfl3esi") #this is pickup btw

@export_category("Loot")
@export var loot_table : LootTable
@export var loot_count : int = 1
@export var loot_spawn_point : Marker3D
@export var spawn_range : float = 0.5

@export_category("Visuals")
@export var anim : AnimationPlayer
var spawn_timer : Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", drop_all)

func open():
	if anim : anim.play("open")
	#remove_from_group("interactive")
	spawn_timer.start(0.2)

func drop_all():
	for i in loot_count:
		drop_loot()

func drop_loot():
	var loot = loot_table.get_random_loot()
	var pickup : Pickup = PICKUP.instantiate()
	pickup.loot = loot
	GameManager.get_world().add_child(pickup)
	pickup.update()
	var offset = Vector3(randf_range(-spawn_range, spawn_range), 0 , randf_range(-spawn_range, spawn_range))
	pickup.global_position = loot_spawn_point.global_position + offset
