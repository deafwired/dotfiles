-- $$$$$$$\                       $$$$$$\  $$\      $$\ $$\                           $$\ 
-- $$  __$$\                     $$  __$$\ $$ | $\  $$ |\__|                          $$ |
-- $$ |  $$ | $$$$$$\   $$$$$$\  $$ /  \__|$$ |$$$\ $$ |$$\  $$$$$$\   $$$$$$\   $$$$$$$ |
-- $$ |  $$ |$$  __$$\  \____$$\ $$$$\     $$ $$ $$\$$ |$$ |$$  __$$\ $$  __$$\ $$  __$$ |
-- $$ |  $$ |$$$$$$$$ | $$$$$$$ |$$  _|    $$$$  _$$$$ |$$ |$$ |  \__|$$$$$$$$ |$$ /  $$ |
-- $$ |  $$ |$$   ____|$$  __$$ |$$ |      $$$  / \$$$ |$$ |$$ |      $$   ____|$$ |  $$ |
-- $$$$$$$  |\$$$$$$$\ \$$$$$$$ |$$ |      $$  /   \$$ |$$ |$$ |      \$$$$$$$\ \$$$$$$$ |
-- \_______/  \_______| \_______|\__|      \__/     \__|\__|\__|       \_______| \_______|

-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme
local beautiful = require'beautiful'
local gears = require'gears'
local awful = require'awful'

-- defualt path = gears.filesystem.get_themes_dir()
beautiful.init("~/.config/awesome/themes/" .. 'default/theme.lua')

-- load key and mouse bindings
require'bindings'

-- load rules
require'rules'

-- load signals
require'signals'

-- load picom
awful.spawn.with_shell("~/.config/awesome/autorun.sh")