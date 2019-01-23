extends Panel

var dialogueAsset
var data
var lastBttnPos = 0
var buttonFired = false
var timer = 0

func _process(delta):
	timer += delta
	for i in range(0, get_node("Buttons").get_child_count()):
		if get_node('Buttons').get_child(i).pressed and !buttonFired and timer >= 0.5:
				_next(get_node('Buttons').get_child(i).name)
				buttonFired = true
	if(buttonFired):
		timer = 0
		buttonFired = false

func _populate():
	if(data):
		var firstNode = data[data['Start']['connects_to'][1]]
		get_node("Text").parse_bbcode(firstNode['text'])
		# lets set our buttons
		var firstButtons = firstNode['connects_to'].size()
		for i in range(1, firstButtons+1):
			_addButton(data[firstNode['connects_to'][i]]['text'], firstNode['connects_to'][i])

func _next(name): # Its for a church honey!
	var button = data[name]
	for i in range(1, button['connects_to'].size()+1):
		if('Dialogue' in button['connects_to'][i]):
			#lets clear our buttons
			_clearButtons()
			# lets load that Dialogue node!
			get_node("Text").parse_bbcode(data[button['connects_to'][i]]['text'])
			# lets load everything we're connecting to!
			var connectedTo = data[button['connects_to'][i]]['connects_to']
			for x in range(1, connectedTo.size()+1):
				if('Option' in connectedTo[i]):
					_addButton(data[connectedTo[i]]['text'], connectedTo[i])

func _addButton(text, bttnName):
	var node = Button.new()
	var template = get_node("Template")
	node.rect_size = template.rect_size
	node.rect_position = Vector2(template.rect_position.x, template.rect_position.y + lastBttnPos)
	node.set_text(text)
	self.get_node("Buttons").add_child(node)
	node.show()
	node.set_name(bttnName)
	lastBttnPos -= 35#? Yes, yes. I've thought it over quite thoroughly

func _reset():
	data = 0
	buttonFired = false
	lastBttnPos = 0
	_clearButtons()
	EditorSingleton._update_demo()

func _clearButtons():
	lastBttnPos = 0
	for child in get_node("Buttons").get_children():
		child.queue_free()