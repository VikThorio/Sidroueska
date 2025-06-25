@tool
extends Resource
class_name MyData

@export var save_path: String
@export var nb_quartiers: int = 3
@export var colors: Array[Vector4] = []
@export var labels: Array[String] = []
@export var label_colors: Array[Color] = []
@export var labels_scale: float = 1.0
@export var labels_shift: float = 150.0
@export var labels_max_size: float = 1800.0
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
    labels_max_size = data.labels_max_size
    path_sidou = data.path_sidou
    ventre_over_jeans = data.ventre_over_jeans
    path_dir= data.path_dir

func save_params():
    ResourceSaver.save(self, save_path)

func load_params():
    if ResourceLoader.exists(save_path):
        var params = ResourceLoader.load(save_path)
        if params is Resource: # Check that the data is valid
            self.copy_data(params)
            return true
    return false
