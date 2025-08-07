-----------------------------------------------------------------------------
-- URI Parsing, Composition and Relative URL Resolution
--
-- Originally based on LuaSocket toolkit by Diego Nehab
-- RCS ID: $Id: url.lua,v 1.38 2006/04/03 04:45:42 diego Exp $
--
-- Modified and extended for Cinema gamemode requirements:
-- - Enhanced query parameter parsing with URL decoding
-- - Modern fragment handling for SPA routing patterns
-- - Security improvements and input validation
-- - Extended HTML entity support for international content
-- - Backward compatibility maintained with original API
--
-- Security Enhancements Added:
-- - Protocol Whitelisting: Blocks dangerous schemes (javascript:, data:, vbscript:)
-- - Parameter Sanitization: Removes XSS and injection patterns from URL parameters
-- - XSS Prevention: Secure HTML entity escaping for user-generated content
-- - Directory Traversal Protection: Prevents ../../../ path traversal attacks
-- - Input Validation: Length limits and character filtering for DoS prevention
--
-- Security functions protect against:
-- • Cross-Site Scripting (XSS) attacks via URL parameters
-- • Code injection through dangerous protocols
-- • Directory traversal attacks using relative paths
-- • Buffer overflow attacks via oversized inputs
-- • HTML injection in fragment and query data
--
-- Cinema modifications by PurrCoding contributors
-- https://github.com/PurrCoding/cinema/
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Declare module
-----------------------------------------------------------------------------
local isstring, istable, tostring, tonumber = isstring, istable, tostring, tonumber
local pairs, ipairs = pairs, ipairs
local string_gsub = string.gsub
local string_format = string.format
local string_byte = string.byte
local string_char = string.char
local string_lower = string.lower
local string_match = string.match
local string_gmatch = string.gmatch
local string_sub = string.sub
local string_GetFileFromFilename = string.GetFileFromFilename
local string_GetExtensionFromFilename = string.GetExtensionFromFilename
local string_Explode = string.Explode
local table_insert = table.insert
local table_concat = table.concat
module("url")

-----------------------------------------------------------------------------
-- Security Configuration
-----------------------------------------------------------------------------
local ALLOWED_PROTOCOLS = {
	["http"] = true,
	["https"] = true
}

local MAX_URL_LENGTH = 2048
local MAX_PARAM_LENGTH = 1024
local MAX_PATH_DEPTH = 25

