class_name Player extends Node

########## Signals. ##########
signal money_changed(money: int)

########## Fields. ##########

var money : int:
	get:
		return money
	set(new_money):
		money = new_money
		money_changed.emit(new_money)

var tenants : Array

########## Player methods. ##########

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

