@tool
extends Resource
class_name MyData

@export var nb_quartiers: int = 3
@export var colors: Array[Vector4] = []
@export var labels: Array[String] = []
@export var label_colors: Array[Color] = []
@export var labels_scale: float = 1.0
@export var labels_shift: float = 150.0
@export var path_sidou: String = ""
@export var ventre_over_jeans: bool = false
@export var path_dir: String = ""

func copy_data(data: MyData):
    nb_quartiers = data.nb_quartiers
    colors = data.colors
    labels = data.labels
    label_colors = data.label_colors
    labels_scale = data.labels_scale
    labels_shift = data.labels_shift
    path_sidou = data.path_sidou
    ventre_over_jeans = data.ventre_over_jeans
    path_dir= data.path_dir

func save_params():
    ResourceSaver.save(self, "user://parameters_data.tres")

func load_params():
    if ResourceLoader.exists("user://parameters_data.tres"):
        var params = ResourceLoader.load("user://parameters_data.tres")
        if params is Resource: # Check that the data is valid
            self.copy_data(params)
            return true
    return false
