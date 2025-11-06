extends Resource
class_name LootTable
@export var loot : Dictionary [LootItem, int]

func get_random_loot():
	return pick_random_item_by_weight(loot)

func pick_random_item_by_weight(loot_dict: Dictionary [LootItem, int]) -> LootItem:
	# Calculate total weight
	var total_weight: int = 0
	for weight in loot_dict.values():
		total_weight += weight
	
	# If no items or total weight is 0, return null
	if total_weight <= 0:
		return null
	
	# Generate random number between 0 and total_weight
	var random_value: float = randf() * total_weight
	
	# Find which item corresponds to the random value
	var current_weight: float = 0.0
	for item in loot_dict:
		current_weight += loot_dict[item]
		if random_value <= current_weight:
			return item
	
	# Fallback - should rarely reach here
	return null
