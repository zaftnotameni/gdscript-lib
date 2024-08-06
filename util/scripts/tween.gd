class_name Z_TweenUtil extends RefCounted

static func scene_tree() -> SceneTree:
	return Engine.get_main_loop()

static func tween_kill(t:Tween):
	if t and t.is_running(): t.kill()

static func tween_fresh(t:Tween=scene_tree().create_tween(),always_kill:=true)->Tween:
	if t and (always_kill or t.is_running()):
		t.kill()
	t = scene_tree().create_tween()
	t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_BOUND)
	return t

static func tween_eased_in_out_cubic(t:Tween=scene_tree().create_tween())->Tween:
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_BOUND)
	return t

static func tween_fresh_eased_in_out_cubic(t:Tween=scene_tree().create_tween(),always_kill:=true)->Tween:
	t = tween_fresh(t,always_kill)
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_BOUND)
	return t

static func tween_ignores_pause(t:Tween=scene_tree().create_tween())->Tween:
	t.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	return t
