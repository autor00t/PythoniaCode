extends Control

var mapa_pressed = false
var menu_pressed = false

func EscribirError(linea, value):
	$Error.text += " (line" + str(linea) + ")\n" + value

func _on_Mapa_pressed():
	mapa_pressed = true

func _on_Menu_pressed():
	menu_pressed = true

func MapaPressed():
	return mapa_pressed

func MenuPressed():
	return menu_pressed