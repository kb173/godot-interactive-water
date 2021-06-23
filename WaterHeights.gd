extends Node

# Provides access to water height textures for getting the result of the previous frame and for
# setting the working texture for the next frame.
# Values are encoded like this:
# R: y-position
# G: y-velocity
# B: ?
# A: ?
# TODO: Consider increasing the accuracy of the texture


func get_texture():
	return $WaterHeightViewport.get_texture()


func set_previous_texture(texture):
	$WaterHeightViewport/Texture.material.set_shader_param("previous_frame", texture)
