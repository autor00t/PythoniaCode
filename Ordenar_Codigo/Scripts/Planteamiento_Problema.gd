extends Control

signal empezar
func _on_Empezar_pressed():
	$Panel/Empezar.disabled = true
	emit_signal("empezar")

func SetTexto(value):
	$Panel/Panel/Problema.text = value