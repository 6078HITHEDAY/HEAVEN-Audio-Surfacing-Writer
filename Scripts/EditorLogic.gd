@tool
extends Node

# 元素生成系统
var element_system = preload("res://Scripts/ElementSystem.gd").new()
# 判定系统
var judgement_system = preload("res://Scripts/JudgementSystem.gd").new()

func _ready():
	setup_spatial_coordinates()
	initialize_editor_components()

func setup_spatial_coordinates():
	# 初始化三维时空坐标系
	pass

func initialize_editor_components():
	# 初始化编辑器组件
	element_system.connect("element_created", _on_element_created)
	judgement_system.initialize_accuracy_grading()

func _on_element_created(element_type, position):
	# 处理元素创建事件
	print("元素已创建：", element_type, " 位置：", position)
