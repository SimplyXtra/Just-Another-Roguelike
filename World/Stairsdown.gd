extends Area2D

export(int) var getCrystalsToUnlock = 1
var crystalsToUnlock := 1

func _ready() -> void:
	crystalsToUnlock = getCrystalsToUnlock
	if stats.connect("crystalsChanged", self, "checkCrystals"): print("CrystalToStairConnectionError")

func checkCrystals() -> void:
	if stats.crystalsHeld >= crystalsToUnlock:
		call_deferred("enableDetection")

func enableDetection() -> void:
	print(stats.crystalsHeld, ">=", crystalsToUnlock)
	$AnimatedSprite.playing = true
	$CollisionShape2D.disabled = false
	stats.changeSFX("OpenStaircase")


func _on_Stairsdown_body_entered(_body: Node) -> void:
	stats.crystalsHeld = 0
	stats.level += 1
	stats.changeSFX("ChangeLevel")
	if stats.level < stats.levels.size():
		stats.changeScene(stats.levelsPath[stats.level], false, stats.levels[stats.level])
	else:
		stats.loadStartMenu()
