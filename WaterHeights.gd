extends Node


func get_texture():
	return $WaterHeightViewport.get_texture()


func set_previous_texture(texture):
	$WaterHeightViewport/Texture.material.set_shader_param("previous_frame", texture)
