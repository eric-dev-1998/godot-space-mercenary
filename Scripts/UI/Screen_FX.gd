extends Control

class_name Screen_FX

enum FX_Type {
	Dark_in,
	Dark_out,
	Light_in,
	Light_out,
}

var queue: Array
var dark: ColorRect
var light: ColorRect
var anim: AnimationPlayer
var finished: bool = true

func _ready() -> void:
	dark = get_node("Dark")
	light = get_node("Light")
	anim = get_node("AnimationPlayer")
	
	dark.visible = true
	light.visible = false

func _process(delta: float) -> void:
	if queue.size() != 0:
		for fx in queue:
			if finished:
				play(fx)

func play(fx: FX_Type) -> void:
	match fx:
		FX_Type.Dark_in:
			dark.visible = true;
			anim.play("anim_screenfx_dark_in")
		FX_Type.Dark_out:
			dark.visible = true;
			anim.play("anim_screenfx_dark_out")
		FX_Type.Light_in:
			light.visible = true;
			anim.play("anim_screenfx_light_in")
		FX_Type.Light_out:
			light.visible = true;
			anim.play("anim_screenfx_light_ou")
	
	finished = false;

func onFinish() -> void:
	finished = true;
	queue.remove_at(0)
