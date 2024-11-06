class_name Boid extends Node2D

var size = 24
var area = 64
var speed = 128

var baseColor:Color
var color:Color

var colorChangeCoef:float = .08
var rotationSpeedCoef:float = .32
var separationSpeedCoef:float = 128

var packedVector:PackedVector2Array

var voisins:Array[Boid]

func _ready() -> void:
	setSize(size)
	baseColor = Color(randf_range(-0.2,1.2),randf_range(-0.2,1.2),randf_range(-0.2,1.2))
	color = baseColor

func _draw() -> void:
	draw_colored_polygon(packedVector,color)

func process(delta:float) -> void:
	calcColor(delta)
	calcRotation(delta)
	calcSeparation(delta)
	
	moveForward(delta)

func setSize(s:float):
	size = s
	packedVector.clear()
	packedVector.append(Vector2(0,-size))
	packedVector.append(Vector2(size,size))
	packedVector.append(Vector2(0,size*0.5))
	packedVector.append(Vector2(-size,size))
	

func calcColor(delta:float)->void:
	var meanColor:Color = baseColor;
	for i in voisins: 
		meanColor.r += i.color.r
		meanColor.g += i.color.g
		meanColor.b += i.color.b
	
	meanColor.r /= (voisins.size()+1)
	meanColor.g /= (voisins.size()+1)
	meanColor.b /= (voisins.size()+1)
	
	if(color.r < meanColor.r):color.r=min(color.r+delta/2,meanColor.r)
	elif(color.r > meanColor.r):color.r=max(color.r-delta/2,meanColor.r)
	
	if(color.g < meanColor.g):color.g=min(color.g+delta/2,meanColor.g)
	elif(color.g > meanColor.g):color.g=max(color.g-delta/2,meanColor.g)
	
	if(color.b < meanColor.b):color.b=min(color.b+delta/2,meanColor.b)
	elif(color.b > meanColor.b):color.b=max(color.b-delta/2,meanColor.b)

func calcRotation(delta:float)->void:
	var meanRotation:float = rotation;
	for i in voisins: 
		meanRotation+=i.rotation
	meanRotation /= voisins.size()+1
	
	var diff = meanRotation - rotation
	if diff > PI: diff -= 2 * PI
	elif diff < -PI:diff += 2 * PI
	
	if(diff > 0):rotation = rotation-delta*rotationSpeedCoef
	elif(diff < 0): rotation = rotation+delta*rotationSpeedCoef
	
	if(rotation > PI*2):rotation-=PI-2
	if(rotation < -PI*2):rotation+=PI-2

func calcSeparation(delta):
	var steer:Vector2 = Vector2(0,0);
	for i in voisins: 
		var diff = position - i.position
		steer+=diff.normalized() / position.distance_to(i.position)
	if(steer!=Vector2(0,0)):steer /= voisins.size()
	position+=steer*separationSpeedCoef

func moveForward(delta):
	position.x += sin(rotation) * delta * speed;
	position.y -= cos(rotation) * delta * speed;
	
	if(position.x > 1024+size*2):position.x = -size
	elif(position.x < -size*2):position.x = 1024+size
	if(position.y > 1024+size*2):position.y = -size
	elif(position.y < -size*2):position.y = 1024+size
