extends LootItem
class_name LootConsumable

@export var healing_amount : int


func use():
	var player = GameManager.player
	if player.has_node("health"):
		var health : Vitals = player.get_node("health")
		health.restore_health(healing_amount)
		Inventory.remove_loot(self)
