extends Object

const Constants = preload("res://Constants.gd");

var _constants = Constants.new();

func get_game_server_url() -> String:
	var settings_file = self._fetch_settings_file();
	var url = settings_file.get_value(
		"game_server", "url", self._constants.DEFAULT_GAME_SERVER_URL);
	return url;

func _ready():
	if not self._settings_file_exists():
		self._generate_settings_file();
	
func _settings_file_exists():
	var config = ConfigFile.new();
	var err = config.load(self._constants.SETTINGS_FILE);
	return err == OK;
	
func _generate_settings_file():
	var config = ConfigFile.new();
	config.set_value("game_server", "url", self._constants.DEFAULT_GAME_SERVER_URL);
	config.save(self._constants.SETTINGS_FILE);

func _fetch_settings_file() -> ConfigFile:
	var config = ConfigFile.new();
	config.load(self._constants.SETTINGS_FILE);
	return config;
