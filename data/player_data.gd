extends Resource
class_name PlayerData
@export var current_health : int
@export var loot : Array[LootItem]
enum PLAYER_STATS {STR, DEX, TOUGH, INT}
@export var stats : Dictionary [PLAYER_STATS, int] = {
	PLAYER_STATS.STR : 1,
	PLAYER_STATS.DEX : 1,
	PLAYER_STATS.TOUGH : 1,
	PLAYER_STATS.INT : 1
}
