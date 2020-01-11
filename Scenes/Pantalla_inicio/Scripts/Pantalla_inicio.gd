extends Node

signal continuar
signal nuevaPartida
onready var main = get_node("/root/Main")

func _ready():
	$AnimationPlayer.play("Titulo")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$Continuar.disabled = false
	$Continuar.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$NuevaPartida.disabled = false
	$NuevaPartida.visible = true
	$".".connect("nuevaPartida", main, "_on_Pantalla_inicio_nuevaPartida")
	$".".connect("continuar", main, "_on_Pantalla_inicio_continuar")
	
func _on_NuevaPartida_pressed():
	emit_signal("nuevaPartida")

func _on_Continuar_pressed():
	emit_signal("continuar")