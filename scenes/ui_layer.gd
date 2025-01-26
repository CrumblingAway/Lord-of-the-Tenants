class_name UILayer extends CanvasLayer

@onready var tenant_buttons : VBoxContainer = $tenant_buttons

func _ready() -> void:
	pass

class TenantButton extends Button:
	var tenant: Tenant
	
	func init(other_tenant: Tenant) -> TenantButton:
		tenant = other_tenant
		return self
