extends Panel

func _ready():
	pass
	
func setSelectionToIndex(index):
	$Grid/SelectionSquare.position = $Grid.get_child(index).get_rect().position
