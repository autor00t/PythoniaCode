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

var problema #0 = salario, 1 = escuela, 2 = cancha, 3 = clapystel
var seleccionado = false
var vineta = 0
var corriendo_problema = false
var mapa_anterior = false

var texto_salario = [
	"Bienvenido a Pythonia, esta ciudad es la cumbre de la tecnología. Todos los programadores más conocidos mundialmente han estado aquí, eso significa que tú pronto estarás en las grandes ligas, ¡Felicidades!.",
	"Hemos recibido una solicitud de ayuda de la central de Py Factory, una empresa especializada en artículos computacionales que se encuentra cerca de tu posición. El virus ha afectado el sistema de pago de los empleados y no están recibiendo el sueldo que les corresponde. Este sistema da un bono dependiendo del dinero que gane cada empleado.",
	"Siéntete honrado, no cualquiera tiene acceso a los códigos de los programas de Pythonia, eres unos de los pocos privilegiados"
]

var texto_escuela = [
	"En Pythonia hay un colegio muy avanzado tecnológicamente, el cual lleva la información de sus estudiantes en distintas listas y luego procesan dichas listas con programas nuestros,llevando registro de asistencias, notas, anotaciones,etc. El rector de este colegio me ha contactado porque al parecer el virus afectó el programa que lleva el registro de las asistencias y no funciona. Es importante que vayas y arregles este problema de inmediato, ya que de momento todos los estudiantes están reprobando por inasistencia."
]

var texto_cancha = [
	"El equipo de fútbol oficial de Pytonia, Pythonia FC, tiene la información de las posiciones en las que juegan sus jugadores en un diccionario. De esta forma el director técnico puede organizar distintas formaciones para los partidos. El D.T. me contactó, pues resulta que el virus también afecto este programa de una forma extraña, esta vez había algunos jugadores que figuraban en posiciones en las que no jugaban. Lo peor de esto es que el D.T. hizo una formación errónea durante un partido importante y perdieron, lo que ocasionó el enfado de los hinchas del PFC.", 
	"Luego de este error garrafal, logré restaurar la información real de los jugadores, pero el programa aún requiere una revisión. Dejaré esto en tus manos, sé que podrás arreglarlo. La información de la posición en la que juegan los jugadores se encuentra en diccionarios, los diccionarios son colecciones no ordenadas de información asociada en pares llave-valor. Utilizando la llave es posible recuperar el valor asociado a esta. Al trabajar con diccionarios deberás tener presente:", 
	"\n- Las llaves pueden ser números,strings o tuplas, pero las llaves en un diccionario deben ser únicas.\n- Si la llave utilizada no existeen el diccionario, se agrega un nuevo elemento. Si la llave utilizada existe en el diccionario, el valor asociado es modificado.\n- El valor asociado a la llave k del diccionario d se puede obtener como d[k]"
]

var texto_clapystel = [
	"Es hora de poner tus habilidades a prueba, la empresa de telecomunicaciones Clapystel me ha informado de fallas en su programa que premia a sus clientes más antiguos (¡yo estoy entre ellos!) y los usuarios están perdiendo algunos de sus beneficios."
]

var saved_nivel = -1
var saved_mapa = 1

