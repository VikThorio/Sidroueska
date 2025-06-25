extends Node2D

var scene_actuelle = 0

func _input(event):
    if event.is_action_pressed("change_roue"):
        if scene_actuelle == 0:
            var main_scene_steam = load("res://main_scene_steam.tscn").instantiate()
            get_children()[0].queue_free()
            add_child(main_scene_steam)
            scene_actuelle = 1
        else:
            var main_scene = load("res://main_scene.tscn").instantiate()
            get_children()[0].queue_free()
            add_child(main_scene)
            scene_actuelle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var main_scene = load("res://main_scene.tscn").instantiate()
    add_child(main_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
