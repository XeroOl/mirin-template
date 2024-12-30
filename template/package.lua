local package = {}

-- mirin template loader path
package.path = 'lua/?.lua;lua/?/init.lua;plugins/?.lua;plugins/?/init.lua'
package.preload = {}
package.loaded = {}
package.loaders = {
	function(modname)
		return package.preload[modname] or "no field xero.package.preload['" .. modname .. "']"
	end,
	function(modname)
		local errors = {}
		-- get the filename
		local filename = string.gsub(modname, '%.', '/')
		for path in (string.gfind or string.gmatch)(package.path, '[^;]+') do
			-- get the file path
			package.songdir = package.songdir or GAMESTATE:GetCurrentSong():GetSongDir()
			local filepath = package.songdir .. string.gsub(path, '%?', filename)
			-- check if file exists
			if not GAMESTATE:GetFileStructure(filepath) then
				table.insert(errors, "no file '" .. filepath .. "'")
			else
				local loader, err = loadfile(filepath)
				-- check if file loads properly
				if err then
					error(err, 3)
				elseif loader then
					-- apply the environment
					return xero(loader)
				end
			end
		end
		return table.concat(errors, '\n')
	end,
}
function package.require(modname)
	local loaded = package.loaded
	if not loaded[modname] then
		local errors = { "module '" .. modname .. "' not found:" }
		local chunk
		for _, loader in ipairs(package.loaders) do
			local result = loader(modname)
			if type(result) == 'string' then
				table.insert(errors, result)
			elseif type(result) == 'function' then
				chunk = result
				break
			end
		end
		if not chunk then
			error(table.concat(errors, '\n'), 2)
		end
		loaded[modname] = chunk()
		if loaded[modname] == nil then
			loaded[modname] = true
		end
	end
	return loaded[modname]
end

return package
