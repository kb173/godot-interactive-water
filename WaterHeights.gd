extends Node

# Provides access to water height textures for getting the result of the previous frame and for
# setting the working texture for the next frame.
# Values are encoded like this:
# R: y-position
# G: y-position (second component)
# B: y-velocity
# A: y-acceleration
# TODO: Consider increasing the accuracy of the texture

export var size := Vector2(64, 64)


func _ready():
	$Viewport/Texture.rect_min_size = size
	$Viewport/Texture.rect_size = size
	$Viewport.size = size


func get_texture():
	return $Viewport.get_texture()


func set_previous_texture(texture):
	$Viewport/Texture.material.set_shader_param("previous_frame", texture)
