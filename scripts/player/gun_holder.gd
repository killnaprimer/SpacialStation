extends Node3D
class_name GunHolder
@export var gun : Gun
@export var melee : Melee
@export var character : Character
@export var mouse_aim : MouseAim

#Aiming
var line_mesh: ImmediateMesh
var line_mesh_instance : MeshInstance3D
@export var material : Material
var ray : RayCast3D

#State
var is_aiming : bool
var aim_pos : Vector3
var aim_hit_pos : Vector3
var reload_timer : Timer

#Signals
signal on_reload(is_reloading : bool)
signal on_reload_process(time_left : float, time_total : float)

func _ready():
	make_ray()
	make_line()
	await get_tree().process_frame
	gun.connect("on_fire", GameManager.get_camera().make_tween)
	connect("on_reload", GameManager.ui.character_panel.set_reloading)
	connect("on_reload_process", GameManager.ui.character_panel.set_reload_progress)
	
	reload_timer = Timer.new()
	add_child(reload_timer)
	reload_timer.one_shot = true
	reload_timer.connect("timeout", reload_end)

func _physics_process(delta: float) -> void:
	aim_pos = mouse_aim.get_aim_point() + position
	look_at(aim_pos, Vector3.UP)
	aim_hit_pos = direct_ray()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"): shoot()
	if Input.is_action_just_pressed("reload"): reload()
	if !reload_timer.is_stopped():
		emit_signal("on_reload_process", reload_timer.time_left, gun.loot.reload_time)
	aim()

func aim():
	is_aiming = Input.is_action_pressed("aim")
	character.is_aiming = is_aiming
	show_line(is_aiming)
	draw_line(Vector3(0,0,-0.75), aim_hit_pos)
		
func shoot():
	if is_aiming:
		if gun.loot.ammo_count > 0:
			gun.fire()
		else:
			reload()
	else: kick()

func kick():
	melee.hit()

func reload():		
	if reload_timer.is_stopped():
		reload_timer.start(gun.loot.reload_time)
		emit_signal("on_reload", true)

func reload_end():
	gun.loot.ammo_count = gun.loot.mag_size
	emit_signal("on_reload", false)
	gun.emit_signal("on_bullet_spent", gun.loot.ammo_count, gun.loot.mag_size)


#region Ray Aim Confirm
func make_ray():
	ray = RayCast3D.new()
	add_child(ray)
	ray.position = Vector3.ZERO
	ray.set_collision_mask_value(1, true)
	ray.set_collision_mask_value(2, true)
	ray.set_collision_mask_value(4, true)

func direct_ray() -> Vector3:
	ray.target_position = Vector3(0,0,-20)
	ray.force_raycast_update()
	if ray.is_colliding():
		return ray.get_collision_point()
	else:
		return aim_pos
#endregion

#region Aim Line Drawing
func make_line():
	line_mesh = ImmediateMesh.new()
	line_mesh_instance = MeshInstance3D.new()
	line_mesh_instance.mesh = line_mesh
	line_mesh_instance.material_override = material
	add_child(line_mesh_instance)

func draw_line(start_pos : Vector3, end_pos : Vector3):
	line_mesh.clear_surfaces()
	line_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	line_mesh.surface_add_vertex(start_pos)
	line_mesh.surface_add_vertex(to_local(end_pos))
	line_mesh.surface_end()

func show_line(is_shown : bool):
	line_mesh_instance.visible = is_shown

func add_gun(new_gun : Gun):
	if gun:
		if reload_timer and !reload_timer.is_stopped():
			reload_timer.stop()
			emit_signal("on_reload", false)
		gun.loot.equipped = false
		gun.queue_free()
	add_child(new_gun)
	new_gun.position = Vector3(0,0,-0.75)
	gun = new_gun
	gun.loot.equipped = true
	gun.connect("on_spread_changed", GameManager.ui.cursor.set_spread)
	gun.connect("on_fire", GameManager.get_camera().make_tween)
	gun.connect("on_bullet_spent", GameManager.ui.character_panel.set_ammo)
	gun.emit_signal("on_bullet_spent", gun.loot.ammo_count, gun.loot.mag_size)
#endregion
