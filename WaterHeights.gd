extends Node


func get_texture(second_viewport: bool):
	var height_viewport = $WaterHeightViewport2 if second_viewport else $WaterHeightViewport
	
	return height_viewport.get_texture()


func set_previous_texture(texture):
	$WaterHeightViewport/Texture.material.set_shader_param("previous_frame", texture)
