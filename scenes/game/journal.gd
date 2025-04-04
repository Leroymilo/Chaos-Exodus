extends Node2D

signal opening(value: bool)

@onready var background := $BackGround
@onready var page_l := $LeftPage
@onready var page_r := $RightPage
@onready var anim_player := $AnimationPlayer

var focused: int

func _ready() -> void:
	Globals.event_triggered.connect(open_to_event)

func open_to_event(event_nb: int) -> void:
	open()
	var index_l = event_nb - (event_nb % 2)
	page_l.load_page(index_l)
	page_r.load_page(index_l+1)
	focused = event_nb
	update_page_focus()

func open_to_last() -> void:
	open_to_event(Globals.save_data.events_order.size()-1)

func open() -> void:
	anim_player.play("open")
	show()
	opening.emit(true)
	Globals.show_action.emit(Action.empty_action)
	await anim_player.animation_finished
	background.flip_h = focused % 2 

func close():
	anim_player.play("close")
	opening.emit(false)

func _input(event: InputEvent) -> void:
	if Globals.has_control != Globals.Controller.Journal: return
	if page_l.in_event or page_r.in_event: return
	
	if event.is_action_pressed("open_journal")\
	or event.is_action_pressed("ui_cancel"):
		await get_tree().process_frame
		close()
	elif event.is_action_pressed("flip_right"):
		if focused < Globals.save_data.events_order.size()-1\
		and not anim_player.is_playing():
			if focused % 2 == 1:
				anim_player.play("flip_right")
			else:
				background.flip_h = true
			focused += 1
			update_page_focus()
	elif event.is_action_pressed("flip_left"):
		if focused > 0 and not anim_player.is_playing():
			if focused % 2 == 0:
				anim_player.play("flip_left")
			else:
				background.flip_h = false
			focused -= 1
			update_page_focus()

func update_page_focus() -> void:
	page_l.focused = not (focused % 2)
	page_r.focused = focused % 2
