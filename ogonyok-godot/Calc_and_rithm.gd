extends Node2D

var t = 0
var fase = 0
var fase_trig = 0.5	# порог срабатывания кнопки
var k_fase = 100		# длина цикла в кадрах
var pl_moved = false	# проверка на нажатие кнопки

var auto_fuckup = false

var d = {}

func reset():
	d = {
		fire = 80, wood = 50, people = 100, turn = 0,
		
		k01 = 2.5, k02 = 3, k03 = .02, k04 = .02,
		k11 =5, k12 = .06,
		k21 = 70, k22 = 5,
		k31 = 1,
		k41 = 3, k42 = 10,
		
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
	fase = cos(2*3.14*t/k_fase)
	
	$Control/time_label.text = str(fase)
	
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
	d.fire += -d.k01 + d.k02*d.x + d.k03*d.x*d.wood + d.k04*d.x*d.people
	
	if (d.fire>100): d.fire=100
	
	if (d.fire<0):
		d.fire=0
		d.people = 0
	
	d.wood = d.wood - d.k11*d.x + d.k12*d.people*d.z
	
	if (d.wood<0): d.wood=0
	
	var woolfs = 0
	if(d.fire<d.k21): woolfs = d.k22
	
	d.people = d.people - d.k31*woolfs - d.k41 + d.k42*d.y
	
	if (d.people>100): d.people=100
	if (d.people<0): d.people=0
	
	d.turn += 1
	

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
