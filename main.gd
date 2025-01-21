extends Node

@export var mob_scene: PackedScene
var score


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play() # does not need to be stopped, is not looping


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free") # goes through all nodes in the "mobs" group, and calls queue_free, which deletes them
	
	$HUD.update_score(score)
	$HUD.show_message(("Get Ready"))
	
	$Music.play()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() # Create new mob scene instance
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() # randomly determine a spawn location
	
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position # place mob at spawn location
	
	direction += randf_range(-PI / 4, PI / 4) # give mob random rotation within parameters
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0) # give mob random velocity within parameters
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob) # finally, spawn mob by adding it to main scene


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _ready():
	pass
