-- incredible-gmod.ru
-- https://github.com/Be1zebub/Love2D-Libs/blob/main/debugger.lua

--[[ Example:
local debugger = require("lib.debugger")

debugger:Add("FPS", function()
	return love.timer.getFPS()
end)
]]--

local debugger = {}
debugger.enable = false
debugger.list = {}
debugger.xoffset = 8
debugger.yoffset = 8
debugger.font = love.graphics.newFont(14)
debugger.key = "f3"

function debugger:Enable()
	self.enable = true
end

function debugger:Disable()
	self.enable = false
end

function debugger:Toggle()
	self.enable = not self.enable
end

function debugger:Add(name, get)
	self.list[name ..": "] = get
end

function debugger:Remove(name)
	self.list[name ..": "] = nil
end

local old = love.draw

function love.draw()
	if old then old() end
	if debugger.enable == false then return end

	love.graphics.setFont(debugger.font)

	local y_offset = 0

	for name, get in pairs(debugger.list) do
		local val = tostring( get() )
		local str = name .. val

		setColor(0, 0, 0, 100)
		drawRect(debugger.xoffset - 4, debugger.yoffset + y_offset - 2, debugger.font:getWidth(str) + 8, debugger.font:getHeight(str) + 4)
		
		setColor(175, 175, 175)
		love.graphics.print(name, debugger.xoffset, debugger.yoffset + y_offset)

		setColor(225, 225, 225)
		love.graphics.print(val, debugger.xoffset + debugger.font:getWidth(name), debugger.yoffset + y_offset)

		y_offset = y_offset + debugger.font:getHeight(str) + 6
	end
end


local old = love.keypressed
function love.keypressed(key)
	if old then old(key) end
	if key == debugger.key then
		debugger:Toggle()
	end
end

return debugger
