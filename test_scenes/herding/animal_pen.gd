class_name AnimalPen extends Area2D

var animals: Array[Animal] = []
var animals_inside: Array[Animal] = []
var complete: bool = false

func add_target_animal(animal: Animal) -> void:
	animals.push_back(animal)

func _on_body_entered(body: Node2D) -> void:
	if (body in animals_inside):
		return
	if not (body in animals):
		return
	
	animals_inside.push_back(body)
	(body as Animal).enter_safe_area()
	if animals_inside.size() == animals.size():
		print("yippee!")

func _on_body_exited(body: Node2D) -> void:
	if not (body in animals_inside):
		return
	
	(body as Animal).retarget_safe_area()

func is_complete() -> bool:
	return complete
