extends Node2D

@export var save_data: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if !save_data.load_params():
        $Roue.initialize_roue()
        save_data.save_params()
    else:
        $Roue.clear_and_generate_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _input(event):
    if event.is_action_pressed("lancer_roue"):
        if !$Roue.params_visible and !$Sidouska/AnimationPlayer2.is_playing():
            $Sidouska/AnimationPlayer2.play("poser_main_roue_2")
            $Sidouska/AnimationPlayer2.queue("lancer_roue_2")
            $Sidouska/AnimationPlayer2.queue("reset_position")
    if event.is_action_pressed("hide_background"):
        $ColorRect.visible = !$ColorRect.visible

func update_targets():
    $Sidouska.update_targets()

func _on_animation_player_2_animation_changed(old_name: StringName, new_name: StringName) -> void:
    if new_name == "lancer_roue_2":
        $Roue.start_spin()
