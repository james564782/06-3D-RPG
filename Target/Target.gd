extends StaticBody

var health = 1

func damage(var dmg):
	health -= dmg
	if health <= 0:
		Global.update_score(10)
		queue_free()
