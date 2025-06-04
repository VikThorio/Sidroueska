extends Node2D

var MAX_NUMBER = 50

signal skin_changed
signal stopped_spinning

@export var save_data: Resource
@export var winning_point: Node2D

var label_scene = preload("res://roue_label.tscn")

var is_spinning: bool = false
var speed: float = 0.0
var acceleration: float = 1000.0
var min_speed: float = PI * 0.4

var border_values: Array[float] = []
var params_visible: bool = false

var temp_color: Color = Color.BLACK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    border_values.resize(3000)
    border_values.fill(0.0)
    if save_data.path_dir == "":
        var dir = DirAccess.open($FileDialog.current_dir)
        save_data.path_dir = DirAccess.get_drive_name(dir.get_current_drive())

func _input(event):
    if event.is_action_pressed("toggle_parametres"):
        $Parameters.visible = !$Parameters.visible
        params_visible = $Parameters.visible
        $Parameters/LineEdit.release_focus()
        

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if is_spinning:
        $Roue.rotation -= speed * delta
        $Roue.rotation = fposmod($Roue.rotation, 2.0 * PI)
        
        speed -= get_acceleration() * delta
        
        if speed <= 0.01:
            stopped_spinning.emit()
            is_spinning = false
            speed = 0.0

func color_to_vector4(col: Color):
    return Vector4(col.r, col.g, col.b, col.a)

func vector4_to_color(vec: Vector4):
    return Color(vec.x, vec.y, vec.z, vec.w)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if $Parameters.visible:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            var angle: float = atan2(get_local_mouse_position().y, get_local_mouse_position().x);
            angle = fposmod(angle + PI - $Roue.rotation, 2.0 * PI)
            var quartier_idx_f: float = angle / (2.0 * PI) * float(save_data.nb_quartiers);
            var quartier_idx: int = int(quartier_idx_f);
            
            if $Parameters/PaintSlice.button_pressed or $Parameters/CopierColler.button_pressed:
                save_data.colors[quartier_idx] = color_to_vector4($Parameters/ColorPicker.color)
                $Roue.material.set_shader_parameter("couleurs", save_data.colors);
            if $Parameters/PainText.button_pressed:
                save_data.label_colors[quartier_idx] = $Parameters/ColorPicker.color
                $Roue/Labels.get_children()[quartier_idx].color = $Parameters/ColorPicker.color
            if $Parameters/ChangeText.button_pressed or $Parameters/CopierColler.button_pressed:
                save_data.labels[quartier_idx] = $Parameters/LineEdit.text
                $Roue/Labels.get_children()[quartier_idx].text = $Parameters/LineEdit.text
            if $Parameters/CopierColler.button_pressed:
                save_data.label_colors[quartier_idx] = temp_color
                $Roue/Labels.get_children()[quartier_idx].color = temp_color
            clear_and_generate_labels()
        
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            var angle: float = atan2(get_local_mouse_position().y, get_local_mouse_position().x);
            angle = fposmod(angle + PI - $Roue.rotation, 2.0 * PI)
            var quartier_idx_f: float = angle / (2.0 * PI) * float(save_data.nb_quartiers);
            var quartier_idx: int = int(quartier_idx_f);
            
            if $Parameters/PaintSlice.button_pressed or $Parameters/CopierColler.button_pressed:
                $Parameters/ColorPicker.color = vector4_to_color(save_data.colors[quartier_idx])
            if $Parameters/PainText.button_pressed:
                $Parameters/ColorPicker.color = $Roue/Labels.get_children()[quartier_idx].color
            if $Parameters/ChangeText.button_pressed or $Parameters/CopierColler.button_pressed:
                $Parameters/LineEdit.text = $Roue/Labels.get_children()[quartier_idx].text
            if $Parameters/CopierColler.button_pressed:
                temp_color = $Roue/Labels.get_children()[quartier_idx].color

func _on_spin_box_value_changed(value: float) -> void:
    save_data.nb_quartiers = int(value)
    clear_and_generate_labels()
    $Roue.material.set_shader_parameter("n_quartiers", save_data.nb_quartiers);

func clear_and_generate_labels():
    var all_labels = $Roue/Labels.get_children()
    for l in all_labels:
        l.queue_free()
    
    $Parameters/SpinBox.value = save_data.nb_quartiers
    $Parameters/ShiftSlider.value = save_data.labels_shift
    $Parameters/SizeSlider.value = save_data.labels_scale
    for i in save_data.nb_quartiers:
        var new_label = label_scene.instantiate()
        new_label.scale = Vector2(save_data.labels_scale, save_data.labels_scale)
        new_label.set_decalage(save_data.labels_shift / save_data.labels_scale)
        new_label.set_case(i, save_data.nb_quartiers)
        new_label.color = save_data.label_colors[i]
        new_label.text = save_data.labels[i]
        $Roue/Labels.add_child(new_label)
    
    $Roue.material.set_shader_parameter("n_quartiers", save_data.nb_quartiers);
    $Roue.material.set_shader_parameter("couleurs", save_data.colors);

func start_spin():
    #if !is_spinning:
    is_spinning = true
    speed = randf_range(PI * 3.0, PI * 5.0)
    acceleration = randf_range(PI * 1.0, PI * 1.2)

func _on_size_slider_value_changed(value: float) -> void:
    save_data.labels_scale = value
    clear_and_generate_labels()


func _on_shift_slider_value_changed(value: float) -> void:
    save_data.labels_shift = value
    clear_and_generate_labels()

func creer_ligne_courbee():
    var min_v = -1.0
    var max_v = 1.0
    for i in 3000:
        pass

func initialize_roue():
    save_data.nb_quartiers = int($Parameters/SpinBox.value)
    save_data.labels.resize(MAX_NUMBER)
    save_data.colors.resize(MAX_NUMBER)
    save_data.label_colors.resize(MAX_NUMBER)
    save_data.colors.fill(color_to_vector4(Color.WHITE))
    save_data.labels.fill("")
    save_data.label_colors.fill(Color.BLACK)
    save_data.labels[0] = "Steam"
    save_data.labels[1] = "Epic"
    save_data.labels[2] = "Bureau"
    clear_and_generate_labels()


func _on_sauvegarder_pressed() -> void:
    save_data.save_params()


func _on_skin_pressed() -> void:
    $FileDialog.current_dir = save_data.path_dir
    $FileDialog.visible = true


func _on_skin_reset_pressed() -> void:
    save_data.path_sidou = ""
    skin_changed.emit()


func _on_file_dialog_file_selected(path: String) -> void:
    save_data.path_sidou = path
    save_data.path_dir = path.get_base_dir()
    skin_changed.emit()


func _on_check_box_toggled(toggled_on: bool) -> void:
    save_data.ventre_over_jeans = toggled_on
    skin_changed.emit()


func _on_refresh_skin_pressed() -> void:
    skin_changed.emit()

func set_ventre_over_jambes(val: bool):
    $Parameters/CheckBox.button_pressed = val

func get_roue_rotation():
    return $Roue.rotation

func get_acceleration():
    var pos: Vector2 = winning_point.global_position - global_position
    var angle: float = atan2(pos.y, pos.x) - get_roue_rotation()
    while angle < -PI:
        angle += 2.0 * PI
    var case_idx_f: float = (angle + PI) / (2.0 * PI) * float(save_data.nb_quartiers)
    var dist: float = absf(case_idx_f - roundf(case_idx_f)) / 0.5
    dist = maxf(dist - 0.3, 0.0) / 0.7
    return sqrt(dist) * acceleration
