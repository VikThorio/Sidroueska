@tool
extends Node2D

@export var save_data: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if !save_data.load_params():
        $Roue.initialize_roue()
        save_data.save_params()
    else:
        $Roue.clear_and_generate_labels()
    $Sidouska.set_textures_polygons()
    $Roue.set_ventre_over_jambes(save_data.ventre_over_jeans)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _input(event):
    if event.is_action_pressed("lancer_roue"):
        if !$Roue.params_visible and !$Sidouska/AnimationPlayer2.is_playing():
            $Sidouska/AnimationPlayer2.play("poser_main_roue_2")
            $Sidouska/AnimationPlayer2.queue("lancer_roue_2")
            $Sidouska/AnimationPlayer2.queue("reset_position")
    if event.is_action_pressed("toggle_parametres"):
        $ColorRect.visible = !$ColorRect.visible
    if event.is_action_pressed("faire_coucou"):
        get_case_win()
        if !$Roue.params_visible and !$Sidouska/AnimationPlayer2.is_playing():
            $Sidouska/AnimationPlayer2.play("coucou")

func update_targets():
    $Sidouska.update_targets()

func _on_animation_player_2_animation_changed(old_name: StringName, new_name: StringName) -> void:
    if new_name == "lancer_roue_2":
        $Roue.start_spin()


func _on_roue_skin_changed() -> void:
    $Sidouska.set_textures_polygons()

func get_case_win():
    var pos: Vector2 = $Triangle/WinningPoint.global_position - $Roue.global_position
    var angle: float = atan2(pos.y, pos.x) - $Roue.get_roue_rotation()
    while angle < -PI:
        angle += 2.0 * PI
    var case_idx: int = (angle + PI) / (2.0 * PI) * float(save_data.nb_quartiers)
    
    print(($Roue.get_roue_rotation()) / (2.0 * PI) * float(save_data.nb_quartiers))
    return case_idx

func _on_roue_stopped_spinning() -> void:
    print(save_data.labels[get_case_win()])
