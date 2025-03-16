@tool
extends Node

var editor_scene : Node
var runtime_scene : Node

func initialize_preview():
    # 带预加载的初始化
    editor_scene = get_tree().current_scene
    runtime_scene = preload("res://Scene/RuntimeScene.tscn").instantiate()
    
    # 预创建对象池
    for i in 20:
        var element = editor_scene.element_system.spawn_element(ElementSystem.ELEMENT_TYPE.SURFACE_TAP)
        element.free()
    
    add_child(runtime_scene)
    
    # 连接性能监控信号
    if OS.is_debug_build():
        $PerformanceMonitor.start()

var element_pool := {}

func sync_element_creation(element_type, params):
    # 使用对象池管理元素实例
    var element = get_from_pool(element_type) or editor_scene.element_system.spawn_element(element_type, params)
    
    # 四元数插值同步
    var target_q = Quaternion(Vector3.UP, params.angle)
    element.transform.basis = Basis(element.transform.basis.get_rotation_quaternion().slerp(target_q, 0.5))
    
    runtime_scene.add_child(element)
    element.set_meta("last_sync_time", Time.get_ticks_msec())

func get_from_pool(element_type):
    var current_time = Time.get_ticks_msec()
    for child in runtime_scene.get_children():
        if child.get_meta("type") == element_type and current_time - child.get_meta("last_sync_time") > 1000:
            return child
    return null

func update_time_axis(position):
    # 更新时间轴显示
    $UI/TimeAxis.update_indicator(position)