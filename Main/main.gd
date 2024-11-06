extends Node2D

@onready var boidContainer:Node2D = $BoidContainer
@onready var view:CanvasLayer = $View

var boidList:Array[Boid]
const N_BOID = 256

func _ready() -> void:
	for i in N_BOID:
		var boid:Boid = Boid.new()
		boid.position = Vector2(randf_range(0,1024),randf_range(0,1024))
		boid.rotate(randf_range(-PI,PI))
		boidList.append(boid)
		add_child(boid)

func _draw() -> void:
	draw_rect(Rect2(0,0,1024,1024),Color(255,255,255))

func _process(delta: float) -> void:
	queue_redraw()
	for i in boidList:
		i.voisins.clear()
		for j in boidList:
			if !i == j && i.position.distance_to(j.position) < i.area:
				i.voisins.append(j)
		i.process(delta)
		i.queue_redraw()


func _on_view_area_changed(value: float) -> void:
	for i in boidList: i.area = value
func _on_view_size_changed(value: float) -> void:
	for i in boidList: i.setSize(value)
func _on_view_speed_changed(value: float) -> void:
	for i in boidList: i.speed = value

func _on_view_rotation_coef_changed(value: float) -> void:
	for i in boidList: i.rotationSpeedCoef = value
