
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013, Jan Xie                         
                                                  
--]]

local helpers = require("lain.helpers")
local markup  = require("lain.util").markup
local awful   = require("awful")
local naughty = require("naughty")
local string  = { format = string.format, gsub = string.gsub }

-- Taskwarrior notification
-- lain.widget.contrib.task
local task = {}

function task.hide()
    if not task.notification then return end
    naughty.destroy(task.notification)
    task.notification = nil
end

function task.show(scr)
    task.hide()

    if task.followtag then
        task.notification_preset.screen = awful.screen.focused()
    elseif scr then
        task.notification_preset.screen = scr
    end

    helpers.async(task.show_cmd, function(f)
        task.notification = naughty.notify({
            preset = task.notification_preset,
            title  = "Tasks",
            text   = markup.font(task.notification_preset.font,
                     awful.util.escape(f:gsub("\n*$", ""))),
            destroy = function()
                task.notification = nil
            end
        })
    end)
end

function task.toggle(scr)
    if task.notification then
        task.hide()
    else
        task.show()
    end
end

function task.prompt()
    awful.prompt.run {
        prompt       = task.prompt_text,
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(t)
            helpers.async(t, function(f)
                naughty.notify {
                    preset = task.notification_preset,
                    title    = t,
                    text     = markup.font(task.notification_preset.font,
                               awful.util.escape(f:gsub("\n*$", "")))
                }
            end)
        end,
        history_path = awful.util.getdir("cache") .. "/history_task"
    }
end

function task.attach(widget, args)
    local args               = args or {}
    task.show_cmd            = args.show_cmd or "task next"
    task.prompt_text         = args.prompt_text or "Enter task command: "
    task.followtag           = args.followtag or false
    task.notification_preset = args.notification_preset

    if not task.notification_preset then
        task.notification_preset = {
            font = "Monospace 10",
            icon = helpers.icons_dir .. "/taskwarrior.png",
            icon_size = 40
        }
    end

    if widget then
        widget:connect_signal("mouse::enter", function () task.show() end)
        widget:connect_signal("mouse::leave", function () task.hide() end)
    end
end

return task
