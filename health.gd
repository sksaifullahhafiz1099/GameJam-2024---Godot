extends Area2D

func _on_health_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
