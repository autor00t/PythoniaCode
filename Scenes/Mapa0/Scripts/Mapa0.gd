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

var problema #0 = gasolinera, 1 = gim, 2 = tienda, 3 = puente
var seleccionado = false
var vineta = 0
var corriendo_problema = false

var saved_nivel = -1
var saved_mapa = 0

signal llego_destino
signal listo
signal volver_mapa

var texto_gasolinera = [
	"En tu primer paso por salvar el mundo, deberás arreglar el sistema del auto que permite calcular el costo del combustible en base a tres parámetros:\n- Distancia (en km)\n- Rendimiento del auto (en km/litro)\n- Costo de un litro de combustible",
	"Bueno, empecemos con lo básico. Los aparatos usados en Pythonia funcionan con códigos hechos en Python. Tal vez ya conozcas algunas de las cosas que te nombre a continuación.\nAquí encontrarás variables del tipo:\n- Numérico (Int o float)\n- Texto (String)\n- Bandera (Flag)",
	"En el código también encontrarás líneas que contengan:\n- Entradas (Líneas en las que debes escribir algo para ejecutar el programa)\n- Salidas (Respuestas que el programa entrega)\n- Funciones (Procedimientos especiales que tú puedes especificar)\n- Listas (Estructuras de datos que presentan elementos dentro de esta. Las listas tienen la cualidad de poder alterarse)\n- Tuplas (Estructuras de datos que presentan elementos dentro de esta. Las tuplas no pueden ser alteradas)"
]
	
var texto_gim = [
	"Hemos recibido reclamos de los clientes de los distintos gimnasios que hay alrededor de la ciudad y el campo. Las máquinas calculan el Índice de Masa Corporal (IMC) de forma automática están fallando. Todas las máquinas están conectadas a una red que les brinda el programa para funcionar, esto significa que basta con arreglar una máquina para que el código se expanda por la red y llegue a los demás gimnasios de la zona.",
	"Para poder arreglar el código de forma remota debo darte un permiso para poder modificar el código desde una máquina. Cuando lo hayas reparado y el código haya llegado a las demás máquinas a través de la red, revocaré el permiso, de esta forma, si alguien modifica el código de un aparato por casualidad (o intencionalmente) no afectará a ninguna máquina más y la red puede detectar el cambio anómalo y restaurará el código correcto.",
	"Creo que ahora es un momento importante para que te recuerde que son los condicionales. Los condicionales son caminos que el código toma dependiendo de las condiciones que se den.  El condicional que se usa es if, y como su nombre dice, da una condición (o más de una) al programa. Las líneas que determinen lo que se hará cuando una condición se cumpla deberán ir indentadas.",
	"Para poder resolver este problema recuerda que el IMC es una fórmula que utiliza la altura (en metros) y peso (en kilos) de una persona y luego lo clasifica dependiendo del número que resulte al dividir el peso en la estatura al cuadrado. Como pueden ocurrir casos en los que el número tenga muchos decimales, haremos que el programa redondee todos los números a 2 decimales. Mucha suerte."
]

var texto_tienda = [
	"Cerca de donde estás hay una tienda que abastece a todas las familias del sector con alimentos y otros productos. Hace años, me contactaron para pedir que hiciera un programa que pudiera acelerar el proceso de ventas en su tienda; si bien el programa es un poco anticuado, los dueños lo querían de esa forma. Minutos atrás, me volvieron a contactar porque el programa de la tienda ha fallado, seguramente debido al virus. Necesito que te dirijas a la tienda y lo repares. Esperaba que el virus solo atacara a sistemas a gran escala, pero me sorprende que también haya atacado a sistemas pequeños como el de esta tienda.",
	"Antes de que resuelvas este problema dejame acordarte de lo que son los ciclos. Los ciclos se utilizan para repetir ciertas partes de un código hasta que se cumpla una condición preestablecida. El ciclo utilizado aquí se llama while. Las líneas que dictan el comportamiento del ciclo deben ir indentadas, es decir, deben tener un espacio antes de escribir en esa línea."
]

