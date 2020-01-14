extends Node

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func cambiar_nodo(original, nuevo):
	var level = $".".get_node(original)
	$".".remove_child(level)
	level.call_deferred("free")
	
	$".".add_child(nuevo)

func Mapa0_listo():
	load_game("Mapa0")

func Mapa1_listo():
	var original = "Mapa1"
	var next_level_resource = load("res://Scenes/Mapa0/Scenes/Mapa0.tscn")
	var nuevo = next_level_resource.instance()
	nuevo.connect("volver_mapa", self, "volver_Mapa0")
	nuevo.connect("listo", self, "Mapa0_listo")
	nuevo.saved_mapa = 1
	cambiar_nodo(original, nuevo)

func volver_Mapa0():
	var datos = load_datos()
	if datos[0] == 0:
		load_game("Mapa0")
	else:
		var original = "Mapa0"
		var next_level_resource = load("res://Scenes/Mapa0/Scenes/Mapa0.tscn")
		var nuevo = next_level_resource.instance()
		nuevo.connect("volver_mapa", self, "volver_Mapa0")
		nuevo.connect("listo", self, "Mapa1_listo")
		nuevo.saved_mapa = datos[0]
		cambiar_nodo(original, nuevo)

func volver_Mapa1():
	var datos = load_datos()
	if datos[0] == 1:
		load_game("Mapa1")
	else:
		var original = "Mapa1"
		var next_level_resource = load("res://Scenes/Mapa1/Scenes/Mapa1.tscn")
		var nuevo = next_level_resource.instance()
		nuevo.connect("volver_mapa", self, "volver_Mapa1")
		nuevo.connect("listo", self, "Mapa1_listo")
		nuevo.saved_mapa = datos[0]
		cambiar_nodo(original, nuevo)

func _on_Pantalla_inicio_nuevaPartida():
	var original = "Pantalla_inicio"
	var next_level_resource = load("res://Scenes/Mail_Invitacion/Scenes/Mail_Invitacion.tscn")
	var nuevo = next_level_resource.instance()
	nuevo.connect("listo", self, "iniciar_mapa_0")
	cambiar_nodo(original, nuevo)
	
func iniciar_mapa_0():
	var original = "Mail_Invitacion"
	var next_level_resource = load("res://Scenes/Mapa0/Scenes/Mapa0.tscn")
	var nuevo = next_level_resource.instance()
	nuevo.connect("volver_mapa", self, "volver_Mapa0")
	nuevo.connect("listo", self, "Mapa0_listo")
	cambiar_nodo(original, nuevo)

func _on_Pantalla_inicio_continuar():
	load_game("Pantalla_inicio")

func load_game(original):
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line != null:
			if current_line["mapa"] == 0:
			
				var next_level_resource = load("res://Scenes/Mapa0/Scenes/Mapa0.tscn")
				var nuevo = next_level_resource.instance()
				nuevo.saved_nivel = current_line["nivel"]
				nuevo.saved_mapa = current_line["mapa"]
				nuevo.connect("listo", self, "Mapa0_listo")
				nuevo.connect("volver_mapa", self, "volver_Mapa0")
				cambiar_nodo(original, nuevo)
			elif current_line["mapa"] == 1:
			
				var next_level_resource = load("res://Scenes/Mapa1/Scenes/Mapa1.tscn")
				var nuevo = next_level_resource.instance()
				nuevo.saved_nivel = current_line["nivel"]
				nuevo.saved_mapa = current_line["mapa"]
				nuevo.connect("listo", self, "Mapa1_listo")
				nuevo.connect("volver_mapa", self, "volver_Mapa1")
				cambiar_nodo(original, nuevo)
	save_game.close()

func load_datos():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line != null:
			return [current_line["mapa"], current_line["nivel"]]
			
	save_game.close()