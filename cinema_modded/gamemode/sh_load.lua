module( "Loader", package.seeall )

BaseGamemode = GM.FolderName

local function GetFileList( strDirectory, strGamemode )

	local files = {}

	local realDirectory = strGamemode .. "/gamemode/" .. strDirectory .. "/*"
	local findFiles, findFolders = file.Find( realDirectory, "LUA" )

	for k, v in pairs( table.Add(findFiles, findFolders) ) do

		if ( v == "." or v == ".." or v == ".svn" ) then continue end

		table.insert( files, v )

	end

	return files

end

local function IsLuaFile( strFile )
	return string.sub( strFile, -4 ) == ".lua"
end

local function IsDirectory( strDir )
	return string.GetExtensionFromFilename( strDir ) == nil
end

local function LoadFile( strDirectory, strGamemode, strFile )

	local prefix = string.sub( strFile, 0, 3 )
	local realFile = strGamemode .. "/gamemode/" .. strDirectory .. "/" .. strFile

	if ( prefix == "cl_" ) then

		if SERVER then
			AddCSLuaFile( realFile )
		else
			include( realFile )
		end

	elseif ( prefix == "sh_" ) then

		if SERVER then
			AddCSLuaFile( realFile )
		end

		include( realFile )

	elseif ( prefix == "sv_" or strFile == "init.lua" ) then

		if SERVER then
			include( realFile )
		end

	end

end

function Load( strDirectory, strGamemode )

	if ( not strGamemode ) then
		strGamemode = BaseGamemode
	end

	local fileList = GetFileList( strDirectory, strGamemode )

	-- Shared service setup must run before client/server extensions.
	local function LoadPriority( name )
		-- Entry points must run before the rest of their realm's files.
		if name == "sh_init.lua" then return 1 end
		if string.sub( name, 1, 3 ) == "sh_" then return 2 end
		if name == "cl_init.lua" then return 3 end
		if string.sub( name, 1, 3 ) == "cl_" then return 4 end
		if name == "sv_init.lua" then return 5 end
		if string.sub( name, 1, 3 ) == "sv_" then return 6 end
		return 4
	end

	table.sort( fileList, function( a, b )
		local priorityA = LoadPriority( a )
		local priorityB = LoadPriority( b )
		if priorityA == priorityB then return a < b end
		return priorityA < priorityB
	end )

	for k, v in ipairs( fileList ) do

		if ( IsLuaFile( v ) ) then

			LoadFile( strDirectory, strGamemode, v )

		else

			local strNextDir = strDirectory .. "/" .. v

			if IsDirectory( strNextDir ) then
				Load( strNextDir, strGamemode ) // go deeper. BWOOOOOONG!!
			end

		end
	end

end