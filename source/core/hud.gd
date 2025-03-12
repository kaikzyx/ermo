class_name HUD extends Control

@onready var _crosshair: Control = $Crosshair
@onready var _label_interactable_name: Label = $InteractionContainer/InteractableContainer/InteractableName
@onready var _label_interactable_message: Label = $InteractionContainer/InteractableContainer/InteractableMessage
@onready var _label_interactable_action: Label = $InteractionContainer/InteractionAction

const _TWEEN_DURATION: float = 0.1
const _TWEEN_TRANSITION: Tween.TransitionType = Tween.TRANS_SINE
var _crosshair_tween_in_interact: Tween = null
var _crosshair_tween_in_focus: Tween = null
var _crosshair_scale_factor_in_interact: float = 0.0: set = _set_crosshair_scale_factor_in_interact
var _crosshair_scale_factor_in_focus: float = 0.0: set = _set_crosshair_scale_factor_in_focus

func _ready() -> void:
	if is_instance_valid(Global.actor):
		Global.actor.interactor.focus_entered.connect(_on_actor_interactor_focus_entered)
		Global.actor.interactor.focus_exited.connect(_on_actor_interactor_focus_exited)

	_label_interactable_action.hide()
	_label_interactable_action.text = &"Press " + Global.get_prompt(&"interact") + &" to interact."

func _on_actor_interactor_focus_entered(interactable: Interactable) -> void:
	interactable.message_changed.connect(_on_actor_interactor_interactable_message_changed)

	# Format the text with the message of the interactive, if any.
	_label_interactable_message.text = &""
	if not interactable.message.is_empty():
		_label_interactable_message.text = &" - " + interactable.message

	_label_interactable_name.text = interactable.owner.name.capitalize()
	_label_interactable_action.show()

	# Cancels the tween if active.
	if _crosshair_tween_in_focus != null and _crosshair_tween_in_focus.is_valid():
		_crosshair_tween_in_focus.kill()

	_crosshair_tween_in_focus = create_tween().set_trans(_TWEEN_TRANSITION)
	_crosshair_tween_in_focus.tween_property(self, ^"_crosshair_scale_factor_in_focus", 1.0, _TWEEN_DURATION)
	_crosshair_tween_in_focus.tween_property(self, ^"_crosshair_scale_factor_in_focus", 0.5, _TWEEN_DURATION)

func _on_actor_interactor_focus_exited(interactable: Interactable) -> void:
	if is_instance_valid(interactable):
		interactable.message_changed.disconnect(_on_actor_interactor_interactable_message_changed)

	# Clear.
	_label_interactable_name.text = &""
	_label_interactable_message.text = &""
	_label_interactable_action.hide()

	# Cancels the tween if active.
	if _crosshair_tween_in_focus != null and _crosshair_tween_in_focus.is_valid():
		_crosshair_tween_in_focus.kill()

	_crosshair_tween_in_focus = create_tween().set_trans(_TWEEN_TRANSITION)
	_crosshair_tween_in_focus.tween_property(self, ^"_crosshair_scale_factor_in_focus", -0.5, _TWEEN_DURATION)
	_crosshair_tween_in_focus.tween_property(self, ^"_crosshair_scale_factor_in_focus", 0.0, _TWEEN_DURATION)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"interact"):
		# Cancels the tween if active.
		if _crosshair_tween_in_interact != null and _crosshair_tween_in_interact.is_valid():
			_crosshair_tween_in_interact.kill()

		_crosshair_tween_in_interact = create_tween().set_trans(_TWEEN_TRANSITION)
		_crosshair_tween_in_interact.tween_property(self, ^"_crosshair_scale_factor_in_interact", -0.5, _TWEEN_DURATION)
		_crosshair_tween_in_interact.tween_property(self, ^"_crosshair_scale_factor_in_interact", -0.25, _TWEEN_DURATION)
		_crosshair_tween_in_interact.tween_property(self, ^"_crosshair_scale_factor_in_interact", 0.0, _TWEEN_DURATION)

func _on_actor_interactor_interactable_message_changed(message: StringName) -> void:
	# Dynamically updates the text when the interactable message changes.
	_label_interactable_message.text = &" - " + message

func _set_crosshair_scale_factor_in_interact(value: float) -> void:
	_crosshair_scale_factor_in_interact = value
	_update_crosshair_scale()

func _set_crosshair_scale_factor_in_focus(value: float) -> void:
	_crosshair_scale_factor_in_focus = value
	_update_crosshair_scale()

func _update_crosshair_scale() -> void:
	_crosshair.scale = Vector2.ONE * (1.0 + _crosshair_scale_factor_in_interact + _crosshair_scale_factor_in_focus)
