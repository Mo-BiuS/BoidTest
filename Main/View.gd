extends CanvasLayer

@onready var panel:PanelContainer = $VBoxContainer/PanelContainer

signal sizeChanged(value:float)
signal areaChanged(value:float)
signal speedChanged(value:float)

signal rotationCoefChanged(value:float)
signal separationCoefChanged(value:float)

func _on_show_hide_toggled(toggled_on: bool) -> void:
	if(toggled_on):panel.show()
	else:panel.hide()

func _on_size_box_value_changed(value: float) -> void:
	sizeChanged.emit(value)
func _on_area_box_value_changed(value: float) -> void:
	areaChanged.emit(value)
func _on_speed_box_value_changed(value: float) -> void:
	speedChanged.emit(value)

func _on_rotation_coef_box_value_changed(value: float) -> void:
	rotationCoefChanged.emit(value)
func _on_separation_coef_box_2_value_changed(value: float) -> void:
	separationCoefChanged.emit(value)
