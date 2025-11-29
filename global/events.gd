extends Node

var in_game:= false 

signal save_and_quit_pressed
signal end_expedition_pressed
signal exit_to_desktop_pressed

signal settings_closed

signal is_in_game(boolean)


signal building_clicked(building_data: BuildingData)

#Events
signal choiceBuildingEvent
