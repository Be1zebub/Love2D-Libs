-- incredible-gmod.ru
-- https://github.com/Be1zebub/Love2D-Libs/blob/main/file.lua

-- file.FindRecursive & compress_type in file.Write/file.Read not tested yet ;d

local file = {}

local lfs = love.filesystem
local decode, encode = love.data.decode, love.data.encode

file.Append = lfs.append
file.CreateDir = lfs.mkdir or lfs.createDirectory
file.Delete = lfs.remove
file.Find = lfs.enumerate
file.IsDir = lfs.isDirectory
file.IsFile = lfs.isFile
file.Size = lfs.getSize
file.Time = lfs.getLastModified

local json, base64 = {json = true}, {base64 = true}

function file.Exists(path)
	return (lfs.getInfo(path)) and true or false
end

function file.Write(path, data, compress_type)
	if compress_type then
		if json[compress_type] then
			data = json.encode(data) -- https://github.com/rxi/json.lua
		elseif base64[compress_type] then
			data = encode("string", "base64", data)
		end
	end

	local f = lfs.newFile(path)
	f:open("w")
	f:write(data)
	f:close()
end

function file.Read(path, compress_type)
	if file.Exists(path) == false then return "" end

	local content = lfs.read(path)

	if compress_type then
		if json[compress_type] then
			content = json.decode(content) -- https://github.com/rxi/json.lua
		elseif base64[compress_type] then
			content = decode("string", "base64", content)
		end
	end

	return content
end

function file.FindRecursive(path, cback_or_data, return_data)
	if return_data and cback_or_data == nil then
		cback_or_data = {}
	end

	for i, name in ipairs(file.Find(path)) do
		local f_path = path .."/".. name

		if file.IsDir then
			if not return_data then
				cback_or_data(name, f_path, true)
			end

			file.FindRecursive(f_path, cback_or_data, return_data)
		elseif return_data then
			table.insert(cback_or_data, name)
		else
			cback_or_data(name, f_path, false)
		end
	end

	return return_data and cback_or_data or nil
end

function file.Rename(old, new)
	local content = ""
	
	if file.Exists(old) then
		content = file.Read(old)
	end

	file.Delete(old)
	file.Write(new, content)
end

return file
