extends Node

var punto2 = false
var punto3 = false
var punto4 = false
var siguiente_mapa = false

var position = 0
var avanzando = false
var retrocediendo = false

onready var follow = get_node("Control/Recorrido/PathFollow2D")
var scene = preload("res://Scenes/Mapa0/Scenes/Personaje_Ayuda.tscn")
var encontrar_error = preload("res://Scenes/Encontrar_Error/Scenes/Encontrar_Error.tscn")
var ordenar_codigo = preload("res://Scenes/Ordenar_Codigo/Scenes/Ordenar_Codigo.tscn")

var siguiente = false
var anterior = false

var problema #0 = , 1 = gim, 2 = tienda, 3 = puente
var seleccionado = false
var vineta = 0
var corriendo_problema = false

var saved_nivel = -1
var saved_mapa = 1

signal llego_destino

func encontrar_error(texto, lineas_codigo, linea_error, resultado_error):
	$AnimationPlayer.play_backwards("Entrada")
	var encontrar_error_node = encontrar_error.instance()
	encontrar_error_node.texto = texto #String que dice el objetivo
	encontrar_error_node.lineas_codigo = lineas_codigo #lista con cada elemento una linea (parte con i. cada linea, siendo i el número de la linea)
	encontrar_error_node.linea_error = linea_error #numero de la linea que presenta el error
	encontrar_error_node.resultado_error = resultado_error #resultado que arroja python al ejecutar el programa con el error
	
	encontrar_error_node.connect("salir_mapa", self, "salir_mapa")
	encontrar_error_node.connect("salir_menu", self, "salir_menu")
	
	var level0 = $".".get_node("Control")
	var level1 = $".".get_node("AnimationPlayer")
	$".".remove_child(level0)
	$".".remove_child(level1)
	level0.call_deferred("free")
	level1.call_deferred("free")
	
	$".".add_child(encontrar_error_node)
	
	corriendo_problema = true

func ordenar_codigo(codigo_ordenado, texto, cantidad_maxima_saltos, mas_opciones, opciones_codigo_ordenado):
	$AnimationPlayer.play_backwards("Entrada")
	var ordenar_codigo_node = ordenar_codigo.instance()
	ordenar_codigo_node.texto = texto #String que dice el objetivo
	ordenar_codigo_node.codigo_ordenado = codigo_ordenado #lista con cada elemento una linea
	ordenar_codigo_node.cantidad_maxima_saltos = cantidad_maxima_saltos #La mayor cantidad de saltos en el codigo
	ordenar_codigo_node.mas_opciones = mas_opciones #booleano que dice si existen más opciones
	ordenar_codigo_node.opciones_codigo_ordenado = opciones_codigo_ordenado #lista en donde cada elemento es una opcion de codigo (mismo formato codigo_ordenado)
	
	ordenar_codigo_node.connect("salir_mapa", self, "salir_mapa")
	ordenar_codigo_node.connect("salir_menu", self, "salir_menu")
	
	var level0 = $".".get_node("Control")
	var level1 = $".".get_node("AnimationPlayer")
	$".".remove_child(level0)
	$".".remove_child(level1)
	level0.call_deferred("free")
	level1.call_deferred("free")
	
	$".".add_child(ordenar_codigo_node)
	
	corriendo_problema = true

func _ready():
	if saved_nivel == 0 and saved_mapa == 1:
		follow.set_offset(0)
		position = 0
		punto2 = true
	elif saved_nivel == 1 and saved_mapa == 1:
		follow.set_offset(386)
		position = 386
		punto2 = true
		punto3 = true
	elif saved_nivel == 2 and saved_mapa == 1:
		follow.set_offset(614)
		position = 614
		punto2 = true
		punto3 = true
		punto4 = true
	elif saved_nivel == 3 and saved_mapa == 1:
		follow.set_offset(756)
		position = 756
		punto2 = true
		punto3 = true
		punto4 = true
		siguiente_mapa = true
	$AnimationPlayer.play("Entrada")

func _process(delta):
	if Input.is_action_pressed("ui_unlock"):
		save_game(1, 3)
		punto2 = true
		punto3 = true
		punto4 = true
		siguiente_mapa = true
	
	if !seleccionado:
		if follow.get_offset() < position:
			avanzando = true
		elif follow.get_offset() > position:
			retrocediendo = true
		
		if avanzando and retrocediendo:
			follow.set_offset(position)
			avanzando = false
			retrocediendo = false
		elif avanzando:
			follow.set_offset(follow.get_offset() + 200 * delta)
		elif retrocediendo:
			follow.set_offset(follow.get_offset() - 200 * delta)
		
		if follow.get_offset() >= 1550:
			emit_signal("llego_destino")
		
		$Control/numero2.visible = punto2
		$Control/numero3.visible = punto3
		$Control/numero4.visible = punto4
		$Control/Siguiente_Mapa.visible = siguiente_mapa
	elif not corriendo_problema:
		if siguiente:
			siguiente = false
			vineta += 1
		elif anterior:
			anterior = false
			vineta -= 1
		if vineta <= 0:
			$Control/Panel/Flecha2.visible = false
			vineta = 0
		else:
			$Control/Panel/Flecha2.visible = true
	
func _on_numero1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		position = 0

func _on_numero2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if punto2:
			position = 386

func _on_numero3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if punto3:
			position = 614

func _on_numero4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if punto4:
			position = 756

#final = 861.42

func salir_mapa():
	if problema > saved_nivel:
		save_game(0, problema)
	var next_level_resource = load("res://Scenes/Mapa1/Scenes/Mapa1.tscn")
	var next_level = next_level_resource.instance()
	if problema > saved_nivel:
		next_level.saved_nivel = problema
	else:
		next_level.saved_nivel = saved_nivel
	$".".add_child(next_level)

func salir_menu():
	if problema > saved_nivel:
		save_game(0, problema)
	get_tree().change_scene("res://Scenes/Pantalla_inicio/Scenes/Pantalla_inicio.tscn")
	
func save_game(mapa, nivel):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var temp = {
		"mapa" : mapa,
		"nivel": nivel
	}
	save_game.store_line(to_json(temp))
	
	save_game.close()


func _on_ticket_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if not seleccionado:
			seleccionado = true
			var node = scene.instance()
			add_child(node)
			node.connect("done", self, "mostrar_texto")
			if position == 0:
				problema = 0
			elif position == 386:
				problema = 1
			elif position == 614:
				problema = 2
			elif position == 756:
				problema = 3

func _on_Siguiente_Mapa_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
	
"""
func mostrar_texto():
	$Control/Panel.visible = true
	$AnimationPlayer.play("panel")
	if problema == 0:
		$Control/Panel/Label.text = texto_gasolinera[0]
	elif problema == 1:
		$Control/Panel/Label.text = texto_gim[0]
	elif problema == 2:
		$Control/Panel/Label.text = texto_tienda[0]
	elif problema == 3:
		$Control/Panel/Label.text = texto_puente[0]
"""

func _on_Flecha1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		siguiente = true


func _on_Flecha2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		anterior = true
