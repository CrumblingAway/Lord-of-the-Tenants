class_name UILayer extends CanvasLayer

@onready var tenant_buttons : VBoxContainer = $tenant_buttons
@onready var done_button : Button = $done_button
@onready var enter_apt_creation_button : Button = $enter_apt_creation_button
@onready var exit_apt_creation_button : Button = $exit_apt_creation_button
@onready var apt_creation_button : Button = $apt_creation_button
@onready var clear_selected_tiles_button : Button = $clear_selected_tiles_button
@onready var remove_apt_button : Button = $remove_apt_button
@onready var unselect_apt_button : Button = $unselect_apt_button
@onready var noise_map_button : Button = $noise_map_button
@onready var tenant_placement_error_label : RichTextLabel = $tenant_placement_error_label
@onready var apt_stats_label : RichTextLabel = $apt_stats_label
@onready var money_label : RichTextLabel = $money_label

func _ready() -> void:
	pass

func _on_player_money_changed(money: int) -> void:
	money_label.text = "Money: %d$" % money

class TenantButton extends RichTextLabel:
	var tenant: Tenant
	var button: Button
	
	func init(
		other_tenant: Tenant,
		configs: Configs
	) -> TenantButton:
		tenant = other_tenant
		
		bbcode_enabled = true
		button = Button.new()
		text = "[color=#%s]Noise Tolerance: %d[/color]\n[color=#%s]Noise Output: %d[/color]" % [
			configs.noise_input_text_color.to_html(false),
			tenant.noise_tolerance,
			configs.noise_output_text_color.to_html(false),
			tenant.noise_output
		]
		autowrap_mode = TextServer.AUTOWRAP_OFF
		fit_content = true
		
		button.set_anchors_preset(PRESET_FULL_RECT)
		
		var normal_stylebox : StyleBoxFlat = StyleBoxFlat.new()
		normal_stylebox.bg_color = Color(0, 0, 0, 0)
		button.add_theme_stylebox_override("normal", normal_stylebox)
		
		var hover_stylebox : StyleBoxFlat = StyleBoxFlat.new()
		hover_stylebox.border_color = Color(1, 1, 1, 1)
		hover_stylebox.border_width_top    = 2
		hover_stylebox.border_width_bottom = 2
		hover_stylebox.border_width_left   = 2
		hover_stylebox.border_width_right  = 2
		hover_stylebox.bg_color = Color(0, 0, 0, 0)
		button.add_theme_stylebox_override("hover", hover_stylebox)
		
		add_child(button)
		
		return self