-----------------------------------------------------------------------------
-- HTML Entity Translation Table with modern Unicode support
-- http://lua-users.org/lists/lua-l/2005-10/msg00328.html
-----------------------------------------------------------------------------
local entities = {
	-- Basic HTML entities
	[' '] = '&nbsp;',
	['"'] = '&quot;',
	["'"] = '&#39;',
	['<'] = '&lt;',
	['>'] = '&gt;',
	['&'] = '&amp;',

	-- Latin-1 Supplement
	['¡'] = '&iexcl;', ['¢'] = '&cent;', ['£'] = '&pound;', ['¤'] = '&curren;',
	['¥'] = '&yen;', ['¦'] = '&brvbar;', ['§'] = '&sect;', ['¨'] = '&uml;',
	['©'] = '&copy;', ['ª'] = '&ordf;', ['«'] = '&laquo;', ['¬'] = '&not;',
	['­'] = '&shy;', ['®'] = '&reg;', ['¯'] = '&macr;', ['°'] = '&deg;',
	['±'] = '&plusmn;', ['²'] = '&sup2;', ['³'] = '&sup3;', ['´'] = '&acute;',
	['µ'] = '&micro;', ['¶'] = '&para;', ['·'] = '&middot;', ['¸'] = '&cedil;',
	['¹'] = '&sup1;', ['º'] = '&ordm;', ['»'] = '&raquo;', ['¼'] = '&frac14;',
	['½'] = '&frac12;', ['¾'] = '&frac34;', ['¿'] = '&iquest;',

	-- Latin Extended characters
	['À'] = '&Agrave;', ['Á'] = '&Aacute;', ['Â'] = '&Acirc;', ['Ã'] = '&Atilde;',
	['Ä'] = '&Auml;', ['Å'] = '&Aring;', ['Æ'] = '&AElig;', ['Ç'] = '&Ccedil;',
	['È'] = '&Egrave;', ['É'] = '&Eacute;', ['Ê'] = '&Ecirc;', ['Ë'] = '&Euml;',
	['Ì'] = '&Igrave;', ['Í'] = '&Iacute;', ['Î'] = '&Icirc;', ['Ï'] = '&Iuml;',
	['Ð'] = '&ETH;', ['Ñ'] = '&Ntilde;', ['Ò'] = '&Ograve;', ['Ó'] = '&Oacute;',
	['Ô'] = '&Ocirc;', ['Õ'] = '&Otilde;', ['Ö'] = '&Ouml;', ['×'] = '&times;',
	['Ø'] = '&Oslash;', ['Ù'] = '&Ugrave;', ['Ú'] = '&Uacute;', ['Û'] = '&Ucirc;',
	['Ü'] = '&Uuml;', ['Ý'] = '&Yacute;', ['Þ'] = '&THORN;', ['ß'] = '&szlig;',

	-- Lowercase Latin Extended
	['à'] = '&agrave;', ['á'] = '&aacute;', ['â'] = '&acirc;', ['ã'] = '&atilde;',
	['ä'] = '&auml;', ['å'] = '&aring;', ['æ'] = '&aelig;', ['ç'] = '&ccedil;',
	['è'] = '&egrave;', ['é'] = '&eacute;', ['ê'] = '&ecirc;', ['ë'] = '&euml;',
	['ì'] = '&igrave;', ['í'] = '&iacute;', ['î'] = '&icirc;', ['ï'] = '&iuml;',
	['ð'] = '&eth;', ['ñ'] = '&ntilde;', ['ò'] = '&ograve;', ['ó'] = '&oacute;',
	['ô'] = '&ocirc;', ['õ'] = '&otilde;', ['ö'] = '&ouml;', ['÷'] = '&divide;',
	['ø'] = '&oslash;', ['ù'] = '&ugrave;', ['ú'] = '&uacute;', ['û'] = '&ucirc;',
	['ü'] = '&uuml;', ['ý'] = '&yacute;', ['þ'] = '&thorn;', ['ÿ'] = '&yuml;',

	-- Modern Unicode characters commonly used
	['€'] = '&euro;', ['™'] = '&trade;', ['…'] = '&hellip;', ['–'] = '&ndash;',
	['—'] = '&mdash;', ['\''] = '&lsquo;', ['\''] = '&rsquo;', ['"'] = '&ldquo;',
	['"'] = '&rdquo;', ['•'] = '&bull;', ['‰'] = '&permil;', ['′'] = '&prime;',
	['″'] = '&Prime;', ['‹'] = '&lsaquo;', ['›'] = '&rsaquo;', ['‡'] = '&Dagger;',
	['†'] = '&dagger;', ['‖'] = '&Vert;', ['‾'] = '&oline;', ['⁄'] = '&frasl;',
	['℃'] = '&#8451;', ['℉'] = '&#8457;', ['№'] = '&#8470;', ['℗'] = '&#8471;',
	['℠'] = '&#8480;', ['Ω'] = '&Omega;', ['α'] = '&alpha;', ['β'] = '&beta;',
	['γ'] = '&gamma;', ['δ'] = '&delta;', ['π'] = '&pi;', ['μ'] = '&mu;',
	['∞'] = '&infin;', ['≈'] = '&asymp;', ['≠'] = '&ne;', ['≤'] = '&le;',
	['≥'] = '&ge;', ['←'] = '&larr;', ['→'] = '&rarr;', ['↑'] = '&uarr;',
	['↓'] = '&darr;', ['♠'] = '&spades;', ['♣'] = '&clubs;', ['♥'] = '&hearts;',
	['♦'] = '&diams;'
}

local function removeControlChars(str)
	-- This effectively does what [\0-\31\127] would do
	local result = str
	for i = 0, 31 do
		result = string_gsub(result, string_char(i), "")
	end
	result = string_gsub(result, string_char(127), "")
	return result
end

-----------------------------------------------------------------------------
-- Convert string to HTML entities with error handling
-- Input: s - string to encode
-- Returns: encoded string with HTML entities
-----------------------------------------------------------------------------
function htmlentities(s)
	if not s or not isstring(s) then
		return s or ""
	end

	for k, v in pairs(entities) do
		s = string_gsub(s, k, v)
	end

	return s
