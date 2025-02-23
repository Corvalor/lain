
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013, Luke Bonham                     
                                                  
--]]

local helpers      = require("lain.helpers")
local markup       = require("lain.util.markup")
local awful        = require("awful")
local naughty      = require("naughty")
local mouse        = mouse
local os           = { date   = os.date }
local string       = { format = string.format,
                       gsub   = string.gsub,
		       sub = string.sub }
local ipairs       = ipairs
local tonumber     = tonumber
local setmetatable = setmetatable

-- Calendar notification
-- lain.widget.calendar
local calendar = { offset = 0 }

function calendar.hide()
    if not calendar.notification then return end
    naughty.destroy(calendar.notification)
    calendar.notification = nil
end

function calendar.show(t_out, inc_offset, scr)
    local today = os.date("%d")
    if string.sub( today, 1, 1) == "0" then
       today = string.sub( today, 2)
    end
    local offs = inc_offset or 0
    local f

    calendar.notification_preset.screen = scr or (calendar.followtag and awful.screen.focused()) or 1
    calendar.offset = calendar.offset + offs

    local current_month = (offs == 0 or calendar.offset == 0)

    if current_month then -- today highlighted
        calendar.offset = 0
        calendar.icon = string.format("%s%s.png", calendar.icons, tonumber(os.date("%d")))
        f = calendar.cal
    else -- no current month showing, no day to highlight
       local month = tonumber(os.date("%m"))
       local year  = tonumber(os.date("%Y"))

       month = month + calendar.offset

       while month > 12 do
           month = month - 12
           year = year + 1
       end

       while month < 1 do
           month = month + 12
           year = year - 1
       end

       calendar.icon = nil
       f = string.format("%s %s %s", calendar.cal, month, year)
    end

    helpers.async(f, function(ws)
        fg, bg, we = calendar.notification_preset.fg, calendar.notification_preset.bg, calendar.notification_preset.we
        ws = ws:gsub("<(%s*)%d+>", " %1"..markup.bold(markup.color(bg, fg, today)).." ")
        ws = ws:gsub("(%d%d%d%d)", "%1 ")
        ws = ws:gsub('(%d+%s%s%s)(\n)', markup.color(we, bg, '%1')..'%2')
        ws = ws:gsub('(%d+%s+%d+)(\n)', markup.color(we, bg, '%1')..'%2')
        ws = ws:gsub('(%d+)(\n)', markup.color(we, bg, '%1')..'%2')
        ws = ws:gsub("\n*$", "")
        calendar.hide()

        calendar.notification = naughty.notify({
            preset      = calendar.notification_preset,
            text        = ws,
            icon        = calendar.notify_icon,
            timeout     = t_out or calendar.notification_preset.timeout or 5
        })
    end)
end

function calendar.attach(widget)
    widget:connect_signal("mouse::enter", function () calendar.show(0) end)
    widget:connect_signal("mouse::leave", function () calendar.hide() end)
    widget:buttons(awful.util.table.join(awful.button({ }, 1, function () calendar.show(0, -1) end),
                                         awful.button({ }, 3, function () calendar.show(0,  1) end),
                                         awful.button({ }, 4, function () calendar.show(0, -1) end),
                                         awful.button({ }, 5, function () calendar.show(0,  1) end)))
end

local function factory(args)
    local args                   = args or {}
    calendar.cal                 = args.cal or "/usr/bin/ncal"
    calendar.attach_to           = args.attach_to or {}
    calendar.followtag           = args.followtag or false
    calendar.icons               = args.icons or helpers.icons_dir .. "cal/white/"
    calendar.notification_preset = args.notification_preset

    if not calendar.notification_preset then
        calendar.notification_preset = {
            font = "Monospace 10",
            fg   = "#FFFFFF",
            bg   = "#000000"
        }
    end

    for i, widget in ipairs(calendar.attach_to) do calendar.attach(widget) end
end

return setmetatable(calendar, { __call = function(_, ...) return factory(...) end })
