-- incredible-gmod.ru
-- https://github.com/Be1zebub/Love2D-Libs/blob/main/file.lua

-- file.FindRecursive not tested yet ;d

local file = {}
local lfs = love.filesystem

file.Exists = lfs.exists
file.Read = lfs.read
file.Append = lfs.append
file.CreateDir = lfs.mkdir
file.Delete = lfs.remove
file.Find = lfs.enumerate
file.IsDir = lfs.isDirectory
file.IsFile = lfs.isFile
file.Size = lfs.getSize
file.Time = lfs.getLastModified

function file.Write(path, data)
	local f = lfs.newFile(path)
	f:open("w")
	f:write(data)
	f:close()
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
