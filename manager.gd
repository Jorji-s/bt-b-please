extends Node
@export var detainUnlocked:=false
@export var day:=1
@export var crimThough:=0
@export var validThough:=0
@export var crimAway:=0
@export var validAway:=0
@export var falseDetains:=0
@export var missedDetains:=0
@export var correctDetains:=0
@export var timeTaken:=0.0
@export var quotaRef:=0

@export var printerSpeedUpgrades:=1 #actually was supposed to be computer load upgrade

@export var printerPrintSpeed:=1

@export var totalMoney:=0


const SAVE_PATH := "user://save_game.cfg"

func _ready() -> void:
	load_game()  # auto-load on game start


func save_game() -> void:
	var cfg := ConfigFile.new()

	cfg.set_value("stats", "detainUnlocked", detainUnlocked)
	cfg.set_value("stats", "day", day)
	cfg.set_value("stats", "crimThough", crimThough)
	cfg.set_value("stats", "validThough", validThough)
	cfg.set_value("stats", "crimAway", crimAway)
	cfg.set_value("stats", "validAway", validAway)
	cfg.set_value("stats", "falseDetains", falseDetains)
	cfg.set_value("stats", "missedDetains", missedDetains)
	cfg.set_value("stats", "correctDetains", correctDetains)
	cfg.set_value("stats", "timeTaken", timeTaken)
	cfg.set_value("stats", "quotaRef", quotaRef)
	cfg.set_value("stats", "printerSpeedUpgrades", printerSpeedUpgrades)
	cfg.set_value("stats", "printerPrintSpeed", printerPrintSpeed)
	cfg.set_value("stats", "totalMoney", totalMoney)

	cfg.save(SAVE_PATH)


func load_game() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err != OK:
		print("No save file found, using defaults.")
		return

	detainUnlocked = cfg.get_value("stats", "detainUnlocked", detainUnlocked)
	day = cfg.get_value("stats", "day", day)
	crimThough = cfg.get_value("stats", "crimThough", crimThough)
	validThough = cfg.get_value("stats", "validThough", validThough)
	crimAway = cfg.get_value("stats", "crimAway", crimAway)
	validAway = cfg.get_value("stats", "validAway", validAway)
	falseDetains = cfg.get_value("stats", "falseDetains", falseDetains)
	missedDetains = cfg.get_value("stats", "missedDetains", missedDetains)
	correctDetains = cfg.get_value("stats", "correctDetains", correctDetains)
	timeTaken = cfg.get_value("stats", "timeTaken", timeTaken)
	quotaRef = cfg.get_value("stats", "quotaRef", quotaRef)
	printerSpeedUpgrades = cfg.get_value("stats", "printerSpeedUpgrades", printerSpeedUpgrades)
	printerPrintSpeed = cfg.get_value("stats", "printerPrintSpeed", printerPrintSpeed)
	totalMoney = cfg.get_value("stats", "totalMoney", totalMoney)

	print("Save loaded successfully.")