var texto_puente = [
	"Nos hemos dado cuenta de que el puente Py Py también se vio afectado por el virus y se quedó levantado hasta la mitad, como si el puente se hubiera construido mal. Necesito que vayas allá de inmediato, hay mucha gente que vive en el campo y va a trabajar a la ciudad que necesita el puente funcionando."	
]

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

func _ready():
	$AnimationPlayer.play("Entrada")
	if saved_nivel == 0 and saved_mapa == 0:
		follow.set_offset(285)
		position = 285
		punto2 = true
	elif saved_nivel == 1 and saved_mapa == 0:
		follow.set_offset(585)
		position = 585
		punto2 = true
		punto3 = true
	elif saved_nivel == 2 and saved_mapa == 0:
		follow.set_offset(885)
		position = 885
		punto2 = true
		punto3 = true
		punto4 = true
	elif (saved_nivel == 3 and saved_mapa == 0) or saved_mapa == 1:
		follow.set_offset(1100)
		position = 1100
		punto2 = true
		punto3 = true
		punto4 = true
		siguiente_mapa = true
		$Control/fondo_arriba.visible = false
		$Control/fondo_abajo.visible = true

func _process(delta):
	if Input.is_action_pressed("ui_unlock"):
		save_game(1, -1)
		punto2 = true
		punto3 = true
		punto4 = true
		siguiente_mapa = true
		$Control/fondo_arriba.visible = false
		$Control/fondo_abajo.visible = true
	
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
			follow.set_offset(follow.get_offset() + 350 * delta)
		elif retrocediendo:
			follow.set_offset(follow.get_offset() - 350 * delta)
		
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
		if problema == 0:
			if vineta >= len(texto_gasolinera):
				var texto = "El programa debe calcular el costo total de un viaje en auto, considerando como entradas la distancia en Kms, el rendimiento del auto en Kms/litro y el costo de cada litro de combustible. Pero hay un error, encuentralo!"
				var lineas_codigo = [
				"1. d=float(input())",
				"2. k=float(input())",
				"3. c=float(input()",
				"4. C=(d/k)*c",
				"5. print(C)"
				]
				var linea_error = 3
				var resultado_error = "SyntaxError: invalid syntax"
				
				encontrar_error(texto, lineas_codigo, linea_error, resultado_error)
				
			else:
				$Control/Panel/Label.text = texto_gasolinera[vineta]
		elif problema == 1:
			if vineta >= len(texto_gim):
				var codigo_ordenado = [
					"estatura=float(input())",
					"peso=float(input())",
					"imc=peso/(estatura**2)",
					"print(round(imc,2))",
					"if imc<18.50:",
					'    print("Delgadez")',
					"elif imc<25.00:",
					'    print("Normal")',
					"else:",
					'    print("Sobrepeso")'
				]
				var texto = "A partir de su estatura y peso, se debe determinar el IMC de una persona e indicar si está en un estado Normal, de Delgadez ode Sobrepeso.\n Utilice la siguiente clasificación como referencia:\n- Delgadez:<18.50<18.50\n- Normal:18.50−24.9918.50−24.99\n- Sobrepeso:⩾25.00\nEl problema del programa es que esta desordenado, ordenalo!"
				var cantidad_maxima_saltos = 1
				var mas_opciones = true
				var opciones_codigo_ordenado = [[
					"peso=float(input())",
					"estatura=float(input())",
					"imc=peso/(estatura**2)",
					"print(round(imc,2))",
					"if imc<18.50:",
					'    print("Delgadez")',
					"elif imc<25.00:",
					'    print("Normal")',
					"else:",
					'    print("Sobrepeso")'
				]]
				
				ordenar_codigo(codigo_ordenado, texto, cantidad_maxima_saltos, mas_opciones, opciones_codigo_ordenado)
				
			else:
				$Control/Panel/Label.text = texto_gim[vineta]
		elif problema == 2:
			if vineta >= len(texto_tienda):
				var texto = "Hay una tienda en el campo que tiene un sistema el cual pregunta por el producto a comprar y su precio, también pregunta al cliente si desea algo más que llevar. Cuando el cliente no desea llevar nada más, el programa muestra el precio total que hay que pagar. Pero hay un error, encuéntralo!"
				var lineas_codigo = [
				'1. producto=input()',
				'2. precio=int(input())',
				"3. total=0",
				"4. flag=True",
				"5. total+=precio",
				'6. algo_mas=input()',
				'7. while flag:',
				'8.   if algo_mas="si":',
				'9.     producto=input()',
				'10.    precio=int(input())',
				'11.    total+=precio',
				'12.    algo_mas=input()',
				'13.  else:',
				'14.    flag=False',
				'15.print(total)'
				]
				var linea_error = 8
				var resultado_error = "SyntaxError: invalid syntax"
				
				encontrar_error(texto, lineas_codigo, linea_error, resultado_error)
				
			else:
				$Control/Panel/Label.text = texto_tienda[vineta]
		elif problema == 3:
			if vineta >= len(texto_puente):
				var texto = "El puente py py es ruta más directa entre la ciudad de Pythonia y el campo. El puente tiene un sistemacontrolador,el cual identifica los vehículos terrestres con un 0 y los acuáticos con un 1 y luego levanta o baja el puente según corresponda. Además, muestra en la pantalla si el puente está subiendo o bajando. El programa consta de una función que determina si el puente se debe bajar o levantar, dependiendo del parametro ingresado. Luego pregunta el número de vehículos que pasaran por el puente para después hacer un ciclo en el cual determina si bajar o levantar el puente. Pero en el código hay un error, encuéntralo!"
				var lineas_codigo = [
				"1. def levantar(tipo):",
				"2.  if tipo==1:",
				"3.   levantar=True",
				"4.  else:",
				"5.   levantar=False",
				"6.  return levantar",
				'7. limite=int(input(""))',
				'8. i=0',
				'9. while i<limite:',
				'10. tipo=int(input())',
				'11. estado=levanta(tipo)',
				'12. if estado==True:',
				'13.  print("Levantado")',
				'14. if estado==False:',
				'15.  print("Bajando")',
				'16. i+=1'
				]
				var linea_error = 11
				var resultado_error = "NameError"
				
				encontrar_error(texto, lineas_codigo, linea_error, resultado_error)
				
			else:
				$Control/Panel/Label.text = texto_puente[vineta]

