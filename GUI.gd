extends CanvasLayer

func _ready():
	if stats.connect("changeHealth", self, "updatePlayerUI"): print("showHealthConnectionError")

func updatePlayerUI(_damage:int) -> void:
	pass
	
