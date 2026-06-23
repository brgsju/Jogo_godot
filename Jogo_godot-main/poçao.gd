extends Area3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

func _on_body_entered(body):
	animated_sprite_3d.play('gliiter')



func _on_animated_sprite_3d_animation_finished():
	queue_free()
