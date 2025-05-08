extends Node
class_name cc3d_registry

###############################################################################
#									 PATHS
###############################################################################

# ──────────────────────────────────────────────
# BASE
# ──────────────────────────────────────────────
var Cc3dBasePath : String = "res://cc3d/"

# ──────────────────────────────────────────────
# CORE
# ──────────────────────────────────────────────
var Cc3dCoreCodePath : String = Cc3dBasePath + "code/core/"
var Cc3dCoreAssetPath : String = Cc3dBasePath + "assets/optimized/core/"

# ──────────────────────────────────────────────
# LEVEL
# ──────────────────────────────────────────────
## To level directories
### Code
var LevelCodePath : String = Cc3dBasePath + "code/level/" # /cc3d/code/level/
### Assets
var LevelAssetPath : String = Cc3dBasePath + "assets/optimized/level/" # /cc3d/assets/optimized/level/

## To content within level directories
### Code
var LevelCodeTscnPath : String = "" # /<levelname>/<levelname>.tscn
var LevelCodeGDPath : String = "gd/" # /<levelname>/gd/
### Assets
var LevelAssetTexturePath : String = "textures/" # /<levelname>/textures/
var LevelAssetModelPath : String = "models/" # /<levelname>/models/
var LevelAssetSoundPath : String = "sounds/" # /<levelname>/sounds/

## Shared
### Assets
var SharedLevelAssetTexturePath : String = "_shared/textures/" # /<levelname>/textures/
var SharedLevelAssetModelPath : String = "_shared/models/" # /<levelname>/models/
var SharedLevelAssetSoundPath : String = "_shared/sounds/" # /<levelname>/sounds/

# ──────────────────────────────────────────────
# ENTITY
# ──────────────────────────────────────────────
## To entity directories
### Code
var EntityCodePath : String = Cc3dBasePath + "code/entity/" # /cc3d/code/entity/
### Assets
var EntityAssetPath : String = Cc3dBasePath + "assets/optimized/entity/" # /cc3d/assets/optimized/entity/

## To content within entity directories
### Code
var EntityCodeTscnPath : String = "" # /<entityname>/<entityname>.tscn
var EntityCodeGDPath : String = "gd/" # /<entityname>/gd/
### Assets
var EntityAssetTexturePath : String = "textures/" # /entityname>/textures/
var EntityAssetModelPath : String = "models/" # /<entityname>/models/
var EntityAssetSoundPath : String = "sounds/" # /<entityname>/sounds/

## Shared
### Assets
var SharedEntityAssetTexturePath : String = "_shared/textures/" # /<entityname>/textures/
var SharedEntityAssetModelPath : String = "_shared/models/" # /<entityname>/models/
var SharedEntityAssetSoundPath : String = "_shared/sounds/" # /<entityname>/sounds/

# ──────────────────────────────────────────────
# MENU
# ──────────────────────────────────────────────
## To menu directories
### Code
var MenuCodePath : String = Cc3dBasePath + "code/menu/" # /cc3d/code/menu/
### Assets
var MenuAssetPath : String = Cc3dBasePath + "assets/optimized/menu/" # /cc3d/assets/optimized/menu/

## To content within menu directories
### Code
var MenuCodeTscnPath : String = "" # /<menuname>/<menuname>.tscn
var MenuCodeGDPath : String = "gd/" # /<menuname>/gd/
### Assets
var MenuAssetTexturePath : String = "textures/" # /<menuname>/textures/
		## Disabled since menus are 2d, and dont use models
		#var MenuAssetModelPath : String = "models/" # /<menuname>/models/
var MenuAssetSoundPath : String = "sounds/" # /<menuname>/sounds/

## Shared
### Assets
var SharedMenuAssetTexturePath : String = "_shared/textures/" # /<menuname>/textures/
		## Disabled since menus are 2d, and dont use models
		#var SharedMenuAssetModelPath : String = "_shared/models/" # /<menuname>/models/
var SharedMenuAssetSoundPath : String = "_shared/sounds/" # /<menuname>/sounds/
