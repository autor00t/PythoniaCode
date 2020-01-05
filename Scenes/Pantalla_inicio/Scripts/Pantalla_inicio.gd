extends Node

signal continuar
signal nuevaPartida

func _ready():
	$AnimationPlayer.play("Titulo")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$Continuar.disabled = false
	$Continuar.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$NuevaPartida.disabled = false
	$NuevaPartida.visible = true

func _on_NuevaPartida_pressed():
	emit_signal("nuevaPartida")

func _on_Continuar_pressed():
	emit_signal("continuar")
