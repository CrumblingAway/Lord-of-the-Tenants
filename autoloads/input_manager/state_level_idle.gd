class_name StateLevelIdle extends State

var building_floor : BuildingFloor:
	get:
		return building_floor
	set(new_building_floor):
		building_floor = new_building_floor

########## StateLevelIdle methods. ##########

func init(other_building_floor: BuildingFloor) -> StateLevelIdle:
	building_floor = other_building_floor
	
	return self

########## State methods. ##########

func enter() -> void:
	pass

func exit() -> void:
	pass

func process() -> void:
	pass


