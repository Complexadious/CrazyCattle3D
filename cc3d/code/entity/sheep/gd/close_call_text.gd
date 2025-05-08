extends RichTextLabel

var TypeDeclarations = [
	{ # UNSET
		random = false,
		states = [
			[
				"[color=black][tornado radius=7 freq=4]UNSET![/tornado][/color]",
				30,
				60
			]
		]
	},
	{ # CLOSE_CALL
		random = true,
		states = [
			[
				"[color=green][tornado radius=7 freq=4]close call![/tornado][/color]",
				30,
				60
			],
			[
				"[color=green][tornado radius=7 freq=4]almost sold![/tornado][/color]",
				30,
				60
			],
			[
				"[color=green][tornado radius=7 freq=4]nice recovery![/tornado][/color]",
				30,
				60
			]
		]
	},
		{ # REALLY_CLOSE_CALL
		random = true,
		states = [
			[
				"[color=blue][tornado radius=7 freq=4]damn that was close[/tornado][/color]",
				30,
				60
			],			
			[
				"[color=blue][tornado radius=7 freq=4]great save![/tornado][/color]",
				30,
				60
			],
			[
				"[color=blue][tornado radius=7 freq=4]nice recovery![/tornado][/color]",
				30,
				60
			]
		]
	},
		{ # NICE_FLIP
		random = true,
		states = [
			[
				"[color=blue][tornado radius=7 freq=4]nice flip twink![/tornado][/color]",
				30,
				60
			],
			[
				"[color=blue][tornado radius=7 freq=4]doin tricks on it[/tornado][/color]",
				30,
				60
			],			
			[
				"[color=blue][tornado radius=7 freq=4]KILL YOURSELF![/tornado][/color]",
				30,
				60
			],
			[
				"[color=blue][tornado radius=7 freq=4]good boy![/tornado][/color]",
				30,
				60
			]
		]
	},
	{ # HOW_DID_YOU_LIVE
		random = false,
		states = [
			[
				"[color=red][tornado radius=7 freq=4]how tf?![/tornado][/color]",
				30,
				60
			]
		]
	},
	{ # INSTANT
		random = true,
		states = [
			[
				"[color=red][tornado radius=7 freq=4]damn that was fast![/tornado][/color]",
				30,
				60
			],
			[
				"[color=red][tornado radius=7 freq=4]instantly folded![/tornado][/color]",
				30,
				60
			],
			[
				"[color=red][tornado radius=7 freq=4]you sold fast![/tornado][/color]",
				30,
				60
			]
		]
	},
	{ # KILL
		random = true,
		states = [
			[
				"[color=red][tornado radius=7 freq=4]nice kill 1![/tornado][/color]",
				30,
				60
			],
			[
				"[color=red][tornado radius=7 freq=4]nice kill 2![/tornado][/color]",
				30,
				60
			]
		]
	}
]
"""
[
	RANDOM (bool) - whether or not to randomly choose from states array
	TEXT (string) - text to display (w/ formatting brackets and codes)
	TRANS_TIME (int) - time (in frames, 1 sec = 60 frames) transition time between transparent and opaque, vise versa
	WAIT_TIME (int) - time (in frames) to hold fully opaque text on screen for
]
"""

var dtrans_dur = 0; # time to get to fully opaque from creation
var dtrans_wait = 0; # 60 fps

var ctrans_dur = 0; # time to get to fully opaque from creation
var ctrans_wait = 0; # 60 fps
var ctrans_curr = 0;
var ctrans_spd = 0;

var reveal_tmr = 0;
var reveal_tmr_curr = 0;

var paused = false;
var type = 0;
var queue = []

func apply_type(type: int):
	var _type = TypeDeclarations[type]
	var _sel = randi_range(0, _type.states.size() - 1) if _type.random else 0
	var _state = _type.states[_sel]
	self.text = _state[0]
	self.dtrans_dur = _state[1] # time to get to fully opaque from creation
	self.dtrans_wait = _state[2] # 60 fps
	self.reveal_tmr_curr = 0
	self.type = type
	print("APPLY_TYPE: _type: " + str(_type))
	print("APPLY_TYPE: _sel: " + str(_sel))
	print("APPLY_TYPE: _state: " + str(_state))
	reset()

func _ready():
	print("Close Call Ready Ran!")
	self_modulate.a = 0
	apply_type(0)
	
func _physics_process(delta: float) -> void:
	if (self.paused) || (self.queue.size() == 0):
		return
	
	if (self.reveal_tmr_curr > 0):
		self.reveal_tmr_curr -= 1
		return
	
	# handle shit
	if (self.ctrans_spd < 0) && (self.ctrans_wait > 0):
		self.ctrans_wait -= 1
	
	if (self.ctrans_curr > 1):
		self.ctrans_curr = 1
		self.ctrans_spd *= -1
	else:		
		self.ctrans_curr += self.ctrans_spd if (self.ctrans_curr >= 0) && ((self.ctrans_wait <= 0 && self.ctrans_spd < 0) || (self.ctrans_wait > 0 && self.ctrans_spd > 0)) else 0
	
	self_modulate.a = self.ctrans_curr
	
	if (self.ctrans_curr <= 0) && (self.ctrans_spd < 0):
		on_finish_queue_item()

func reset():
	self.ctrans_dur = self.dtrans_dur # time to get to fully opaque from creation
	self.ctrans_wait = self.dtrans_wait # 60 fps
	self.ctrans_spd = 1.0 / ctrans_dur
	self.ctrans_curr = 0
	self.reveal_tmr_curr = self.reveal_tmr
	self.type = QuickScreenText.UNSET
	
func randomize_pos():
	var xr = [0, 300]
	var yr = [60, 300]
	var npos = Vector2(randi_range(xr[0], xr[1]), randi_range(yr[0], yr[1]))
	
	set_position(npos, 1)
	
func pause():
	self.paused = true
	
func resume():
	self.paused = false	
	
func is_paused():
	return self.paused

func cancel():
	on_finish_queue_item()
	
func text_queue_add(type, reveal_timer: int = 0, other_data = null):
	self.queue.append([type, reveal_timer, other_data])
	load_first_queue_item()
	
func on_finish_queue_item():
	randomize_pos()
	self.dtrans_dur = 0
	self.dtrans_wait = 0
	reset()
	self.queue.pop_front()
	load_first_queue_item()
	
func load_first_queue_item():
	if (self.queue.size() > 0):
		var item = self.queue[0]
		apply_type(item[0])
		self.reveal_tmr = item[1]
	
func trigger(type = QuickScreenTextType.UNSET, reveal_timer: int = 45):
	text_queue_add(type, reveal_timer)
