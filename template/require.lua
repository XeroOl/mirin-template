local options = assert(loadfile(xero.dir .. 'template/mirin/options.lua'))()
package = {
	-- mirin template loader path
	path = table.concat(options.package_path, ';'),
	preload = {},
	loaded = { ['mirin.options'] = options },
	loaders = {
		function(modname)
			local preload = package.preload[modname]
			return preload or "no field xero.package.preload['" .. modname .. "']"
		end,
		function(modname)
			local errors = {}
			-- get the filename
			local filename = string.gsub(modname, '%.', '/')
			for path in (string.gfind or string.gmatch)(package.path, '[^;]+') do
				-- get the file path
				local filepath = xero.dir .. string.gsub(path, '%?', filename)
				-- check if file exists
				if not GAMESTATE:GetFileStructure(filepath) then
					table.insert(errors, "no file '" .. filepath .. "'")
				else
					local loader, err = loadfile(filepath)
					-- check if file loads properly
					if err then
						error(err, 3)
					elseif loader then
						return xero(loader)
					end
				end
			end
			return table.concat(errors, '\n')
		end,
	},
}

function require(modname)
	if not package.loaded[modname] then
		local errors = { "module '" .. modname .. "' not found:" }
		local chunk
		for _, loader in ipairs(xero.package.loaders) do
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
		package.preload[modname] = chunk
		package.loaded[modname] = chunk()
		if package.loaded[modname] == nil then
			package.loaded[modname] = true
		end
	end
	return package.loaded[modname]
end

-- current module has been loaded
package.loaded.require = require
return require