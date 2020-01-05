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

var texto_gasolinera = [
	"En tu primer paso por salvar el mundo, deberás arreglar el sistema del auto que permite calcular el costo del combustible en base a tres parámetros:\n- Distancia (en km)\n- Rendimiento del auto (en km/litro)\n- Costo de un litro de combustible",
	"Bueno, empecemos con lo básico. Los aparatos usados en Pythonia funcionan con códigos hechos en Python. Tal vez ya conozcas algunas de las cosas que te nombre a continuación.\nAquí encontrarás variablesdel tipo:\n- Numérico (Int o float)\n- Texto (String)\n- Bandera (Flag)",
	"En el código también encontrarás líneas que contengan:\n- Entradas (Líneas en las que debes escribir algo para ejecutar el programa)\n- Salidas (Respuestas que el programa entrega)\n- Funciones (Procedimientos especiales que tú puedes especificar)\n- Listas (Estructuras de datos que presentan elementos dentro de esta. Las listas tienen la cualidad de poder alterarse)\n- Tuplas (Estructuras de datos que presentan elementos dentro de esta. Las tuplas no pueden ser alteradas)"
]
	
var texto_gim = [
	"Hemos recibido reclamos de los clientes delos distintos gimnasios que hay alrededor de la ciudad y el campo. Las máquinascalculan el Índicede Masa Corporal (IMC)de forma automática están fallando. Todas lasmáquinas están conectadas a una red que les brinda el programa para funcionar, esto significa que basta con arreglar una máquina para que el código se expanda por la red y llegue a los demás gimnasios de la zona.",
	"Para poder arreglar el código de forma remota debo darte un permiso para poder modificar el código desde una máquina. Cuandolohayas reparado y el códigohayallegado a las demás máquinas a través de la red, revocaréel permiso, de esta forma, si alguien modifica el código de unaparatopor casualidad (o intencionalmente)no afectará a ninguna máquina más y la red puede detectar el cambio anómalo y restaurará el códigocorrecto.",
	"Creo que ahora es un momento importante para que te recuerde que son los condicionales. Los condicionales son caminos que el código toma dependiendo de las condiciones que se den.  El condicional que se usa es if, y como su nombre dice, da una condición(o más de una)al programa. Las líneas que determinen lo que se hará cuando una condición se cumpla deberán ir indentadas.",
	"Para poder resolver este problema recuerda que el IMC es una fórmula que utiliza la altura(en metros)y peso(en kilos)de una persona y luego lo clasifica dependiendo del número que resulte al dividir el peso en la estatura al cuadrado. Como pueden ocurrir casos en los que el númerotenga muchos decimales, haremos que el programa redondee todos los números a 2 decimales. Mucha suerte."
]

var texto_tienda = [
	"Cerca de donde estás hay una tienda que abastece a todas las familias del sector con alimentos y otros productos. Hace años, me contactaron para pedir que hiciera un programa que pudiera acelerar el proceso de ventasen su tienda;si bien el programa es un poco anticuado, los dueños lo querían de esa forma. Minutos atrás, me volvieron a contactar porque el programa de la tienda ha fallado, seguramente debido al virus. Necesito que te dirijas a la tienda y lo repares.Esperaba que el virus solo atacara a sistemas a gran escala,pero me sorprende que también haya atacado a sistemas pequeños como el de esta tienda.",
	"Antes de que resuelvas este problema dejame acordarte de lo que son los ciclos. Los ciclos se utilizan para repetir ciertas partes de un código hasta que se cumpla una condición preestablecida. El ciclo utilizado aquí se llama while. Las líneas que dictan el comportamiento del ciclo deben ir indentadas, es decir, deben tener un espacio antes de escribir en esa línea."
]

var texto_puente = [
	"Nos hemos dado cuenta de que el puente Py Py también se vio afectado por el virus y se quedó levantado hasta la mitad, como si el puentese hubiera construido mal. Necesito que vayas allá de inmediato, hay mucha gente que vive en el campo y va a trabajar a la ciudad que necesita el puente funcionando."	
]

func mostrar_texto():
	$Control/Panel.visible = true
	$AnimationPlayer.play("panel")
	seleccionado = true
	if problema == 0:
		$Control/Panel/Label.text = texto_gasolinera[0]
	elif problema == 1:
		$Control/Panel/Label.text = texto_gim[0]
	elif problema == 2:
		$Control/Panel/Label.text = texto_tienda[0]
	elif problema == 3:
		$Control/Panel/Label.text = texto_puente[0]

func _ready():
	if saved_nivel == 0:
		follow.set_offset(285)
		position = 285
		punto2 = true
	elif saved_nivel == 1:
		follow.set_offset(585)
		position = 585
		punto2 = true
		punto3 = true
	elif saved_nivel == 2:
		follow.set_offset(885)
		position = 885
		punto2 = true
		punto3 = true
		punto4 = true
	elif saved_nivel == 3:
		follow.set_offset(1100)
		position = 1100
		punto2 = true
		punto3 = true
		punto4 = true
		siguiente_mapa = true
		$Control/fondo_arriba.visible = false
		$Control/fondo_abajo.visible = true
	$AnimationPlayer.play("Entrada")

