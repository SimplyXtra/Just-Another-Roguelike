extends KinematicBody2D

#State
enum {
	IDLE,
	MOVE
}
var state := IDLE

#Constants
export var SPEED := 100
export var ACCELERATION_MULTIPLIER := 4.0
export var FRICTION_MULTIPLIER := 4.0
export var knockbackResistance := 1.0
export var health := 50
export(Resource) var WEAPON

#Globals
var velocity := Vector2.ZERO
var direction = Vector2.ZERO
var isFacingRight := false
var isHoldingWeapon := false
var attacking = false
var player = null

#Nodes
onready var sprite := $AnimatedSprite
onready var cosmeticWeapon := $WeaponSprite
onready var stateAnimationPlayer := $StateAnimPlayer
onready var movementAnimationPlayer := $MoveAnimPlayer
onready var label := $Label
var weapon

#Signals
signal attack(knockbackDirection)

#General
func _ready() -> void:
	label.text = String(health)
	loadWeapon()
	
	var detectionArea = $DetectionArea
	var attackArea = $AttackArea
	var hitBox = $Hitbox
	detectionArea.connect("body_entered", self, "getPlayerInDetectionArea")
	attackArea.connect("body_entered", self, "getPlayerInAttackArea")
	attackArea.connect("body_exited", self, "getPlayerOutAttackArea")
	hitBox.connect("damage", self, "takeDamage")

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			if player != null:
				state = MOVE
		MOVE:
			if stats.playerHealth <= 0:
				player = null
			move(delta)
			
	animate()
	if health <= 0:
		die()

#Movement
func move(delta:float) -> void:
	if player != null:
		direction = global_position.direction_to(player.global_position)
		
		velocity = velocity.move_toward(direction * SPEED, delta * ACCELERATION_MULTIPLIER * SPEED)
		
		if velocity.x > 0:
			isFacingRight = true
		elif velocity.x < 0:
			isFacingRight = false
			
		if isHoldingWeapon:
			attackPrep()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * FRICTION_MULTIPLIER * SPEED)
		if velocity == Vector2.ZERO:
			state = IDLE
	
	velocity = move_and_slide(velocity)

func getPlayerInDetectionArea(body: Node) -> void:
	player = body

#Animation
func animate() -> void:
	#Hurt
	sprite.flip_h = not isFacingRight
	cosmeticWeapon.scale.x = flipHInt(not isFacingRight)
	
	if velocity != Vector2.ZERO:
		if isHoldingWeapon: 
			movementAnimationPlayer.play("weaponWalk")
		else:
			movementAnimationPlayer.play("basicWalk")
	else:
		if isHoldingWeapon: 
			movementAnimationPlayer.play("weaponIdle")
		else:
			movementAnimationPlayer.play("basicIdle")

func flipHInt(x:bool) -> int:
	if x: return -1
	return 1

#Attack
func loadWeapon() -> void:
	if WEAPON != null:
		weapon = WEAPON.instance()
		add_child(weapon)
		weapon.position.y += 8
		weapon.sprite.visible = false
		weapon.configureWeapon(true)
		if weapon.connect("attackEnded", self, "attackEnded"): print("ConnectWeaponEnemyError")
		if self.connect("attack", weapon, "attack"): print("ConnectWeaponEnemyError")
		
		var cosmeticWeaponSprite = $WeaponSprite/Sprite
		cosmeticWeaponSprite.texture = weapon.sprite.texture
		cosmeticWeaponSprite.region_rect = weapon.sprite.region_rect
		cosmeticWeapon.visible = true
		isHoldingWeapon = true

func attackPrep() -> void:
	var angleToPlayer = global_position.angle_to_point(player.global_position) - 135
	weapon.rotation = angleToPlayer
	
	
	if attacking:
		isHoldingWeapon = false
		cosmeticWeapon.visible = false
		weapon.sprite.visible = true
		emit_signal("attack", direction)

func getPlayerInAttackArea(_body: Node) -> void:
	attacking = true

func getPlayerOutAttackArea(_body: Node) -> void:
	attacking = false

func attackEnded() -> void:
	weapon.sprite.visible = false
	cosmeticWeapon.visible = true
	isHoldingWeapon = true

#Get Attacked
func takeDamage(damage:int, knockback:Vector2) -> void:
	health -= damage
	velocity += knockback / knockbackResistance
	label.text = String(health)
	stateAnimationPlayer.play("enemyHurt")

func die() -> void:
	queue_free()
