extends Node

func _ready():
	$AnimationPlayer.play("Personaje")
	yield(get_node("AnimationPlayer"), "animation_finished")
	$Personaje.playing = true
	$AnimationPlayer.play("Texto")
	yield(get_node("AnimationPlayer"), "animation_finished")
	yield(get_tree().create_timer(3), "timeout")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
