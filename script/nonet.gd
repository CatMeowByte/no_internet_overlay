extends Control
## Ping to internet

const API_URL = "https://gstatic.com/generate_204"
const BG_COLOR: Dictionary = {
	"red" = "#b13e53",
	"orange" = "#ef7d57",
	"yellow" = "#ffcd75",
	"gray" = "#566c86",
}

@export_group("Node", "nodepath_")
@export_node_path("CanvasItem") var nodepath_background: NodePath
@export_node_path("CanvasItem") var nodepath_foreground: NodePath
@export_node_path("Timer") var nodepath_blink: NodePath
@onready var node_background: CanvasItem = get_node(nodepath_background) as CanvasItem
@onready var node_foreground: CanvasItem = get_node(nodepath_foreground) as CanvasItem
@onready var node_blink: Timer = get_node(nodepath_blink) as Timer

var http_timeout: int = 10
var ping_delay: int = 5
var bg_color: String = "red"
var bg_alpha: float = 0.5
var fg_alpha: float = 1.0
var blink: bool = false

var is_online: bool = true
var HTTP: HTTPRequest


func _ready():
	# Create HTTP request node
	HTTP = HTTPRequest.new()
	add_child(HTTP)
	HTTP.request_completed.connect(request_completed)

	# Setup
	get_window().mouse_passthrough = true
	modulate.a = 0.0

	# Get
	var arguments: Dictionary = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			arguments[argument.lstrip("--")] = ""

	# Update
	if arguments.has("info"):
		print_info(true)
		await get_tree().process_frame
		get_tree().quit()
	else:
		print_info(false)
	if arguments.has("timeout"):
		http_timeout = int(arguments["timeout"])
	if arguments.has("refresh"):
		ping_delay = int(arguments["refresh"])
	if arguments.has("bg-color"):
		if BG_COLOR.has(arguments["bg-color"]):
			bg_color = arguments["bg-color"]
	if arguments.has("bg-alpha"):
		bg_alpha = float(arguments["bg-alpha"])
		# Safety measure to never fully cover user view
		bg_alpha = clampf(bg_alpha, 0.0, 0.875)
	if arguments.has("fg-alpha"):
		fg_alpha = float(arguments["fg-alpha"])
	if arguments.has("blink"):
		blink = true

	# Set
	HTTP.set_timeout(http_timeout)
	node_background.modulate = Color(BG_COLOR[bg_color])
	node_background.modulate.a = bg_alpha
	node_foreground.modulate.a = fg_alpha

	# Ping
	ping()


func ping():
	var request = HTTP.request(API_URL)
	if not request == OK:
		printerr("An error occurred in the ping HTTP request.")
		get_tree().quit(1)


func print_info(verbose: bool = false):
	print("\"No Internet\" Overlay - ", ProjectSettings.get_setting("application/config/version"))
	print("by CatMeowByte (catmeowbyte@gmail.com)")

	if not verbose:
		print()
		print("Use \"--info\" for more information.")
		return

	print()
	print("DESCRIPTION:")
	print("  cover the screen with a prominent graphic popup indicating that the computer is not connected to the internet.")
	print()
	print("USAGE:")
	print("  no_internet_overlay [OPTIONS]")
	print()
	print("OPTIONS:")
	print("  --info")
	print("    Display this information message and exit.")
	print()
	print("  --timeout=<seconds>")
	print("    Set the HTTP request timeout in seconds.")
	print("    Default: ", str(http_timeout))
	print()
	print("  --refresh=<seconds>")
	print("    Set the interval between ping attempts in seconds.")
	print("    Default: ", str(ping_delay))
	print()
	print("  --bg-color=<color>")
	print("    Set the background color of the overlay. Available options: \"red\", \"orange\", \"yellow\", and \"gray\".")
	print("    Default: ", bg_color)
	print()
	print("  --bg-alpha=<value>")
	print("    Set the background opacity. Range: 0.0 to 0.875")
	print("    Default: ", str(bg_alpha))
	print()
	print("  --fg-alpha=<value>")
	print("    Set the graphic opacity. Range: 0.0 to 1.0")
	print("    Default: ", str(fg_alpha))
	print()
	print("  --blink")
	print("    Enable the graphic to blink.")
	print()
	print("EXAMPLES:")
	print("  no_internet_overlay --timeout=15 --refresh=30 --bg-color=yellow --bg-alpha=0.5 --fg-alpha=0.8 --blink")
	print()
	print("LICENSE:")
	print("  This program is licensed under the GPLv3+ License.")


func request_completed(result, _response_code, _headers, _body):
	is_online = false
	if not result == HTTPRequest.RESULT_SUCCESS:
		is_online = true
		if blink:
			node_blink.start()
		printerr("Not connected to internet.")

	# Fade
	get_tree().create_tween().tween_property(self, "modulate:a", float(is_online), 0.5)

	# Ping again
	await get_tree().create_timer(ping_delay).timeout
	ping()


func blinked():
	node_foreground.visible = not node_foreground.visible
