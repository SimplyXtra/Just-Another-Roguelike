extends Area2D

export var healAmount := 50

func _ready() -> void:
	if self.connect("area_entered", self, "areaEntered"): print("CollectHealthError")

func areaEntered(_body: Node) -> void:
	stats.playerHealth += healAmount
	if stats.playerHealth > stats.PLAYER_MAX_HEALTH:
		stats.playerHealth = stats.PLAYER_MAX_HEALTH
	stats.changeSFX("PlayerHeal")
	queue_free()
