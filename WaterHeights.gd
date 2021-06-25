extends Node

# A texture which is continuously (statefully) updated by a shader.
#
# Typical usage: Retrieve the current result with `get_texture` and, at the end of the frame,
# re-insert that texture (updated if needed) with `set_previous_texture`.
#
# Note that the given shader needs to accept a `previous_frame` sampler2D. This represents the
# result of the last frame which is used for generating the new result.


export var size := Vector2(64, 64)
export var shader_material: ShaderMaterial


func _ready():
	$Viewport/Texture.rect_min_size = size
	$Viewport/Texture.rect_size = size
	$Viewport.size = size
	
	$Viewport/Texture.material = shader_material


func get_texture():
	return $Viewport.get_texture()


func set_previous_texture(texture):
	$Viewport/Texture.material.set_shader_param("previous_frame", texture)
