extends Area2D

var health 
var diamond
var hit

func _ready():
	health = 3
	hit = 0
	diamond = preload("res://diamond.tscn")
	
func _process(delta):
	if hit>0:
		hit -=1
	else:
		$AnimatedSprite.play("ifle")
	if health == 0: 
		var diamond_instance = diamond.instance()
		diamond_instance.position = position
		self.get_parent().add_child(diamond_instance)
		queue_free()
	


func _on_enemy_area_entered(area):
	if area.is_in_group("hammer"):
		if health>0:
			health -=1		
			$AnimatedSprite.play("hit")
			hit = 20
