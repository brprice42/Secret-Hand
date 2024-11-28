extends Panel

const CHAR_READ_RATE = .07

@onready var player_container = $PlayerContainer
@onready var player_start = $PlayerContainer/MarginContainer/PlayerText/Start
@onready var player_end = $PlayerContainer/MarginContainer/PlayerText/End
@onready var player_text = $PlayerContainer/MarginContainer/PlayerText/Text


@onready var enemy_container = $EnemyContainer
@onready var enemy_start = $EnemyContainer/MarginContainer/EnemyText/Start
@onready var enemy_end = $EnemyContainer/MarginContainer/EnemyText/End
@onready var enemy_text = $EnemyContainer/MarginContainer/EnemyText/Text

@onready var tween = get_tree().create_tween()

signal finish_scene

enum State { READY, READING, FINISHED }
var current_state = State.READY

@onready var text_queue = []

func queue_text(player, text):
	text_queue.push_front([player, text])

func chage_state(state):
	current_state = state
	match current_state:
		State.READY:
			if text_queue.is_empty():
				$"../Draggables/Coffee".show()
				finish_scene.emit()
				hide()
		State.READING:
			show()
		State.FINISHED:
			pass
			
			
func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text(text_queue.pop_back())
				
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.pause()
				tween.custom_step(1)	
				on_tween_finished()
				player_text.visible_ratio = 1.0
				enemy_text.visible_ratio = 1.0
				
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				chage_state(State.READY)
				hide_enemy_text()
				hide_player_text()

func _ready() -> void:
	hide_enemy_text()
	hide_player_text()
	tween.connect("finished", on_tween_finished)
	
func display_text(input):
	if input[0] == "grampa":
		add_enemy_text(input[1])
	else:
		add_player_text(input[1])

func hide_enemy_text():
	enemy_text.text = ""
	enemy_start.text = ""
	enemy_end.text = ""
	enemy_container.hide()
	
func hide_player_text():
	player_start.text = ""
	player_text.text = ""
	player_end.text = ""
	player_container.hide()
	
func show_player_text():
	player_start.text = "You: "
	player_container.show()
	
func show_enemy_text():
	enemy_start.text = "Grandpa: "
	enemy_container.show()
	
func add_player_text(next_text):
	chage_state(State.READING)
	player_end.text = ""
	player_text.text = next_text
	player_text.visible_ratio = 0.0
	show_player_text()
	tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.tween_property(player_text, "visible_ratio", 1, len(next_text) * CHAR_READ_RATE)
	tween.play()
	
func add_enemy_text(next_text):
	chage_state(State.READING)
	enemy_end.text = ""
	enemy_text.text = next_text
	enemy_text.visible_ratio = 0.0
	show_enemy_text()
	tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.tween_property(enemy_text, "visible_ratio", 1, len(next_text) * CHAR_READ_RATE)
	tween.play()
	
func on_tween_finished():
	player_end.text = "v"
	enemy_end.text = "v"
	chage_state(State.FINISHED)
	
	
