extends Button

var is_pressed = false

func HaciaDerecha():
	$".".text = "    " + $".".text

func HaciaIzquierda():
	if $".".text[0] == " ":
		var i = 4
		var temp = ""
		while i < $".".text.length():
			temp += $".".text[i]
			i += 1
		$".".text = temp
		return true

func SetPressed(value):
	is_pressed = value

func GetPressed():
	return is_pressed

func SetText(value):
	$".".text = value

func GetText():
	return $".".text

func _process(delta):
	$".".pressed = is_pressed

func _on_Linea_pressed():
	is_pressed = true