extends Node

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pantalla_inicio_nuevaPartida():
	get_tree().change_scene("res://Scenes/Mail_Invitacion/Scenes/Mail_Invitacion.tscn")

func _on_Pantalla_inicio_continuar():
	load_game()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line != null:
			if current_line["mapa"] == 0:
				var level = $".".get_node("Pantalla_inicio")
				$".".remove_child(level)
				level.call_deferred("free")
			
				var next_level_resource = load("res://Scenes/Mapa0/Scenes/Mapa0.tscn")
				var next_level = next_level_resource.instance()
				next_level.saved_nivel = current_line["nivel"]
				next_level.saved_mapa = current_line["mapa"]
				$".".add_child(next_level)
			elif current_line["mapa"] == 1:
				var level = $".".get_node("Pantalla_inicio")
				$".".remove_child(level)
				level.call_deferred("free")
			
				var next_level_resource = load("res://Scenes/Mapa1/Scenes/Mapa1.tscn")
				var next_level = next_level_resource.instance()
				next_level.saved_nivel = current_line["nivel"]
				next_level.saved_mapa = current_line["mapa"]
				$".".add_child(next_level)
	save_game.close()