func _on_numero1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		position = 285

func _on_numero2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if punto2:
			position = 585

func _on_numero3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if punto3:
			position = 885

func _on_numero4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if punto4:
			position = 1100

func _on_ticket_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if not seleccionado:
			seleccionado = true
			var node = scene.instance()
			add_child(node)
			node.connect("done", self, "mostrar_texto")
			if position == 285 or position == 0:
				problema = 0
			elif position == 585:
				problema = 1
			elif position == 885:
				problema = 2
			elif position == 1100:
				problema = 3

func _on_Flecha_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		siguiente = true


func _on_Flecha2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		anterior = true
		
func salir_mapa():
	if problema > saved_nivel and saved_mapa == 0:
		if problema == 3:
			save_game(1, -1)
		else:
			save_game(0, problema)
	emit_signal("volver_mapa")

func salir_menu():
	if problema > saved_nivel and saved_mapa == 0:
		if problema == 3:
			save_game(1, -1)
		else:
			save_game(0, problema)
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

func _on_Siguiente_Mapa_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if siguiente_mapa:
			position = 1577
			yield(self, "llego_destino")
			$AnimationPlayer.play_backwards("Entrada")
			yield(get_node("AnimationPlayer"), "animation_finished")
			emit_signal("listo")


func _on_Cartel_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		save_game(1, -1)
		punto2 = true
		punto3 = true
		punto4 = true
		siguiente_mapa = true
		$Control/fondo_arriba.visible = false
		$Control/fondo_abajo.visible = true
