extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -1900.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var run_multiplier = 1
	
	if Input.is_action_pressed("run"):
		run_multiplier = 2
	else:
		run_multiplier = 1
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * run_multiplier)
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x != 0:
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")

	move_and_slide()
	
	if Input.is_action_just_pressed("magic"):
		var MagicNode = load("res://scenes/magic_area.tscn")
		var newMagic = MagicNode.instantiate()
		if $AnimatedSprite2D.flip_h == false:
			newMagic.direction = -1
		else:
			newMagic.direction = 1
		newMagic.set_position(%MagicSpawnPoint.global_transform.origin)
		get_parent().add_child(newMagic)

func killPlayer():
	position = %RespawnPoint.position
	$AnimatedSprite2D.flip_h = false

func _on_death_area_body_entered(body: Node2D) -> void:
	killPlayer() # Replace with function body.
