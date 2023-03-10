extends KinematicBody2D

#Constants
export var SPEED := 130
export var ACCELERATION_MULTIPLIER := 4.0
export var FRICTION_MULTIPLIER := 8.0
export var KNOCKBACK_RESISTANCE := 1.2
export var DASH_SPEED := 300
export(Resource) var WEAPON

#Globals
var isFacingRight := false
var inputDirection := Vector2.ZERO
var velocity := Vector2.ZERO
var isHoldingWeapon := false
var isJustHurt := false
var isHealthLow := false
var isAbleToDash := true

var hurtSfx = preload("res://Sound-Effects/Hurt.wav")
var dummy = preload("res://Player/playerDummy.tscn")

#Nodes
onready var sprite := $AnimatedSprite
onready var movementAnimationPlayer := $AnimationPlayer
onready var UIanimationPlayer := $UIAnimationPlayer
onready var stateAnimationPlayer := $StateAnimationPlayer
onready var cosmeticWeapon := $WeaponSprite
onready var sfxPlayer := $AudioStreamPlayer
onready var healthBar := $HealthBar
onready var timer := $Timer
var weapon

#Signals
signal attack(knockbackDirection)

#Main
func _ready() -> void:
	loadWeapon()
	healthBar.max_value = stats.PLAYER_MAX_HEALTH
	healthBar.value = stats.playerHealth
	displayHealth()
	
func _physics_process(delta: float) -> void:
	animate()
	getInput()
	move(delta)
	if stats.playerHealth <= 0:
		die()

#Movement
func move(delta: float) -> void:
		
	if inputDirection != Vector2.ZERO:
		#Move x
		if (inputDirection.x * velocity.x) > 0:
			velocity.x = move_toward(velocity.x, SPEED * inputDirection.x, ACCELERATION_MULTIPLIER * SPEED * delta)
		else:
			velocity.x = move_toward(velocity.x, SPEED * inputDirection.x, FRICTION_MULTIPLIER * SPEED * delta)
		#Move y
		if (inputDirection.y * velocity.y) > 0:
			velocity.y = move_toward(velocity.y, SPEED * inputDirection.y, ACCELERATION_MULTIPLIER * SPEED * delta)
		else:
			velocity.y = move_toward(velocity.y, SPEED * inputDirection.y, FRICTION_MULTIPLIER * SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION_MULTIPLIER * SPEED * delta)

	healthBar.value = stats.playerHealth
	velocity = move_and_slide(velocity)

func getInput() -> void:
	inputDirection.x = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
	inputDirection.y = Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp")
	if Input.is_action_just_pressed("moveRight"):
		isFacingRight = true
	elif Input.is_action_just_pressed("moveLeft"):
		isFacingRight = false
		
	inputDirection = inputDirection.normalized()
	
	if isHoldingWeapon and Input.is_action_just_pressed("attack"):
		attackPrep(true)
	else:
		attackPrep()
	
	if isAbleToDash and Input.is_action_just_pressed("dash"):
		dash()

func dash() -> void:
	velocity = DASH_SPEED * inputDirection
	
	instanceClone()
	
	isAbleToDash = false
	timer.start()

func dashCooldownEnd() -> void:
	isAbleToDash = true

func instanceClone() -> void:
	var afterImage = dummy.instance()
	get_parent().get_parent().add_child(afterImage)
	afterImage.global_position = global_position
	afterImage.animation = sprite.animation
	afterImage.frame = sprite.frame
	afterImage.flip_h = sprite.flip_h

#Animate
func animate() -> void:
	#Hurt
	sprite.flip_h = not isFacingRight
	cosmeticWeapon.scale.x = flipHInt(not isFacingRight)
	
	if isJustHurt: 
		stateAnimationPlayer.play("hurt")
	if not isAbleToDash:
		if isHoldingWeapon: 
			movementAnimationPlayer.play("weaponDash")
		else:
			movementAnimationPlayer.play("basicDash")
	elif velocity != Vector2.ZERO:
		if isHoldingWeapon: 
			movementAnimationPlayer.play("weaponWalk")
		else:
			movementAnimationPlayer.play("basicWalk")
	else:
		if isHoldingWeapon: 
			movementAnimationPlayer.play("weaponIdle")
		else:
			movementAnimationPlayer.play("basicIdle")

func animationFinished(_animationName:String) -> void:
	isJustHurt = false

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
		weapon.configureWeapon()
		if weapon.connect("attackEnded", self, "attackEnded"): print("ConnectWeaponToPlayerError")
		if self.connect("attack", weapon, "attack"): print("ConnectWeaponToPlayerError")
		
		var cosmeticWeaponSprite := $WeaponSprite/Sprite
		cosmeticWeaponSprite.texture = weapon.sprite.texture
		cosmeticWeaponSprite.region_rect = weapon.sprite.region_rect
		cosmeticWeapon.visible = true
		isHoldingWeapon = true

func attackPrep(attack := false) -> void:
	var angleToMouse = global_position.angle_to_point(get_global_mouse_position()) - 135
	weapon.rotation = angleToMouse
	
	if attack:
		var knockbackDirection = Vector2(cos(angleToMouse),sin(angleToMouse))
		isHoldingWeapon = false
		cosmeticWeapon.visible = false
		weapon.sprite.visible = true
		emit_signal("attack", knockbackDirection)

func attackEnded() -> void:
	weapon.sprite.visible = false
	cosmeticWeapon.visible = true
	isHoldingWeapon = true

#Get Attacked
func takeDamage(damage:int, knockback:Vector2) -> void:
	stats.changeHealth(damage)
	healthBar.visible = true
	velocity += knockback / KNOCKBACK_RESISTANCE
	isJustHurt = true
	displayHealth()
	sfxPlayer.stream = hurtSfx
	sfxPlayer.play()

func displayHealth() -> void:
	if stats.PLAYER_MAX_HEALTH / 2 >= stats.playerHealth:
		isHealthLow = true
		healthBar.visible = true
	if isHealthLow:
		UIanimationPlayer.play("Bobble Health Bar")
	else:
		UIanimationPlayer.play("Fade Health Bar")

func die() -> void:
	stats.changeSFX("PlayerDeath")
	queue_free()

