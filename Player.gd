extends KinematicBody2D

var input
var velocity =Vector2.ZERO
var speed = 100
var dir = 1
var attack_mode

var life = 3
var score = 0

var fastfall
var jumpcount 

func _ready():
	attack_mode = 0
	jumpcount = 0

func _process(delta):
	input=Vector2.ZERO
	input.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")	
	
	if input.x==0:
		apply_friction()
	else:
		apply_acceleration(input.x)
	apply_gravity()
	velocity=move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor()==true and jumpcount == 1:
		jumpcount = 0
		
	if velocity.y == 0 :
		fastfall = true
		velocity.y = 50
		
	if fastfall:
		velocity.y = velocity.y + 10

	if Input.is_action_just_pressed("ui_accept"):
		if jumpcount==0:
			velocity.y=-200
			jumpcount=jumpcount+1
			fastfall=false	
	
	if attack_mode>0:
		attack_mode -=1
		
	
	if Input.is_action_just_pressed("attack"):
		attack_mode = 6
		$AnimatedSprite.play("attack")
		$hurt/CollisionShape2D.disabled = false
	
	if attack_mode == 0:
		$hurt/CollisionShape2D.disabled = true
		#animation
		if velocity.x>0:
			$AnimatedSprite.play("run")
			if dir!= 1:
				dir = 1 
				$AnimatedSprite.flip_h = false
		if velocity.x<0:
			$AnimatedSprite.play("run")
			if dir!= -1:
				dir = -1 
				$AnimatedSprite.flip_h =true
		if velocity.x==0:
			$AnimatedSprite.play("idle")
				

func apply_gravity():
	velocity.y=velocity.y+5
		
func apply_friction():
	velocity.x=move_toward(velocity.x,0,20)
func apply_acceleration(input_x):
	velocity.x=move_toward(velocity.x,speed*input_x,20)


func _on_hit_area_entered(area):
	if area.is_in_group("enemy"):
		life -=1
		if life == 0:
			var game_over = preload("res://Panel.tscn").instance()
			self.get_parent().add_child(game_over)
			queue_free()
		get_parent().get_node("health").text = str(life)
	if area.is_in_group("diamond"):
		score +=1
		get_parent().get_node("score").text = str(score)
	if area.is_in_group("health"):
		life +=1
		get_parent().get_node("health").text = str(life)