signal llego_destino0
signal llego_destino1

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
		
		if follow.get_offset() >= 855:
			emit_signal("llego_destino0")
		if mapa_anterior and follow.get_offset() <= 0:
			emit_signal("llego_destino1")
		
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
		if problema == 0:
			if vineta >= len(texto_salario):
				var codigo_ordenado = [
					"s=float(input())",
					"if s<=500000:",
					"    s+=(s*0.1)",
					"elif s<=1000000:",
					"    s+=(s*0.07)",
					"else:",
					"    s+=(s*0.05)",
					"print(s)"
				]
				
				var texto = "Una empresa aumenta un 10% a los empleados que ganan hasta $500.000, un 7% a los que ganan más que eso pero que no superan $1.000.000, y finalmente un 5% a los que ganan más que ese límite. El programa debe calcular el nuevo salario."
				var cantidad_maxima_saltos = 1
				var mas_opciones = false
				var opciones_codigo_ordenado = [[]]
				
				ordenar_codigo(codigo_ordenado, texto, cantidad_maxima_saltos, mas_opciones, opciones_codigo_ordenado)
				
			else:
				$Control/Panel/Label.text = texto_salario[vineta]
		if problema == 1:
			if vineta >= len(texto_escuela):
				var texto = "En una escuela se lleva registro de las asistencias de los estudiantes a sus clases a través de una lista de listas. Cada lista dentro de la primera corresponde a la asistencia de un estudiante, donde “True” indica que asistió a esa clase y “False” que no.\nEj:\nasistencia=[\n[True,True,True,False,False,False,False],\n[True,True,True,False,True,False,True],\n[True,True,True,True,True,True,True],\n[True,True,True,False,True,True,True]\n]"
				var lineas_codigo = [
				"1. def total_alumno(tabla):",
				"2.   a=list()",
				"3.   for alumno in tabla:",
				"4.     registro=0",
				"5.     for clase in alumno:",
				"6.       if clase:",
				"7.         registro+=1",
				"8.     a.append(registro)",
				"9.   return a",
				"10.def total_clase(tabla):",
				"11.  i=tabla[0]",
				"12.  a=[0]*len(i)",
				"13.  for dia in range(len(i):",
				"14.    for alumno in tabla:",
				"15.      if alumno[dia]:",
				"16.        a[dia]+=1",
				"17.  return a"
				]
				var linea_error = 13
				var resultado_error = "SyntaxError: invalid syntax"
				
				encontrar_error(texto, lineas_codigo, linea_error, resultado_error)
				
			else:
				$Control/Panel/Label.text = texto_escuela[vineta]
		if problema == 2:
			if vineta >= len(texto_cancha):
				var codigo_ordenado = [
					"pos=input()",
					"lista=[]",
					"for f in futbolistas:",
					"    a,p=futbolistas[f]",
					"    if p==pos:",
					"        lista.append(a)",
					"print(lista)"
				]
				
				var texto = "Un entrenador de Fútbol quiere organizar a sus jugadores para crear distintas formaciones para un partido, y para ello tiene almacenados a todos sus jugadores en un diccionario llamado futbolistas en el que la llave es la dorsal del futbolista, y el valor es una tupla con la primera letra del apellido del jugador y la primera letra de su posición. A continuación se mostrará un ejemplo del diccionario:\n#{dorsal:(apellido,posicion)}\nfutbolistas={1:('V','a'),23:('U','d'),\n3:('P','d'),2:('S','d'),7:('C','c'),\n22:('V','c'),5:('B','c'),9:('S','d'),\n11:('D','d'),10:('M','d')}"
				var cantidad_maxima_saltos = 2
				var mas_opciones = true
				var opciones_codigo_ordenado = [[
					"lista=[]",
					"pos=input()",
					"for f in futbolistas:",
					"    a,p=futbolistas[f]",
					"    if p==pos:",
					"        lista.append(a)",
					"print(lista)"
				]]
				
				ordenar_codigo(codigo_ordenado, texto, cantidad_maxima_saltos, mas_opciones, opciones_codigo_ordenado)
				
			else:
				$Control/Panel/Label.text = texto_cancha[vineta]
		if problema == 3:
			if vineta >= len(texto_escuela):
				var texto = "La empresa telefónica Clapystelha tenido un increíble aumento de clientes en este último año, razón por la cual la empresa quiere premiar a aquellos clientes que llevan más de cinco años siendo parte de la comunidad. Por ello, la empresa Clapystel ha guardado toda la información de sus usuarios en un diccionario llamado c, en el cual la llave es el número del usuario, y el valor es una tupla con la primera letra del nombre y apellido, junto con el género y los años de servicio de un cliente.\nSe solicita que dado un número telefónico, imprima si el cliente con dicho número es premiado o no."
				var lineas_codigo = [
				"1. c=dict()",
				"2. c[123]=('J','M','M',3)",
				"3. c[147]=('J','S','F',8)",
				"4. c[145]=('G','S','M',0)",
				"5. c[125]=('S','J','F',2)",
				"6. c[951]=('F','O','M',7)",
				"7. c[965]=('A','S','F',13)",
				"8. n=int(input())",
				"9. _,_,_,anos=c[numero]",
				"10.if anos>5:",
				"11.  print(Premiado')",
				"12.else:",
				"13.  print('No premiado')"
				]
				var linea_error = 11
				var resultado_error = "SyntaxError"
				
				encontrar_error(texto, lineas_codigo, linea_error, resultado_error)
				
			else:
				$Control/Panel/Label.text = texto_clapystel[vineta]
	
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

func salir_mapa():
	if problema > saved_nivel:
		save_game(1, problema)
	var next_level_resource = load("res://Scenes/Mapa1/Scenes/Mapa1.tscn")
	var next_level = next_level_resource.instance()
	if problema > saved_nivel:
		next_level.saved_nivel = problema
	else:
		next_level.saved_nivel = saved_nivel
	$".".add_child(next_level)

func salir_menu():
	if problema > saved_nivel:
		save_game(1, problema)
	get_tree().change_scene("res://Main.tscn")
	
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
#final = 861.42
func _on_Siguiente_Mapa_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if !seleccionado:
			position = 861
			yield(self, "llego_destino0")
			$AnimationPlayer.play("panel2")
			seleccionado = true

func mostrar_texto():
	$Control/Panel.visible = true
	$AnimationPlayer.play("panel")
	if problema == 0:
		$Control/Panel/Label.text = texto_salario[0]
	elif problema == 1:
		$Control/Panel/Label.text = texto_escuela[0]
	elif problema == 2:
		$Control/Panel/Label.text = texto_cancha[0]
	elif problema == 3:
		$Control/Panel/Label.text = texto_clapystel[0]

func _on_Flecha1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		siguiente = true


func _on_Flecha2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		anterior = true


func _on_Salir_mapa_pressed():
	seleccionado = false
	$AnimationPlayer.play_backwards("panel2")

func _on_Salir_menu_pressed():
	get_tree().change_scene("res://Main.tscn")
