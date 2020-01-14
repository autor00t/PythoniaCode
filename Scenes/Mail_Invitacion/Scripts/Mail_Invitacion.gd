extends Node

signal listo

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$Animacion_Carta.playing = true
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("Carta")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$Animacion_Texto.visible = true
	$Animacion_Texto.playing = true
	yield(get_tree().create_timer(4), "timeout")
	
	$Mail.visible = true
	$AnimationPlayer.play("Mail")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Animacion_Carta.visible = false
		$Animacion_Texto.visible = false
		$AnimationPlayer.play_backwards("Mail")
		yield(get_node("AnimationPlayer"), "animation_finished")
		$".".queue_free()
		emit_signal("listo")