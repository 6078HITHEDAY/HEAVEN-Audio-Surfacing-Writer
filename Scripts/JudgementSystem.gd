@tool
extends Node

enum JUDGE_GRADE {PERFECT, GREAT, GOOD, MISS}

signal judgement_emitted(grade, position)

func initialize_accuracy_grading():
    # 初始化判定参数
    target_position = $CubeMesh.global_transform.origin
    expected_time = $Timeline.get_expected_time()
    
    # 调试用可视化辅助
    if Engine.is_editor_hint():
        $DebugMesh.visible = true
        $DebugMesh.mesh = SphereMesh.new()
        $DebugMesh.mesh.radius = PERFECT_THRESHOLD * 0.4

func _on_element_arrived(element_position):
    var judge_value = calculate_judge_value(element_position)
    var grade = determine_grade(judge_value)
    emit_signal("judgement_emitted", grade, element_position)

func calculate_judge_value(position):
    var time_deviation = abs($Timeline.current_time - expected_time)
    var position_deviation = position.distance_to(target_position)
    
    # 综合判定公式：时间偏差权重60%，空间偏差权重40%
    return clamp(1.0 - (time_deviation * 0.6 + position_deviation * 0.4 * 0.5), 0.0, 1.0)

func determine_grade(value):
    const PERFECT_THRESHOLD = 0.95
    const GREAT_THRESHOLD = 0.8
    const GOOD_THRESHOLD = 0.6
    
    if value >= PERFECT_THRESHOLD:
        return JUDGE_GRADE.PERFECT
    elif value >= GREAT_THRESHOLD:
        return JUDGE_GRADE.GREAT
    elif value >= GOOD_THRESHOLD:
        return JUDGE_GRADE.GOOD
    else:
        return JUDGE_GRADE.MISS

func handle_spatial_transform(transform_type):
    # 处理空间变换时的相对坐标判定
    pass