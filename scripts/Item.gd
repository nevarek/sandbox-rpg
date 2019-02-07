extends RigidBody2D

func spawn(parent_scene):
	parent_scene.add_child(self)

func pickup():
	queue_free()
	return self
	