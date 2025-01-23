extends Node

func reveal() -> void:
	if GoodBoyPointsCounter.instance != null:
		GoodBoyPointsCounter.instance.reveal()

func unreveal() -> void:
	if GoodBoyPointsCounter.instance != null:
		GoodBoyPointsCounter.instance.unreveal()
