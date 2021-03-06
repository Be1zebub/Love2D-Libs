-- incredible-gmod.ru
-- https://github.com/Be1zebub/Love2D-Libs/blob/main/cvar.lua

--!!! https://github.com/Be1zebub/Love2D-Libs/blob/main/file.lua REQUIRED !!!

-- not tested yet ;d

local encode = love.data.encode

file.CreateDir("cvar")

local value = {_value = true}

local meta = {}
meta.__index = meta

function meta:__newindex(k, v)
	if value[k] then
		if self.validate then
			local new = self.validate(v)
			if new == false then return end
			v = new
		end

		file.Write("cvar/".. self.id ..".dat", v, "base64")
		return rawset(self, "value", v)
	end

	return rawset(self, k, v)
end

function meta:Get()
	return self.value
end

function meta:Set(val)
	self._value = val
end

local str_true = {["1"] = true}

function meta:GetBool()
	if str_true[self.value] then return true end
	return false
end

function meta:SetBool(bool)
	self:Set(bool and "1" or "0")
end

local cvar = setmetatable({
	list = {},
	meta = meta
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
		local id = encode("string", "hex", name)
		local path = "cvar/".. id ..".dat"

		if file.Exists(path) then
			default_value = file.Read(path, "base64")
		elseif default_value == nil then
			default_value = "0"
		end

		self.list[name] = setmetatable({
			name = name,
			id 	= id,
			validate = validate,
			value = default_value
		}, meta)
	end

	return self.list[name]
end

function cvar:Get(name)
	return (cvar:GetTable(name) or {}).value
end

function cvar:Set(name, value)
	(cvar:GetTable(name) or {})._value = value
end

function cvar.ValidateBool(v)
    v = tonumber(v)
    if v == nil then return false end
    if v > 1 then v = 1 end
    if v < 0 then v = 0 end
    return tostring(v)
end

return cvar