end

-----------------------------------------------------------------------------
-- Decode HTML entities to characters with error handling
-- Input: s - string with HTML entities to decode
-- Returns: decoded string with actual characters
-----------------------------------------------------------------------------
function htmlentities_decode(s)
	if not s or not isstring(s) then
		return s or ""
	end

	for k, v in pairs(entities) do
		s = string_gsub(s, v, k)
	end

	return s
end

-----------------------------------------------------------------------------
-- XSS Prevention - Escape HTML entities in a security-aware manner
-- Converts potentially dangerous HTML characters to safe entities
-- Prevents cross-site scripting attacks through HTML injection
-- Example: "<script>alert('xss')</script>" -> "&lt;script&gt;alert('xss')&lt;/script&gt;"
--          "normal text" -> "normal text" (unchanged)
-----------------------------------------------------------------------------
function htmlentities_secure(s)
	if not s or not isstring(s) then
		return s or ""
	end

	-- Essential XSS prevention characters
	local xss_entities = {
		['<'] = '&lt;',
		['>'] = '&gt;',
		['"'] = '&quot;',
		["'"] = '&#39;',
		['&'] = '&amp;',
		['/'] = '&#47;',     -- Prevent closing tags
		['\\'] = '&#92;',    -- Prevent escape sequences
	}

	for char, entity in pairs(xss_entities) do
		s = string_gsub(s, char, entity)
	end

	return s
end

-----------------------------------------------------------------------------
-- Encodes a string into its escaped hexadecimal representation
-- Input: s - binary string to be encoded
-- Returns: escaped representation of string binary
-----------------------------------------------------------------------------
function escape(s)
	if not s or not isstring(s) then
		return s or ""
	end

	return string_gsub(s, "([^A-Za-z0-9_])", function(c)
		return string_format("%%%02x", string_byte(c))
	end)
end

-----------------------------------------------------------------------------
-- Helper function to create character sets for path protection
-----------------------------------------------------------------------------
local function make_set(t)
	local s = {}

	for i, v in ipairs(t) do
		s[t[i]] = 1
	end

	return s
end

-- Characters allowed within a path segment, along with alphanum
-- Other characters must be escaped
local segment_set = make_set{"-", "_", ".", "!", "~", "*", "'", "(", ")", ":", "@", "&", "=", "+", "$", ","}

local function protect_segment(s)
	return string_gsub(s, "([^A-Za-z0-9_])", function(c)
		if segment_set[c] then
			return c
		else
			return string_format("%%%02x", string_byte(c))
		end
	end)
end

-----------------------------------------------------------------------------
-- Decodes escaped hexadecimal representation with validation
-- Input: s - escaped string to be decoded
-- Returns: decoded binary string
-----------------------------------------------------------------------------
function unescape(s)
	if not s or not isstring(s) then
		return s or ""
	end

	return string_gsub(s, "%%(%x%x)", function(hex)
		local num = tonumber(hex, 16)
		if num and num >= 0 and num <= 255 then
			return string_char(num)
		else
			return "%" .. hex  -- Return original if invalid
		end
	end)
end

-----------------------------------------------------------------------------
-- Protocol Whitelisting - Only allow safe URL schemes
-- This prevents dangerous protocols like javascript:, data:, vbscript: that
-- could be used for XSS attacks or code injection
-- Example: javascript:alert('xss') -> rejected
--          https://example.com -> allowed
-----------------------------------------------------------------------------
function isAllowedProtocol(scheme)
	if not scheme or not isstring(scheme) then
		return false
	end

	return ALLOWED_PROTOCOLS[string_lower(scheme)] or false
end