func _process(delta):
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
				$AnimationPlayer.play_backwards("Entrada")
				var encontrar_error_node = encontrar_error.instance()
				encontrar_error_node.texto = "El programa debe calcular el costo total de un viaje en auto, considerando como entradas la distancia en Kms, el rendimiento del auto en Kms/litro y el costo de cada litro de combustible. Pero hay un error, encuentralo!"
				encontrar_error_node.lineas_codigo = [
				"1. d=float(input())",
				"2. k=float(input())",
				"3. c=float(input()",
				"4. C=(d/k)*c",
				"5. print(C)"
				]
				encontrar_error_node.linea_error = 3
				encontrar_error_node.resultado_error = "SyntaxError: invalid syntax"
				
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
				
			else:
				$Control/Panel/Label.text = texto_gasolinera[vineta]
		elif problema == 1:
			if vineta >= len(texto_gim):
				$AnimationPlayer.play_backwards("Entrada")
				var ordenar_codigo_node = ordenar_codigo.instance()
				ordenar_codigo_node.codigo_ordenado = [
					"estatura=float(input())",
					"peso=float(input())",
					"imc=round(peso/(estatura**2),2)",
					"print(imc)",
					"if imc<18.50:",
					'    print("Delgadez")',
					"elif imc<25.00:",
					'    print("Normal")',
					"else:",
					'    print("Sobrepeso")'
				]
				ordenar_codigo_node.texto = "A partir de su estatura y peso, se debe determinar el IMC de una persona e indicar si está en un estado Normal, de Delgadez ode Sobrepeso.\n Utilice la siguiente clasificación como referencia:\n- Delgadez:<18.50<18.50\n- Normal:18.50−24.9918.50−24.99\n- Sobrepeso:⩾25.00\nEl problema del programa es que esta desordenaod, ordenalo!"
				ordenar_codigo_node.cantidad_maxima_saltos = 1
				ordenar_codigo_node.mas_opciones = true
				ordenar_codigo_node.opciones_codigo_ordenado = [[
					"peso=float(input())",
					"estatura=float(input())",
					"imc=round(peso/(estatura**2),2)",
					"print(imc)",
					"if imc<18.50:",
					'    print("Delgadez")',
					"elif imc<25.00:",
					'    print("Normal")',
					"else:",
					'    print("Sobrepeso")'
				]]
				
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
				
			else:
				$Control/Panel/Label.text = texto_gim[vineta]
		elif problema == 2:
			if vineta >= len(texto_tienda):
				$AnimationPlayer.play_backwards("Entrada")
				var encontrar_error_node = encontrar_error.instance()
				encontrar_error_node.texto = "Hay una tienda en el campo que tiene un sistema el cualpregunta por el producto a comprar y su precio, también pregunta al cliente si desea algo más que llevar. Cuando el cliente no desea llevar nada más, el programa muestra el precio total que hay que pagar. Pero hay un error, encuéntralo!"
				encontrar_error_node.lineas_codigo = [
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
				encontrar_error_node.linea_error = 8
				encontrar_error_node.resultado_error = "SyntaxError: invalid syntax"
				
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
				
			else:
				$Control/Panel/Label.text = texto_tienda[vineta]
		elif problema == 3:
			if vineta >= len(texto_puente):
				$AnimationPlayer.play_backwards("Entrada")
				var encontrar_error_node = encontrar_error.instance()
				encontrar_error_node.texto = "El puente py py es ruta más directa entre la ciudad de Pythonia y el campo. El puente tiene un sistemacontrolador,el cual identifica los vehículos terrestres con un 0 y los acuáticos con un 1 y luego levanta o baja el puente según corresponda. Además, muestra en la pantalla si el puente está subiendo o bajando. El programa consta de una función que determina si el puente se debe bajar o levantar, dependiendo del parametro ingresado. Luego pregunta el número de vehículos que pasaran por el puente para después hacer un ciclo en el cual determina si bajar o levantar el puente. Pero en el código hay un error, encuéntralo!"
				encontrar_error_node.lineas_codigo = [
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
				encontrar_error_node.linea_error = 11
				encontrar_error_node.resultado_error = "NameError"
				
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
	if problema > saved_nivel:
		save_game(problema)
		print("se guardo")
	var next_level_resource = load("res://Scenes/Mapa0/Scenes/Mapa0.tscn")
	var next_level = next_level_resource.instance()
	if problema > saved_nivel:
		next_level.saved_nivel = problema
	else:
		next_level.saved_nivel = saved_nivel
	$".".add_child(next_level)

func salir_menu():
	if problema > saved_nivel:
		save_game(problema)
		print("se guardo")
	get_tree().change_scene("res://Scenes/Pantalla_inicio/Scenes/Pantalla_inicio.tscn")
	
func save_game(nivel):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var temp = {
		"mapa" : 0,
		"nivel": nivel
	}
	save_game.store_line(to_json(temp))
	
	save_game.close()

func _on_Siguiente_Mapa_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if siguiente_mapa:
			queue_free()
