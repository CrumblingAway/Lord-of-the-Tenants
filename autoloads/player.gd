extends Node

########## Fields. ##########

var money : int:
	get:
		return money
	set(new_money):
		money = new_money

var selected_tenant : Tenant:
	get:
		return selected_tenant
	set(new_selected_tenant):
		selected_tenant = new_selected_tenant

########## Player methods. ##########

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