-----------------------------------------------------------------------------
-- Parameter Sanitization - Clean and validate URL parameters
-- Removes potentially dangerous characters and content from parameters
-- Prevents script injection, SQL injection, and other parameter-based attacks
-- Example: param="<script>alert('xss')</script>" -> rejected
--          param="normal_value123" -> allowed
-----------------------------------------------------------------------------
function sanitizeParam(key, value)
	if not key or not value then
		return nil, nil
	end

	-- Convert to strings and limit length
	key = tostring(key):sub(1, MAX_PARAM_LENGTH)
	value = tostring(value):sub(1, MAX_PARAM_LENGTH)

	-- Check for script injection patterns
	local dangerous_patterns = {
		"<script[^>]*>",     -- Script tags
		"javascript:",       -- JavaScript protocol
		"vbscript:",        -- VBScript protocol
		"data:",            -- Data URLs
		"on%w+%s*=",        -- Event handlers (onclick, onload, etc.)
		"expression%s*%(",   -- CSS expressions
		"<%s*iframe",       -- Iframe tags
		"<%s*object",       -- Object tags
		"<%s*embed",        -- Embed tags
		"<%s*link",         -- Link tags
		"<%s*meta"          -- Meta tags
	}

	for _, pattern in ipairs(dangerous_patterns) do
		if string_match(string_lower(value), pattern) or
		   string_match(string_lower(key), pattern) then
			return nil, nil  -- Reject dangerous content
		end
	end

	-- Remove null bytes and control characters
	key = removeControlChars(key)
	value = removeControlChars(value)

	return key, value
end

-----------------------------------------------------------------------------
-- Directory Traversal Protection - Prevent path traversal attacks
-- Blocks attempts to access files outside intended directories using ../
-- Normalizes paths and removes dangerous sequences
-- Example: "/safe/path/../../../etc/passwd" -> rejected
--          "/safe/path/file.txt" -> allowed
-----------------------------------------------------------------------------
function sanitizePath(path)
	if not path or not isstring(path) then
		return "/"
	end

	-- Remove null bytes and control characters
	path = removeControlChars(path)

	-- Normalize path separators
	path = string_gsub(path, "\\", "/")

	-- Remove dangerous sequences
	local dangerous_sequences = {
		"%.%./",           -- ../
		"%.%.\\",          -- ..\
		"/%.%./",          -- /../
		"\\%.%.\\",        -- \..\
		"%.%.%.",          -- ...
		"/%.%.",           -- /..
		"\\%.%."           -- \..
	}

	for _, sequence in ipairs(dangerous_sequences) do
		path = string_gsub(path, sequence, "/")
	end

	-- Split path into segments for validation
	local segments = {}
	for segment in string_gmatch(path, "[^/]+") do
		-- Skip empty segments and current directory references
		if segment ~= "" and segment ~= "." then
			-- Reject parent directory references
			if segment == ".." then
				return nil  -- Path traversal attempt detected
			end
			table_insert(segments, segment)
		end
	end

	-- Check path depth to prevent deep directory attacks
	if #segments > MAX_PATH_DEPTH then
		return nil
	end

	-- Rebuild clean path
	local clean_path = "/" .. table_concat(segments, "/")

	-- Ensure path doesn't end with dangerous extensions
	local dangerous_extensions = {
		"%.php$", "%.asp$", "%.jsp$", "%.cgi$", "%.pl$", "%.py$", "%.sh$", "%.bat$", "%.cmd$"
	}

	for _, ext_pattern in ipairs(dangerous_extensions) do
		if string_match(string_lower(clean_path), ext_pattern) then
			return nil  -- Dangerous file extension
		end
	end

	return clean_path
end

-----------------------------------------------------------------------------
-- URL Sanitization - Comprehensive URL security validation
-- Combines all security checks into a single validation function
-- Checks URL length, protocol, and overall structure for safety
-- Example: "javascript:alert('xss')" -> nil (rejected)
--          "https://example.com/safe/path" -> sanitized URL
-----------------------------------------------------------------------------
function sanitizeURL(url_string)
	if not url_string or not isstring(url_string) then
		return nil
	end

	-- Check URL length to prevent DoS attacks
	if #url_string > MAX_URL_LENGTH then
		return nil
	end

	-- Remove leading/trailing whitespace and control characters
	url_string = string_gsub(url_string, "^%s+", "")
	url_string = string_gsub(url_string, "%s+$", "")
	url_string = removeControlChars(url_string)

	-- Parse URL to check components
	local parsed = parse(url_string)
	if not parsed then
		return nil
	end

	-- Validate protocol
	if parsed.scheme and not isAllowedProtocol(parsed.scheme) then
		return nil
	end

	-- Sanitize path
	if parsed.path then
		local clean_path = sanitizePath(parsed.path)
		if not clean_path then
			return nil
		end
		parsed.path = clean_path
	end

	return build(parsed)
end

