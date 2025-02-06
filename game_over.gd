extends Control

func _on_play_again_button_pressed() -> void:
	var tree = get_tree()
	tree.paused = false
	tree.reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
