extends Button

var is_pressed = false

func SetText(value):
	$".".text = value

func GetText():
	return $".".text
	
func SetPressed(value):
	is_pressed = value

func GetPressed():
	return is_pressed

func _process(delta):
	$".".pressed = is_pressed

func _on_Linea_pressed():
	is_pressed = true
