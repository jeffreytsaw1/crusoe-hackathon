extends CharacterBody2D

const speed = 500


func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("sidewalk")
		$AnimatedSprite2D.flip_h = true
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("sidewalk")
		$AnimatedSprite2D.flip_h = false
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play("upwalk")
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.play("downwalk")
		velocity.y = speed
		velocity.x = 0
	else:
		$AnimatedSprite2D.play('idle')
		velocity.y = 0
		velocity.x = 0
		
	velocity = velocity
	move_and_slide()


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()