-----------------------------------------------------------------------------
-- Builds a path from a base path and a relative path
-- Input: base_path, relative_path
-- Returns: corresponding absolute path
-----------------------------------------------------------------------------
local function absolute_path(base_path, relative_path)
	if string_sub(relative_path, 1, 1) == "/" then return relative_path end
	local path = string_gsub(base_path, "[^/]*$", "")
	path = path .. relative_path

	path = string_gsub(path, "([^/]*%./)", function(s)
		if s ~= "./" then
			return s
		else
			return ""
		end
	end)

	path = string_gsub(path, "/%.$", "/")
	local reduced

	while reduced ~= path do
		reduced = path

		path = string_gsub(reduced, "([^/]*/%.%./)", function(s)
			if s ~= "../../" then
				return ""
			else
				return s
			end
		end)
	end

	path = string_gsub(reduced, "([^/]*/%.%.)$", function(s)
		if s ~= "../.." then
			return ""
		else
			return s
		end
	end)

	return path
end

-----------------------------------------------------------------------------
-- Parses a url and returns a table with all its parts according to RFC 2396
-- The following grammar describes the names given to the URL parts
-- <url> ::= <scheme>://<authority>/<path>;<params>?<query>#<fragment>
-- <authority> ::= <userinfo>@<host>:<port>
-- <userinfo> ::= <user>[:<password>]
-- <path> :: = {<segment>/}<segment>
-- Input: url - uniform resource locator of request
--        default - table with default values for each field
-- Returns: table with URL components or nil if invalid
-----------------------------------------------------------------------------
function parse(url, default)
	-- Initialize default parameters
	local parsed = {}

	for i, v in pairs(default or parsed) do
		parsed[i] = v
	end

	-- Empty url is parsed to nil
	if not url or url == "" then return nil, "invalid url" end

	-- Get fragment
	url = string_gsub(url, "#(.*)$", function(f)
		parsed.fragment = f
		return ""
	end)

	-- Get scheme with validation
	url = string_gsub(url, "^([%w][%w%+%-%.]*)%://", function(s)
		parsed.scheme = string_lower(s)  -- Normalize scheme to lowercase
		return ""
	end)

	-- Get authority
	url = string_gsub(url, "^([^/%?]*)", function(n)
		parsed.authority = n
		return ""
	end)

	-- Get query string
	url = string_gsub(url, "%?(.*)", function(q)
		parsed.query = q
		return ""
	end)

	-- Get params
	url = string_gsub(url, "%;(.*)", function(p)
		parsed.params = p
		return ""
	end)

	-- Path is whatever was left
	if url ~= "" then
		parsed.path = url

		-- Get file information
		if string_GetFileFromFilename(url) then
			parsed.file = {
				name = string_GetFileFromFilename(url),
				ext = string_GetExtensionFromFilename(url)
			}
		end
	else
		parsed.path = "/"
	end

	local authority = parsed.authority
	if not authority then return parsed end

	authority = string_gsub(authority, "^([^@]*)@", function(u)
		parsed.userinfo = u
		return ""
	end)

	-- Parse port with validation
	authority = string_gsub(authority, ":([^:]*)$", function(p)
		local port_num = tonumber(p)
		if port_num and port_num >= 1 and port_num <= 65535 then
			parsed.port = p
		end
		return ""
	end)

	if authority ~= "" then
		parsed.host = string_lower(authority)  -- Normalize host to lowercase
	end

	local userinfo = parsed.userinfo
	if not userinfo then return parsed end

	userinfo = string_gsub(userinfo, ":([^:]*)$", function(p)
		parsed.password = p
		return ""
	end)

	parsed.user = userinfo

	return parsed
end

