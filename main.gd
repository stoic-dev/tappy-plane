extends Node
var dynamic_object_speed: int = 700
var health_decrease_speed: int = 3
var health: float = 100.0
var score: float
var spawned_object_position_x: int = 1700
var last_obstacle_spawned_position: String
@export var obstacle: PackedScene
@export var coin: PackedScene

func _process(delta: float) -> void:
	#move all nodes in DynamicObject group
	for node in get_tree().get_nodes_in_group('DynamicObject'):
		node.position.x -= dynamic_object_speed * delta
	
	if health > 0:
		health -= health_decrease_speed * delta
		$UI/HealthBar.value = health
	else:
		game_over()
	
	score += delta
	$UI/HealthBar/Score.text = '%.2f' % score
func _on_obstacle_spawn_timer_timeout() -> void:
	var random: int = randi() % 2
	var obstacle_instance: Area2D = obstacle.instantiate()
	add_child(obstacle_instance)
	obstacle_instance.position.x = spawned_object_position_x
	obstacle_instance.body_entered.connect(_on_obstacle_collided)
	
	if random == 0:
		#Spawn top
		obstacle_instance.position.y = 200
		last_obstacle_spawned_position = 'up'
	else:
		#Spawn bottom and reflect vertically
		obstacle_instance.position.y = 800
		obstacle_instance.scale.y *= -1
		last_obstacle_spawned_position = 'down'
func _on_coin_spawn_timer_timeout() -> void:
	var random: int = randi() % 3
	
	if does_collide_with_obstacle(random):
		return
	
	var coin_instance: Area2D = coin.instantiate()
	add_child(coin_instance)
	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))
	coin_instance.position.x = spawned_object_position_x
	coin_instance.position.y = 280 + random * 200
func does_collide_with_obstacle(position: int) -> bool:
		return (last_obstacle_spawned_position == 'up' and position == 0) or (last_obstacle_spawned_position == 'down' and position == 2)
		
func _on_coin_collided(body: Node2D, coin_instance: Area2D) -> void:
	if ($Player == body):
		health += 4
		var animation_player: AnimationPlayer = coin_instance.get_node('CollectedAnimation')
		animation_player.play('CoinCollected')
		animation_player.animation_finished.connect(coin_instance.queue_free.unbind(1))
		
		$CoinCollectedSoundPlayer.play()
		
		if health > 100:
			health = 100
func game_over() -> void:
	$GameOver.show()
	$GameOverSoundPlayer.play()
	get_tree().paused = true
func _on_obstacle_collided(body: Node2D) -> void:
	if $Player == body:
		game_over()
func _on_player_body_entered(body: Node) -> void:
	if $Bounds/Bottom == body:
		game_over()
