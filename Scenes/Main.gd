extends Node

var scale_brush_force : float = 0.1

onready var screen_size = get_viewport().get_visible_rect().size

var auto_color_current : int = 0

func _ready():
	var velocity_texture = $ViscosityViewport.get_texture()
	$VelocityViewport/Sprite.texture = velocity_texture
	$VelocityViewport/Sprite.material.set_shader_param("velocity", $GradientSubtractionViewport.get_texture())
	var dye_texture = $BackBufferViewport.get_texture()
	$DyeViewport/Sprite.texture = dye_texture
	$DyeViewport/Sprite.material.set_shader_param("brushColor", $UIControl/ColorPickerButton.color)
	
	# Brush Texture
	var brush_texture : Texture = preload("res://Assets/Brushes/SoftBrush.png");
	$VelocityViewport/Sprite.material.set_shader_param("brushTexture", brush_texture)
	$DyeViewport/Sprite.material.set_shader_param("brushTexture", brush_texture)
	var brush_scale: float = 0.2;
	
	var screen_ratio : float = screen_size.x / screen_size.y
	var new_scale : Vector2 = Vector2(brush_scale / screen_ratio, brush_scale)
	$VelocityViewport/Sprite.material.set_shader_param("brushScale", new_scale)
	$DyeViewport/Sprite.material.set_shader_param("brushScale", new_scale)
	
	for child in get_children():
		if child is Viewport:
			child.size = screen_size 

func _process(delta):
	$DyeViewport/Sprite.material.set_shader_param("deltaTime", delta)
	$VelocityViewport/Sprite.material.set_shader_param("deltaTime", delta)


func _apply_velocity_force(position, vector):
	vector *= scale_brush_force
	$VelocityViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$VelocityViewport/Sprite.material.set_shader_param("brushColor", Color(vector.x, vector.y, 0.0, 1.0))
	$VelocityViewport/Sprite.material.set_shader_param("brushOn", true)
	_apply_dye_paint(position, vector)

func _release_velocity_force(position):
	$VelocityViewport/Sprite.material.set_shader_param("brushOn", false)
	$VelocityViewport/Sprite.material.set_shader_param("brushColor", Color.black)
	_release_dye_paint(position)

func _apply_dye_paint(position, vector, cascade : bool = false):
	$DyeViewport/Sprite.material.set_shader_param("brushCenterUV", position)
	$DyeViewport/Sprite.material.set_shader_param("brushOn", true)

func _release_dye_paint(position, cascade : bool = false):
	$DyeViewport/Sprite.material.set_shader_param("brushOn", false)

func _on_ColorPickerButton_color_changed(color):
	$DyeViewport/Sprite.material.set_shader_param("brushColor", color)