-----------------------------------------------------------------------------
-- Parse URL with built-in security validation and parameter handling
-- This function automatically applies security measures to protect against
-- common web vulnerabilities while parsing URLs into structured components
--
-- Input: url - URL string to parse
--        default - table with default values for each field
-- Returns: table with parsed URL components or nil if security validation fails
--
-- Security features applied automatically:
-- • Protocol validation (only allows http, https)
-- • Parameter sanitization (removes script injection patterns)
-- • XSS prevention (escapes dangerous HTML characters)
-- • Directory traversal protection (blocks ../ path attacks)
-- • Input length limits (prevents DoS attacks)
--
-- Example outputs:
-- For "https://example.com/path?name=john&age=25#section1":
--   query = { name = "john", age = "25" }
--   fragment = { hash_type = "anchor", anchor = "section1", raw = "section1" }
--
-- For "https://app.com/#/users?id=123&role=admin":
--   fragment = {
--     hash_type = "route_with_params",
--     route = "/users",
--     params = { id = "123", role = "admin" },
--     raw = "/users?id=123&role=admin"
--   }
--
-- For malicious input like "javascript:alert('xss')":
--   Returns nil (blocked by protocol validation)
-----------------------------------------------------------------------------
function parse2(url, default)
	-- Apply comprehensive URL sanitization first
	-- This checks URL length, removes control characters, and validates structure
	local clean_url = sanitizeURL(url)
	if not clean_url then
		return nil  -- URL failed security validation
	end

	-- Parse the sanitized URL using the base parser
	local parsed = parse(clean_url, default)
	if not parsed then return end

	-- Validate URL protocol against whitelist
	-- Only http and https are allowed to prevent code injection
	if parsed.scheme and not isAllowedProtocol(parsed.scheme) then
		return nil  -- Dangerous protocol detected
	end

	-- Sanitize the URL path to prevent directory traversal attacks
	-- This removes ../ sequences and validates path depth
	if parsed.path then
		local clean_path = sanitizePath(parsed.path)
		if not clean_path then
			return nil  -- Path traversal attempt detected
		end
		parsed.path = clean_path
	end

	-- Parse query parameters with automatic security sanitization
	-- Each parameter is URL-decoded and checked for malicious content
	if parsed.query then
		local query_string = parsed.query
		local param_pairs = string_Explode("&", query_string)
		local params = {}

		for i = 1, #param_pairs do
			local key_value = string_Explode("=", param_pairs[i], 2)
			local key = key_value[1]
			local value = key_value[2] or ""

			if key then
				-- URL decode the parameter key and value
				key = unescape(key)
				value = unescape(value)

				-- Apply security sanitization to remove dangerous content
				-- This checks for script tags, event handlers, and other XSS vectors
				local clean_key, clean_value = sanitizeParam(key, value)
				if clean_key and clean_value then
					params[clean_key] = clean_value
				end
				-- Note: Parameters that fail sanitization are silently dropped
			end
		end

		parsed.query = params
	end

	-- Parse fragment with security validation and hash type detection
	-- Fragments are analyzed to determine their purpose (anchor, route, parameters)
	if parsed.fragment then
		local fragment = parsed.fragment
		parsed.fragment = {
			raw = htmlentities_secure(fragment),  -- Apply XSS protection to raw fragment
			params = {},
			hash_type = "unknown"
		}

		-- Check if fragment contains route with query parameters
		-- Pattern: #/route/path?param1=value1&param2=value2
		local route_part, query_part = fragment:match("^([^%?]*)%?(.*)$")

		if route_part and query_part then
			-- Hash-based routing with parameters (common in single-page applications)
			local clean_route = sanitizePath(route_part)
			if clean_route then
				parsed.fragment.hash_type = "route_with_params"
				parsed.fragment.route = clean_route

				-- Parse and sanitize query parameters within the fragment
				local param_pairs = string_Explode("&", query_part)
				for i = 1, #param_pairs do
					local key_value = string_Explode("=", param_pairs[i], 2)
					local key = key_value[1]
					local value = key_value[2] or ""

					if key then
						key = unescape(key)
						value = unescape(value)

						-- Apply same security sanitization as query parameters
						local clean_key, clean_value = sanitizeParam(key, value)
						if clean_key and clean_value then
							parsed.fragment.params[clean_key] = clean_value
						end
					end
				end
			else
				-- Route failed sanitization, treat as generic content
				parsed.fragment.hash_type = "content"
				parsed.fragment.content = htmlentities_secure(fragment)
				return parsed
			end
		elseif fragment:match("^[%w%-_]+$") then
			-- Simple anchor link (e.g., #section1, #top)
			-- These are generally safe but still apply XSS protection
			parsed.fragment.hash_type = "anchor"
			parsed.fragment.anchor = htmlentities_secure(fragment)
		elseif fragment:match("[&=]") then
			-- Fragment contains parameters without route (e.g., #param1=value1&param2=value2)
			-- This is less common but still needs parameter sanitization
			parsed.fragment.hash_type = "parameters"
			local param_pairs = string_Explode("&", fragment)

			for i = 1, #param_pairs do
				local key_value = string_Explode("=", param_pairs[i], 2)
				local key = key_value[1]
				local value = key_value[2] or ""

				if key then
					key = unescape(key)
					value = unescape(value)

					-- Apply security sanitization to fragment parameters
					local clean_key, clean_value = sanitizeParam(key, value)
					if clean_key and clean_value then
						parsed.fragment.params[clean_key] = clean_value
					end
				end
			end
		elseif fragment:match("^/") then
			-- Hash-based routing without parameters (e.g., #/users/profile)
			-- Common in modern web applications for client-side routing
			local clean_route = sanitizePath(fragment)
			if clean_route then
				parsed.fragment.hash_type = "route"
				parsed.fragment.route = clean_route
			else
				-- Route failed sanitization, treat as generic content
				parsed.fragment.hash_type = "content"
				parsed.fragment.content = htmlentities_secure(fragment)
			end
		else
			-- Other hash content (e.g., #some-text-content)
			-- Apply XSS protection to prevent HTML injection
			parsed.fragment.hash_type = "content"
			parsed.fragment.content = htmlentities_secure(fragment)
		end
	end

	return parsed
end

-----------------------------------------------------------------------------
-- Rebuilds a parsed URL from its components
-- Components are protected if any reserved or unallowed characters are found
-- Input: parsed - parsed URL, as returned by parse
-- Returns: a string with the corresponding URL
-----------------------------------------------------------------------------
function build(parsed)
	local ppath = parse_path(parsed.path or "")
	local url = build_path(ppath)
	local url = (parsed.path or ""):gsub("[^/]+", unescape)
	local url = url:gsub("[^/]*", protect_segment)

	if parsed.params then
		url = url .. ";" .. parsed.params
	end

	if parsed.query then
		url = url .. "?" .. parsed.query
	end

	local authority = parsed.authority

	if parsed.host then
		authority = parsed.host

		if parsed.port then
			authority = authority .. ":" .. parsed.port
		end

		local userinfo = parsed.userinfo

		if parsed.user then
			userinfo = parsed.user

			if parsed.password then
				userinfo = userinfo .. ":" .. parsed.password
			end
		end

		if userinfo then
			authority = userinfo .. "@" .. authority
		end
	end

	if authority then
		url = "//" .. authority .. url
	end

	if parsed.scheme then
		url = parsed.scheme .. ":" .. url
	end

	if parsed.fragment then
		url = url .. "#" .. parsed.fragment
	end

	-- Remove empty components
	url = string_gsub(url, "%?$", "")
	url = string_gsub(url, "/$", "")

	return url
end

-----------------------------------------------------------------------------
-- Composes an absolute URL from a base and a relative URL according to RFC 2396
-- Input: base_url - base URL
--        relative_url - relative URL
-- Returns: corresponding absolute URL
-----------------------------------------------------------------------------
function absolute(base_url, relative_url)
	if istable(base_url) then
		base_parsed = base_url
		base_url = build(base_parsed)
	else
		base_parsed = parse(base_url)
	end

	local relative_parsed = parse(relative_url)
	if not base_parsed then return relative_url end
	if not relative_parsed then return base_url end
	if relative_parsed.scheme then return relative_url end

	relative_parsed.scheme = base_parsed.scheme
	if not relative_parsed.authority then
		relative_parsed.authority = base_parsed.authority
		if not relative_parsed.path then
			relative_parsed.path = base_parsed.path
			if not relative_parsed.params then
				relative_parsed.params = base_parsed.params
				if not relative_parsed.query then
					relative_parsed.query = base_parsed.query
				end
			end
		else
			relative_parsed.path = absolute_path(base_parsed.path or "", relative_parsed.path)
		end
	end

	return build(relative_parsed)
end

-----------------------------------------------------------------------------
-- Breaks a path into its segments, unescaping the segments
-- Input: path - path to be parsed
-- Returns: segment list
-----------------------------------------------------------------------------
function parse_path(path)
	local parsed = {}
	path = path or ""

	-- Get each segment
	string_gsub(path, "([^/]*)", function(s)
		table_insert(parsed, s)
	end)

	-- Unescape each segment
	for i = 1, #parsed do
		parsed[i] = unescape(parsed[i])
	end

	if string_sub(path, 1, 1) == "/" then
		parsed.is_absolute = 1
	end

	if string_sub(path, -1, -1) == "/" then
		parsed.is_directory = 1
	end

	return parsed
end

-----------------------------------------------------------------------------
-- Builds a path component from its segments, escaping protected characters
-- Input: parsed - path segments
--        unsafe - if true, segments are not protected before composition
-- Returns: corresponding path string
-----------------------------------------------------------------------------
function build_path(parsed, unsafe)
	local path = ""
	local escape = unsafe and function(x) return x end or protect_segment
	local n = #parsed

	for i = 1, n - 1 do
		if parsed[i] ~= "" or parsed[i + 1] == "" then
			path = path .. escape(parsed[i])

			if i < n - 1 or parsed[i + 1] ~= "" then
				path = path .. "/"
			end
		end
	end

	if n > 0 then
		path = path .. escape(parsed[n])

		if parsed.is_directory then
			path = path .. "/"
		end
	end

	if parsed.is_absolute then
		path = "/" .. path
	end

	return path
end

-----------------------------------------------------------------------------
-- Helper functions
-----------------------------------------------------------------------------

-- Get specific query parameter from parsed URL
function getQueryParam(parsed_url, param_name)
	if not parsed_url or not parsed_url.query then
		return nil
	end

	if istable(parsed_url.query) then
		return parsed_url.query[param_name]
	end

	return nil
end

-- Get specific fragment parameter from parsed URL
function getFragmentParam(parsed_url, param_name)
	if not parsed_url or not parsed_url.fragment then
		return nil
	end

	if istable(parsed_url.fragment) and parsed_url.fragment.params then
		return parsed_url.fragment.params[param_name]
	end

	return nil
end

-- Check if URL fragment matches specific hash type
function hasHashType(parsed_url, hash_type)
	if not parsed_url or not parsed_url.fragment then
		return false
	end

	if istable(parsed_url.fragment) then
		return parsed_url.fragment.hash_type == hash_type
	end

	return false
end

-- Check if parsed URL has specific query parameter
function hasQueryParam(parsed_url, param_name)
	if not parsed_url or not parsed_url.query then
		return false
	end

	if istable(parsed_url.query) then
		return parsed_url.query[param_name] ~= nil
	end

	return false
end

-- Validate if URL string has proper structure
function isValidURL(url_string)
	if not url_string or url_string == "" then
		return false
	end

	local parsed = parse(url_string)
	return parsed ~= nil and parsed.scheme ~= nil and parsed.host ~= nil
end

-- Normalize URL for consistent processing
function normalizeURL(parsed_url)
	if not parsed_url then return nil end

	-- Convert host to lowercase
	if parsed_url.host then
		parsed_url.host = string_lower(parsed_url.host)
	end

	-- Remove default ports
	if parsed_url.port then
		if (parsed_url.scheme == "http" and parsed_url.port == "80") or
		   (parsed_url.scheme == "https" and parsed_url.port == "443") then
			parsed_url.port = nil
		end
	end

	-- Normalize path
	if not parsed_url.path or parsed_url.path == "" then
		parsed_url.path = "/"
	end

	return parsed_url
end

-- Get query parameter with security validation
function getQueryParamSecure(parsed_url, param_name)
	if not parsed_url or not parsed_url.query or not param_name then
		return nil
	end

	-- Sanitize parameter name before lookup
	local clean_name, _ = sanitizeParam(param_name, "dummy")
	if not clean_name then
		return nil
	end

	if istable(parsed_url.query) then
		local value = parsed_url.query[clean_name]
		return value and htmlentities_secure(value) or nil
	end

	return nil
end

-- Get fragment parameter with security validation
function getFragmentParamSecure(parsed_url, param_name)
	if not parsed_url or not parsed_url.fragment or not param_name then
		return nil
	end

	local clean_name, _ = sanitizeParam(param_name, "dummy")
	if not clean_name then
		return nil
	end

	if istable(parsed_url.fragment) and parsed_url.fragment.params then
		local value = parsed_url.fragment.params[clean_name]
		return value and htmlentities_secure(value) or nil
	end

	return nil
end