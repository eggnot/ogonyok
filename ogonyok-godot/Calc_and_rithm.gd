extends Node2D

# Сложность попадание в ритм. 0 = отключено, 0.8 - сложно
var fase_trig = 0.0
# Проверять "если за такт не нажата кнопка"
var auto_fuckup = false

# Технические переменные для задачи ритма
var t = 0;	var fase = 0
var k_fase = 100		# длина цикла в кадрах
var pl_moved = false	# проверка на нажатие кнопки


var d = {}

func reset():
	d = {
		# Начальные условия игры
		fire = 80, wood = 50, people = 100, turn = 0,
		
		k01 = 15,  # Потухание костра за ход
		k02 = 2.5, 	# Разгорание костра за каждое полено
		
		k11 = 4, 	# Подкидывание лично шаманом
		k12 = 0.03,	# Бонус подброса дров за человека
		k13 = 0.03,	# Бонус подброса да количество дров
		k14 = 0.25,	# Cбор дров с человека
		
		k21 = 50, 	# Безопасный уровень огня
		k22 = 15, 	# Урон от прихода волков
		
		k41 = 0, 	# Естественная убыль храбрости
		k42 = 10,	# Прибыль храбрости от танца
		
		x=0, y=0, z=0
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	t+=1		# типа счетчик кадров
	if t>k_fase: 
		t=0	# защита от переполнения
	
	if auto_fuckup:
		if t==round(k_fase/2) and !pl_moved:
			_on_fuckup_pressed()
	
	#t = OS.get_time()['second']	# Жестко тормозит
	fase = (1+cos(2*3.14*t/k_fase))/2
	
	#$Control/time_label.text = str(fase)
	
	$Control/gather.rect_scale.x = 1+fase/10
	$Control/gather.rect_scale.y = 1+fase/10
	
	$Control/feed.rect_scale.x = 1+fase/10
	$Control/feed.rect_scale.y = 1+fase/10
	
	$Control/dance.rect_scale.x = 1+fase/10
	$Control/dance.rect_scale.y = 1+fase/10
	
	
#	calc()
#	update_labels()
#	pass

func calc():
	var drop = 0
	drop = d.k11 + d.k12 * d.people + d.k13 * d.wood
	if drop > d.wood:
		drop = d.wood
	
	d.fire = d.fire - d.k01 + d.k02 * d.x * drop
	
	if (d.fire>100): d.fire=100
	
	if (d.fire<0):
		d.fire=0
		d.people = 0
	
	d.wood = d.wood - drop * d.x + d.k14 * d.people * d.z
	if (d.wood<0): d.wood=0
	if (d.wood>100): d.wood=100
	
	var woolfs = 0
	if (d.fire < d.k21): 
		woolfs = d.k22
	
	d.people = d.people - woolfs - d.k41 + d.k42*d.y
	# d.people = d.people + 0.5*woolfs*d.x	# 
	if (d.people>100): d.people=100
	if (d.people<0): d.people=0
	
	d.turn += 1
	$Control/time_label.text = str(d.k02 * d.x * drop)


func update_labels():
	$Control/fire.text = str(int(d.fire))
	$Control/wood.text = str(int(d.wood))
	$Control/people.text = str(int(d.people))
	
	$Control/turn.text = str(int(d.turn))
	#$Control/turn.text = str(int(t))


#func _on_update():
	
# signals are here:

func _on_gather_pressed():
	if fase>fase_trig:
		d.x=0; d.y=0; d.z=1
		pl_moved = true
	else:
		d.x=0; d.y=0; d.z=0
		pl_moved = false
	calc()
	update_labels()


func _on_feed_pressed():
	if fase>fase_trig:
		d.x=1; d.y=0; d.z=0
		pl_moved = true
	else:
		d.x=0; d.y=0; d.z=0
		pl_moved = false
	calc()
	update_labels()


func _on_dance_pressed():
	if fase>fase_trig:
		d.x=0; d.y=1; d.z=0
		pl_moved = true
	else:
		d.x=0; d.y=0; d.z=0
		pl_moved = false

	calc()
	update_labels()


func _on_fuckup_pressed():
	d.x=0; d.y=0; d.z=0
	calc()
	update_labels()


func _on_reset_pressed():
	reset()
	update_labels()
