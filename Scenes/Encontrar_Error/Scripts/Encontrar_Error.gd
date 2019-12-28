extends Node
#La variable lineas_codigo es una lista en la cual cada linea es un elemento
#Para indentar el string no usar tab ya que godot da problemas, en vez usar 4 espacios
var lineas_codigo = [
	"1. def mayor(x y):",
	"2.     if x > y:",
	"3.         return x",
	"4.     else:",
	"5.         return y",
	"6. num1 = 10",
	"7. num2 = 20",
	"8. print(mayor(num1, num2))"
]
#La variable resultado_error sería una string con lo que diría el interpretador de Python 3 al ejecutar el código
var resultado_error = "SyntaxError: invalid syntax"
#La variable texto es una string en la cual se plantea el enunciado
var texto = "Se tiene una función que retorna el mayor número de los parametros ingresados para luego usar esta función en el programa.\nPero hay un error, encuentralo!"


var linea_error = 1
var linea_seleccionada
onready var contenedor = $UI/Panel/VBoxContainer
var temp_resource_linea = preload("res://Scenes/Encontrar_Error/Scenes/Linea.tscn")
onready var respuesta = $UI/Respuesta
onready var error_encontrado = $Error_Encontrado
var desafio_resuelto = false
var gano
signal salir_mapa
signal salir_menu

func _ready():
	for linea in lineas_codigo:
		var temp = temp_resource_linea.instance()
		contenedor.add_child(temp)
		temp.SetText(linea)
		
	linea_error -= 1
	
	respuesta.get_node("Correct_Sprite").hide()
	respuesta.get_node("Wrong_Sprite").hide()
	
	error_encontrado.hide()
	$Planteamiento_Problema.SetTexto(texto)

func _process(delta):
	var botones_lineas = contenedor.get_children()
	
	var i = 0
	var bandera = true
	while i < contenedor.get_child_count():
		if bandera:
			if botones_lineas[i].GetPressed() and i != linea_seleccionada:
				linea_seleccionada = i
				bandera = false
			else:
				botones_lineas[i].SetPressed(false)
		else:
			botones_lineas[i].SetPressed(false)
		
		i += 1
	if linea_seleccionada != null:
		botones_lineas[linea_seleccionada].SetPressed(true)
	
	if gano != null and !desafio_resuelto:
		if gano:
			desafio_resuelto = true
			respuesta.get_node("Correct_Sprite").show()
			yield(get_tree().create_timer(1.0), "timeout")
			respuesta.hide()
			error_encontrado.EscribirError(linea_error + 1, resultado_error)
			error_encontrado.show()
		else:
			respuesta.get_node("Wrong_Sprite").show()
			yield(get_tree().create_timer(1.0), "timeout")
			gano = null
			respuesta.get_node("Wrong_Sprite").hide()
			$UI/Button.disabled = false
	
	if desafio_resuelto:
		if error_encontrado.MapaPressed():
			emit_signal("salir_mapa")
			queue_free()
		if error_encontrado.MenuPressed():
			emit_signal("salir_menu")
			queue_free()

func _on_Button_pressed():
	if linea_seleccionada == linea_error:
		gano = true
	else:
		gano = false
	$UI/Button.disabled = true

func _on_Planteamiento_Problema_empezar():
	$AnimationPlayer.play("Empezar")
