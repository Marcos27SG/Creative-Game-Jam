extends Decision


func _execute_choice (_choice_index: int ) -> void:
	if _choice_index == 0:
		print ("first option selected hunger")
	else:
		print ("second option selected hunger")
