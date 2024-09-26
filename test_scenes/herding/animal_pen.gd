class_name AnimalPen extends Area2D

@export var animals: Array[Animal] = []
var animals_inside: Array[Animal] = []
var complete: bool = false

func animal_entered(animal: Animal) -> void:
	print(animals_inside)
	if (animals_inside.has(animal)):
		return
	animals_inside.push_back(animal)
	if (animals_inside.size() == animals.size()):
		complete = true
		print("yippee!!!!!!!")
