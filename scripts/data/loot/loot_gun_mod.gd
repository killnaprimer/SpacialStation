extends LootItem
class_name LootGunMod

enum MOD_TYPES {ACCURACY, RECOIL, MAGSIZE, FIRERATE, SILENT}
@export var mod_type : MOD_TYPES
@export var mod : float = 1

func modify_gun(gun : LootGun):
	match mod_type:
		MOD_TYPES.ACCURACY:
			gun.base_spread  *= mod
			gun.spread_gain *= mod * 1.5
		MOD_TYPES.RECOIL: gun.recoil_gain  *= mod
		MOD_TYPES.MAGSIZE: gun.mag_size = ceil(float(gun.mag_size) * mod)
		MOD_TYPES.FIRERATE: gun.firing_cooldown *= mod
		MOD_TYPES.SILENT: print("NOTHING FOR YOU SUCKER")

func modify_players_gun(gun : Gun):
	match mod_type:
		MOD_TYPES.ACCURACY:
			gun.base_spread  *= mod
			gun.spread_gain *= mod * 1.5
		MOD_TYPES.RECOIL:
			gun.recoil_base  *= mod
		MOD_TYPES.MAGSIZE:
			gun.mag_size = ceil(float(gun.mag_size) * mod)
		MOD_TYPES.FIRERATE:
			gun.firing_cooldown *= mod
		MOD_TYPES.SILENT: print("NOTHING FOR YOU SUCKER")

func use():
	Inventory.apply_gun_mod(self)
