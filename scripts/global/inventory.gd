extends Node
var loot_items : Array[LootItem]
signal on_loot_changed()

const PISTOL = preload("res://data/guns/pistol.tres")
const SHOTGUN = preload("res://data/guns/shotgun.tres")
const SMG = preload("res://data/guns/smg.tres")

func add_loot(loot : LootItem):
	loot_items.append(loot)
	emit_signal("on_loot_changed")

func _ready() -> void:
	add_loot(PISTOL)
	add_loot(SHOTGUN)
	add_loot(SMG)
