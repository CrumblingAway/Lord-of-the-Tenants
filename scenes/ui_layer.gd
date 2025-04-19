class_name UILayer extends CanvasLayer

@onready var tenant_buttons : VBoxContainer = $tenant_buttons
@onready var done_button : Button = $done_button
@onready var transition_to_apt_creation_button : Button = $transition_to_apt_creation_button
@onready var apt_creation_button : Button = $apt_creation_button
@onready var clear_selected_tiles_button : Button = $clear_selected_tiles_button
@onready var remove_apt_button : Button = $remove_apt_button

func _ready() -> void:
	pass

class TenantButton extends Button:
	var tenant: Tenant
	
	func init(other_tenant: Tenant) -> TenantButton:
		tenant = other_tenant
		return self
