extends Node2D


var color: Color = Color.BLACK:
    get:
        return color
    set(val):
        color = val
        $Label.add_theme_color_override("font_color", val)

var text: String = "":
    get:
        return text
    set(val):
        text = val
        $Label.text = text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func set_decalage(val: float):
    $Label.position.x = -1800.0 - val


func set_case(numero: int, count: int):
    var angle_delta: float = PI * 2.0 / float(count)
    var angle: float = angle_delta / 2.0 + angle_delta * float(numero)
    rotation = angle
