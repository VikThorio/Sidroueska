extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for b: TextureButton in get_children():
        var texture: CompressedTexture2D = b.texture_normal
        var bitmap: BitMap = BitMap.new()
        bitmap.create_from_image_alpha(texture.get_image())
        b.texture_click_mask = bitmap

func get_buttons_pressed():
    return [
            $PaintLetters.button_pressed,
            $PaintSquare.button_pressed,
            $ChangeText.button_pressed,
            ]

func unpress_all_except(buttons: Array = []):
    for b: TextureButton in get_children():
        if b not in buttons:
            b.button_pressed = false

func press_all_except(buttons: Array = []):
    for b: TextureButton in get_children():
        if b not in buttons:
            b.button_pressed = true

func press_these(buttons: Array = []):
    for b: TextureButton in buttons:
        b.button_pressed = true

func _on_paint_letters_pressed() -> void:
    var buttons_on: Array[TextureButton] = [$PaintLetters]
    press_these(buttons_on)
    unpress_all_except(buttons_on)


func _on_paint_square_pressed() -> void:
    var buttons_on: Array[TextureButton] = [$PaintSquare]
    press_these(buttons_on)
    unpress_all_except(buttons_on)


func _on_change_text_pressed() -> void:
    var buttons_on: Array[TextureButton] = [$ChangeText]
    press_these(buttons_on)
    unpress_all_except(buttons_on)


func _on_c_tand_pl_pressed() -> void:
    var buttons_on: Array[TextureButton] = [$CTandPL, $ChangeText, $PaintLetters]
    press_these(buttons_on)
    unpress_all_except(buttons_on)


func _on_c_tand_ps_pressed() -> void:
    var buttons_on: Array[TextureButton] = [$CTandPS, $ChangeText, $PaintSquare]
    press_these(buttons_on)
    unpress_all_except(buttons_on)


func _on_p_sand_pl_pressed() -> void:
    var buttons_on: Array[TextureButton] = [$PSandPL, $PaintSquare, $PaintLetters]
    press_these(buttons_on)
    unpress_all_except(buttons_on)


func _on_all_button_pressed() -> void:
    press_all_except()
