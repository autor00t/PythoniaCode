extends Node
#La variable codigo_ordenado es una lista donde cada elemento es una lista
#Para indentar el string no usar el tab ya que godot da problemas, en vez usar 4 espacios
var codigo_ordenado = [
	"def mayor(x, y):",
	"    if x > y:",
	"        return x",
	"    else:",
	"        return y",
	"num1 = 10",
	"num2 = 20",
	"print(mayor(num1, num2))" 
]
#La variable texto es una string con el enunciado
var texto = "Se tiene una función que recibe 2 parametros, de los cuales retorna el mayor. Esta función es luego aplicada en el programa para encontrar el número mayor entre 2 variables.\nPero esta desordenado el programa, ordenalo!"
#La variable cantidad_maxima_saltos debe ser igual a la mayor cantidad de indentaciones que tiene una línea
var cantidad_maxima_saltos = 2
#La variable mas_opciones se deja en true si es que hay varias maneras de que funcione el programa
#En caso de ser false, ignorar la variable opciones_codigo_ordenado
var mas_opciones = true
#La variable opciones_codigo_ordenado es una lista en la cual cada elemento es otra lista con el mismo formato de la varibale codigo ordenado
#Se ponen las otras opciones en las cuales el ejercicio también estaría correcto
var opciones_codigo_ordenado = [[
	"def mayor(x, y):",
	"    if x > y:",
	"        return x",
	"    else:",
	"        return y",
	"num2 = 20",
	"num1 = 10",
	"print(mayor(num1, num2))" 
]]















var codigo_desordenado = []
var linea_seleccionada
onready var contenedor = $UI/Panel/VBoxContainer
onready var respuesta = $UI/Respuesta
var temp_resource_linea = preload("res://Scenes/Ordenar_Codigo/Scenes/Linea.tscn")
var botones_lineas = []
var contador_saltos = []
var desafio_resuelto = false
var gano
signal salir_menu
signal salir_mapa

func QuitarEspacios(linea):
	var i = 4
	var temp = ""
	while i < linea.length():
		temp += linea[i]
		i += 1
	return temp

func _ready():
	$AnimationPlayer.play("Iniciar")
	randomize()
	codigo_desordenado = codigo_ordenado.duplicate()
	codigo_desordenado.shuffle()
	for linea in codigo_desordenado:
		while linea[0] == " ":
			linea = QuitarEspacios(linea)
		var temp = temp_resource_linea.instance()
		contenedor.add_child(temp)
		temp.SetText(linea)
	
	respuesta.get_node("Correct_Sprite").hide()
	respuesta.get_node("Wrong_Sprite").hide()
	
	for i in range(codigo_desordenado.size()):
		contador_saltos.append(0)
	
	$Codigo_Ordenado.hide()
	$Planteamiento_Problema.SetTexto(texto)

func _process(delta):
	botones_lineas = contenedor.get_children()
	
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
			$Codigo_Ordenado.show()
		else:
			respuesta.get_node("Wrong_Sprite").show()
			yield(get_tree().create_timer(1.0), "timeout")
			gano = null
			respuesta.get_node("Wrong_Sprite").hide()
			$UI/Arriba.disabled = false
			$UI/Abajo.disabled = false
			$UI/Izquierda.disabled = false
			$UI/Derecha.disabled = false
			$UI/Comprobar.disabled = false
			
	if desafio_resuelto:
		if $Codigo_Ordenado.MapaPressed():
			emit_signal("salir_mapa")
			queue_free()
		if $Codigo_Ordenado.MenuPressed():
			emit_signal("salir_menu")
			queue_free()
			
func _on_Arriba_pressed():
	if linea_seleccionada != 0:
		linea_seleccionada -= 1
		contenedor.move_child(botones_lineas[linea_seleccionada + 1], linea_seleccionada)


func _on_Abajo_pressed():
	if linea_seleccionada != codigo_desordenado.size():
		linea_seleccionada += 1
		contenedor.move_child(botones_lineas[linea_seleccionada - 1], linea_seleccionada)


func _on_Izquierda_pressed():
	if botones_lineas[linea_seleccionada].HaciaIzquierda():
		contador_saltos[linea_seleccionada] -= 1


func _on_Derecha_pressed():
	if contador_saltos[linea_seleccionada] < cantidad_maxima_saltos:
		botones_lineas[linea_seleccionada].HaciaDerecha()
		contador_saltos[linea_seleccionada] += 1

func _on_Comprobar_pressed():
	gano = true
	if mas_opciones:
		var i = 0
		while i < opciones_codigo_ordenado.size() and gano:
			var j = 0
			while j < opciones_codigo_ordenado[i].size() and gano:
				if opciones_codigo_ordenado[i][j] != botones_lineas[j].GetText() and codigo_ordenado[j] != botones_lineas[j].GetText():
					gano = false
				j += 1
			i += 1
	else:
		var i = 0
		while i < codigo_ordenado.size() and gano:
			if codigo_ordenado[i] != botones_lineas[i].GetText():
				gano = false
			i += 1
			
	$UI/Arriba.disabled = true
	$UI/Abajo.disabled = true
	$UI/Izquierda.disabled = true
	$UI/Derecha.disabled = true
	$UI/Comprobar.disabled = true

func _on_Planteamiento_Problema_empezar():
	$AnimationPlayer.play("Empezar")
