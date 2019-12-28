extends Node



func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pantalla_inicio_nuevaPartida():
	get_tree().change_scene("res://Scenes/Mail_Invitacion/Scenes/Mail_Invitacion.tscn")

func _on_Pantalla_inicio_continuar():
	pass # Replace with function body.
