class_name Boid extends Node2D

var size = 24
var area = 32
var speed = 128

var baseColor:Color
var color:Color

var colorChangeCoef:float = 0.2
var rotationSpeedCoef:float = 0.4

var packedVector:PackedVector2Array

var voisins:Array[Boid]

func _ready() -> void:
	packedVector.append(Vector2(0,-size))
	packedVector.append(Vector2(size,size))
	packedVector.append(Vector2(0,size*0.5))
	packedVector.append(Vector2(-size,size))
	
	baseColor = Color(randf_range(-0.2,1.2),randf_range(-0.2,1.2),randf_range(-0.2,1.2))
	color = baseColor

func _draw() -> void:
	draw_colored_polygon(packedVector,color)

func process(delta:float) -> void:
	calcColor(delta)
	calcRotation(delta)
	
	position.x += sin(rotation) * delta * speed;
	position.y -= cos(rotation) * delta * speed;
	
	if(position.x > 1024+size*2):position.x = -size
	elif(position.x < -size*2):position.x = 1024+size
	if(position.y > 1024+size*2):position.y = -size
	elif(position.y < -size*2):position.y = 1024+size

func calcColor(delta:float)->void:
	var meanColor:Color = baseColor;
	for i in voisins: 
		meanColor.r += i.color.r
		meanColor.g += i.color.g
		meanColor.b += i.color.b
	
	meanColor.r /= (voisins.size()+1)
	meanColor.g /= (voisins.size()+1)
	meanColor.b /= (voisins.size()+1)
	
	if(color.r < meanColor.r):color.r+=delta/2
	elif(color.r > meanColor.r):color.r-=delta/2
	
	if(color.g < meanColor.g):color.g+=delta/2
	elif(color.g > meanColor.g):color.g-=delta/2
	
	if(color.b < meanColor.b):color.b+=delta/2
	elif(color.b > meanColor.b):color.b-=delta/2
func calcRotation(delta:float)->void:
	var meanRotation:float = rotation;
	for i in voisins: 
		meanRotation+=i.rotation
	meanRotation /= voisins.size()+1
	
	if(rotation > meanRotation):rotation = max(rotation-delta*rotationSpeedCoef,meanRotation)
	elif(rotation < meanRotation): rotation = min(rotation+delta*rotationSpeedCoef,meanRotation)
