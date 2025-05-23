extends Node2D

@export var main_droite: Node2D
@export var main_gauche: Node2D
@export var pied_droit: Node2D
@export var pied_gauche: Node2D
@export var tete: Node2D

var modif_main_droite: SkeletonModification2DCCDIK = preload("res://Modifications/modif_hand_right.tres")
var modif_main_gauche: SkeletonModification2DCCDIK = preload("res://Modifications/modif_hand_left.tres")
var modif_pied_droit: SkeletonModification2DCCDIK = preload("res://Modifications/modif_pied_droit.tres")
var modif_pied_gauche: SkeletonModification2DCCDIK = preload("res://Modifications/modif_pied_gauche.tres")
var modif_tete: SkeletonModification2DCCDIK = preload("res://Modifications/modif_head.tres")

var next_clignement: float = 3.0
var double_clignement: bool = false

var yeux: AnimatedSprite2D
var timerYeux: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    update_targets()
    yeux = $"Skeleton2D/Hanches/Ventre/Cou/Tête/Yeux"
    timerYeux = $"Skeleton2D/Hanches/Ventre/Cou/Tête/TimerYeux"
    double_clignement = randf() > 0.9
    timerYeux.start(randf_range(3.0, 6.0))
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_targets():
    modif_main_droite.target_nodepath = main_droite.get_path()
    modif_main_gauche.target_nodepath = main_gauche.get_path()
    modif_pied_droit.target_nodepath = pied_droit.get_path()
    modif_pied_gauche.target_nodepath = pied_gauche.get_path()
    modif_tete.target_nodepath = tete.get_path()


func _on_timer_yeux_timeout() -> void:
    if double_clignement:
        yeux.play("double")
    else:
        yeux.play("default")
    
    double_clignement = randf() > 0.9
    timerYeux.start(randf_range(2.0, 4.0))
