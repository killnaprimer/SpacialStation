extends Node
var loot_items : Array[LootItem]
signal on_loot_changed()

const PISTOL = preload("res://data/guns/pistol.tres")
const SHOTGUN = preload("res://data/guns/shotgun.tres")
const SMG = preload("res://data/guns/smg.tres")

func add_loot(loot : LootItem):
	if loot is LootAmmo:
		add_ammo(loot)
	else:
		loot_items.append(loot.duplicate())
	emit_signal("on_loot_changed")

func _ready() -> void:
	add_loot(PISTOL)
	add_loot(SHOTGUN)
	add_loot(SMG)

func add_ammo(ammo : LootAmmo):
	for loot in loot_items:
		if loot is LootAmmo:
			if loot.ammo_type == ammo.ammo_type:
				loot.count += ammo.count
				return
	loot_items.append(ammo.duplicate())

func spend_ammo(ammo_type : Gun.ammo_types, ammo_count : int) -> int:
	for loot in loot_items:
		if loot is LootAmmo:
			if loot.ammo_type == ammo_type:
				return loot.take_ammo(ammo_count)
	return 0
