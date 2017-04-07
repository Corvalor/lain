
--[[
                                                   
     Licensed under GNU General Public License v2  
      * (c) 2015, Luke Bonham                      
      * (c) 2015, plotnikovanton                   
                                                   
--]]

local wibox     = require("wibox")
local gears     = require("gears")

-- Lain Cairo separators util submodule
-- lain.util.separators
local separators = { height = 0, width = 9 }

-- [[ Arrow

-- Right
function separators.arrow_right(col1, col2, fill)
    local widget = wibox.widget.base.make_widget()

    widget.fit = function(m, w, h)
        return separators.width, separators.height
    end

    widget.draw = function(mycross, wibox, cr, width, height)
	local col = nil
	if col2 ~= "alpha" then
	    cr:set_source(gears.color(col2))
            cr:new_path()
            cr:move_to(0, 0)
            cr:line_to(width, height/2)
            cr:line_to(width, 0)
	    if not fill then
	       cr:move_to( 0, 0)
	    end
            cr:close_path()
	    if fill then
	       cr:fill()
	    else
	       cr:stroke()
	    end

            cr:new_path()
            cr:move_to(0, height)
            cr:line_to(width, height/2)
            cr:line_to(width, height)
            cr:close_path()
            cr:fill()
	    col = col2
        end

        if col1 ~= "alpha" then
	    cr:set_source(gears.color(col1))
            cr:new_path()
            cr:move_to(0, 0)
            cr:line_to(width, height/2)
            cr:line_to(0, height)
	    if not fill then
	       cr:move_to( 0, 0)
	    end
            cr:close_path()
	    if fill then
	       cr:fill()
	    else
	       cr:stroke()
	    end
	    col = col1
        end
	if col and fill then
	    cr:set_source(gears.color(col))
            cr:new_path()

            cr:move_to(0, 0)
            cr:line_to(width, height/2)
            cr:line_to(0, height)
	    cr:move_to( 0, 0)

            cr:close_path()
	    cr:stroke()
	end
   end

   return widget
end

-- Left
function separators.arrow_left(col1, col2, fill)
    local widget = wibox.widget.base.make_widget()

    widget.fit = function(m, w, h)
        return separators.width, separators.height
    end

    widget.draw = function(mycross, wibox, cr, width, height)
	local col = nil
        if col1 ~= "alpha" then
	    cr:set_source(gears.color(col1))
            cr:new_path()
	    if fill then
		cr:move_to(0, 0)
	    end
            cr:line_to(width, 0)
            cr:line_to(0, height/2)
            cr:line_to(width, height)
	    if fill then
		cr:line_to(0, height)
	    else
		cr:move_to(width, 0)
	    end
            cr:close_path()
	    if fill then
	       cr:fill()
	    else
	       cr:stroke()
	    end
	    col = col
        end

        if col2 ~= "alpha" then
	    cr:set_source(gears.color(col2))
            cr:new_path()
            cr:move_to(width, 0)
            cr:line_to(0, height/2)
            cr:line_to(width, height)
	    if not fill then
		cr:move_to(width, 0)
	    end
            cr:close_path()

	    if fill then
	       cr:fill()
	    else
	       cr:stroke()
	    end
	    col = col2
        end

	if col and fill then
	    cr:set_source(gears.color(col))
            cr:new_path()

            cr:move_to(width, 0)
            cr:line_to(0, height/2)
            cr:line_to(width, height)
	    cr:move_to(width, 0)

            cr:close_path()
	    cr:stroke()
	end
   end

   return widget
end

-- ]]

return separators
