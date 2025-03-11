extends Panel
class_name InventorySlotUI

signal selected(index: int)

enum State { NONE, HIGHLIGHT, SELECT }

var slot_index: int = -1
var has_item: bool = false
var state: State = State.NONE: set = _set_state

@onready var base_control: Control = $Base
@onready var item_icon: TextureRect = $Base/ItemIcon

# Parameters for tweens and visual effects.
const _TWEEN_DURATION: float = 0.1
const _TWEEN_TRANSITION: Tween.TransitionType = Tween.TRANS_QUAD
var _highlight_tween: Tween = null
var _pulse_tween: Tween = null
var _refresh_tween: Tween = null
var _highlight_scale_factor: float = 0.0: set = _set_highlight_scale_factor
var _pulse_scale_factor: float = 0.0: set = _set_pulse_scale_factor
var _item_icon_opacity: float = 1.0: set = _set_item_icon_opacity
var _slot_opacity: float = 1.0: set = _set_slot_opacity

func _ready() -> void:
	state = State.NONE

func select() -> void:
	selected.emit(slot_index)
	_pulse_effect()

func refresh(item: Item) -> void:
	has_item = item != null
	_pulse_effect()

	# Cancels the previous tween if active.
	if _refresh_tween != null and _refresh_tween.is_valid():
		_refresh_tween.kill()

	_refresh_tween = create_tween().set_trans(_TWEEN_TRANSITION).set_parallel(true)

	if has_item:
		_refresh_tween.tween_callback(item_icon.set_texture.bind(item.icon))
		_refresh_tween.tween_property(self, ^"_item_icon_opacity", 1.0, _TWEEN_DURATION)
		_refresh_tween.tween_property(base_control, ^"scale", Vector2.ONE, _TWEEN_DURATION).from(Vector2.ZERO)
	else:
		_refresh_tween.tween_property(base_control, ^"scale", Vector2.ZERO, _TWEEN_DURATION).from(Vector2.ONE)
		_refresh_tween.tween_property(self, ^"_item_icon_opacity", 0.0, _TWEEN_DURATION)
		_refresh_tween.chain().tween_callback(item_icon.set_texture.bind(null))

func _normal_state_transition() -> void:
	_highlight_tween.tween_property(item_icon, ^"modulate", Color.WHITE, _TWEEN_DURATION)
	_highlight_tween.tween_property(self, ^"_slot_opacity", 0.25, _TWEEN_DURATION)
	_highlight_tween.tween_property(self, ^"_highlight_scale_factor", 0.0, _TWEEN_DURATION)

func _highlight_state_transition() -> void:
	_highlight_tween.tween_property(item_icon, ^"modulate", Color.WHITE, _TWEEN_DURATION)
	_highlight_tween.tween_property(self, ^"_slot_opacity", 0.5, _TWEEN_DURATION)
	_highlight_tween.tween_property(self, ^"_highlight_scale_factor", 0.25, _TWEEN_DURATION)

func _selected_state_transition() -> void:
	_highlight_tween.tween_property(item_icon, ^"modulate", Color.BLACK, _TWEEN_DURATION)
	_highlight_tween.tween_property(self, ^"_slot_opacity", 1.0, _TWEEN_DURATION)
	_highlight_tween.tween_property(self, ^"_highlight_scale_factor", 0.0, _TWEEN_DURATION)

func _pulse_effect() -> void:
	# Cancels the pulse tween if active.
	if _pulse_tween != null and _pulse_tween.is_valid():
		_pulse_tween.kill()

	_pulse_tween = create_tween().set_trans(_TWEEN_TRANSITION)
	_pulse_tween.tween_property(self, ^"_pulse_scale_factor", 0.25, _TWEEN_DURATION)
	_pulse_tween.tween_property(self, ^"_pulse_scale_factor", 0.0, _TWEEN_DURATION)

func _set_state(value: State) -> void:
	state = value

	# Cancels the highlight tween if active.
	if _highlight_tween != null and _highlight_tween.is_valid():
		_highlight_tween.kill()

	_highlight_tween = create_tween().set_trans(_TWEEN_TRANSITION).set_parallel(true)

	match value:
		State.NONE:
			_normal_state_transition()
		State.HIGHLIGHT:
			_highlight_state_transition()
		State.SELECT:
			_selected_state_transition()

func _update_scale() -> void:
	# Updates the scale by combining highlight and pulse effects.
	scale = Vector2.ONE * (1.0 + _highlight_scale_factor + _pulse_scale_factor)

func _set_highlight_scale_factor(value: float) -> void:
	_highlight_scale_factor = value
	_update_scale()

func _set_pulse_scale_factor(value: float) -> void:
	_pulse_scale_factor = value
	_update_scale()

func _set_item_icon_opacity(value: float) -> void:
	_item_icon_opacity = value
	item_icon.modulate.a = value

func _set_slot_opacity(value: float) -> void:
	_slot_opacity = value
	self_modulate.a = value
