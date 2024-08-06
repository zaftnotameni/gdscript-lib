class_name Z_CameraShakeSignals extends Node

@warning_ignore('unused_private_class_variable')
static var _instance : Z_CameraShakeSignals
static func single() -> Z_CameraShakeSignals: return Z_TreeUtil.singleton(Z_CameraShakeSignals)

signal sig_camera_constant_trauma_request(amount:float)
signal sig_camera_constant_trauma_relief(amount:float)
signal sig_camera_constant_trauma_clear()
signal sig_camera_trauma_request(amount:float,max:float)
signal sig_camera_trauma_relief(amount:float)
signal sig_camera_trauma_clear()
