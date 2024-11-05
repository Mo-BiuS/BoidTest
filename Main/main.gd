extends Node2D

@onready var boidContainer:Node2D = $BoidContainer
@onready var view:CanvasLayer = $View

var boidList:Array[Boid]
const N_BOID = 128

func _ready() -> void:
	for i in N_BOID:
		var boid:Boid = Boid.new()
		boid.position = Vector2(randf_range(0,1024),randf_range(0,1024))
		boid.rotate(randf_range(0,PI*2))
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
