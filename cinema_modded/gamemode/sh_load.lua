--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

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

	for k, v in pairs( fileList ) do

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