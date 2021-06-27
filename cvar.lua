-- incredible-gmod.ru
-- https://github.com/Be1zebub/Love2D-Libs/blob/main/cvar.lua

--!!! https://github.com/Be1zebub/Love2D-Libs/blob/main/file.lua REQUIRED !!!

-- not tested yet ;d

local decompress, compress = love.data.decompress, love.data.compress

file.CreateDir("cvar")

local value = {value = true}
local meta = {}

function meta:__newindex(k, v)
	if value[k] then
		if self.validate then
			local new = self.validate(v)
			if new == false then return end
			v = new
		end

		file.Write("cvar/".. self.id ..".dat", v, "compress")
	end

	return rawset(self, k, v)
end

function meta:Get()
	return self.value
end

function meta:Set(value)
	self.value = value
end

local str_true, str_false = {["1"] = true}, {["0"] = false}

function meta:GetBool()
	if str_true[self.value] then return true end
	if str_false[self.value] then return false end

	return nil
end

function meta:SetBool(bool)
	self:Set(bool and "1" or "0")
end

local cvar = setmetatable({
	list = {}
}, {
	__call = function(self, ...)
		return self:Register(...)
	end
})

function cvar:GetTable(name)
	if name then
		return self.list[name]
	end

	return self.list
end

function cvar:Register(name, default_value, validate)
	if self.list[name] == nil then
		local id = compress("string", "lz4", name)
		local path = "cvar/".. id ..".dat"

		if file.Exists(path) then
			default_value = file.Read(path, "compress")
		elseif default_value == nil then
			default_value = "0"
		end

		self.list[name] = setmetatable({
			name = name,
			id 	= id,
			validate = validate,
			value = value
		}, meta)
	end

	return self.list[name]
end

function cvar:Get(name)
	return (cvar:GetTable(name) or {}).value
end

function cvar:Set(name, value)
	(cvar:GetTable(name) or {}).value = value
end

return cvar
