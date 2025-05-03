class_name UILayer extends CanvasLayer

@onready var tenant_buttons : VBoxContainer = $tenant_buttons
@onready var done_button : Button = $done_button
@onready var enter_apt_creation_button : Button = $enter_apt_creation_button
@onready var exit_apt_creation_button : Button = $exit_apt_creation_button
@onready var apt_creation_button : Button = $apt_creation_button
@onready var clear_selected_tiles_button : Button = $clear_selected_tiles_button
@onready var remove_apt_button : Button = $remove_apt_button
@onready var tenant_placement_error_label : RichTextLabel = $tenant_placement_error_label
@onready var apt_stats_label : RichTextLabel = $apt_stats_label
@onready var unselect_apt_button : Button = $unselect_apt_button

func _ready() -> void:
	pass

class TenantButton extends Button:
	var tenant: Tenant
	
	func init(other_tenant: Tenant) -> TenantButton:
		tenant = other_tenant
		return self
