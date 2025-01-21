extends CanvasLayer


signal start_game

func show_message(text): # show "Dodge Ze Creeps", start timer
	$Message.text = text
	$Message.show() # message is automatically hidden after two seconds via timeout signal
	$MessageTimer.start()

func show_game_over():
	show_message("You LOST!") # changes Go! message to You LOST, waits two seconds
	await $MessageTimer.timeout
	
	$Message.text = "Dodge Ze Creeps!" # changes message back
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show() # shows "Go!" button

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
