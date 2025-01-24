class_name LightBuld extends Node3D

@export var on: bool = true

@onready var _mesh: MeshInstance3D = $Mesh
@onready var _light: OmniLight3D = $Light

func _ready() -> void:
	toggle(on)

func toggle(enable: bool) -> void:
	_light.visible = enable
	on = enable

	if not enable:
		# Restaura o material para usar iluminação padrão
		if _mesh.material_override != null:
			_mesh.material_override.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		return

	# Cria ou usa um material override
	if _mesh.material_override == null:
		_mesh.material_override = StandardMaterial3D.new()

	# Configura o material para ignorar luz e sombra
	_mesh.material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_mesh.material_override.albedo_color = Color.WHITE
