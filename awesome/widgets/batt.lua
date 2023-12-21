local wibox = require 'wibox'
local gears = require 'gears'
function battery()
    local widget = {
        widget = wibox.widget.textbox(),
        update_interval = 10,
        update = function(self)
            local content = "test"
            self.widget:set_text(content)
        end
    }
    widget:update()
    local update_timer = gears.timer {
        timeout = widget.update_interval,
        autostart = true,
        call_now = true,
        callback = function() widget:update() end
    }
    widget.timer = update_timer
    return widget
end
