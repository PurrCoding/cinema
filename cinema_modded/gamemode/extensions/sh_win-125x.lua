---------------------------------------------------------------------
-- Converter between win-125x and UTF-8 strings
---------------------------------------------------------------------
-- Written in pure Lua, compatible with Lua 5.1-5.4
-- Usage example:
--    str_win  = util.utf8_to_win(str_utf8)
--    str_utf8 = util.win_to_utf8(str_win)
---------------------------------------------------------------------
-- Src: @Egor-Skriptunoff - https://gist.github.com/Egor-Skriptunoff/44a88f64f9a497919db4ad8c28259a8f#file-win-125x-lua
-- Info: This code has been slightly modified to work with the Cinema gamemode.

module("util", package.seeall)

-- The following codepages are supported:
--   874  Thai
--  1250  Central European
--  1251  Cyrillic
--  1252  Western
--  1253  Greek
--  1254  Turkish
--  1255  Hebrew
--  1256  Arabic
--  1257  Baltic
--  1258  Vietnamese
local compressed_mappings = {
	-- Unicode to win-125x mappings are taken from unicode.org, compressed and protected by a checksum -- Thai, 97 codepoints above U+007F
	[874] = [[!%l+$"""WN^9=&$pqF'oheO#;0l#"hs)mI[=e!ufwkDB#OwLnJ|IRIUz8Q(MMM]],
	-- Central European, 123 codepoints above U+007F
	[1250] = [[!<2#?v"1(ro;xh/tL_3hC^i;e~PjO"p<I\aTT};]Rb~M7/]&jRjfwuE%AJ)@XfBQy&\jy[V5:]!RtH]m>Yd8m?6LpsUA\V=x'VcMO<Wz+EOO
			0m7U`u|$Y5x?Vk*6+qJ@/0Lie77_b}OEuwv$Qj/w`+J>M*<g2qxD3qEyC&*{VGI'UddQ`GQ)L=lj<{S;Jm),f3yzcQOuxacHSZ{X'XIWzDz!?E
			=U0f]],
	-- Cyrillic, 127 codepoints above U+007F
	[1251] = [[!-[;_8kMai7j]xB$^n)#7ngrX}_b%{<Cdot;P?2J&00&^wX|;]@N*fjq#ioX'v.&gG@ur~3yi8t1;xn40{G#NX?7+hGC{$D"4#oJ//~kflzs
			"_\z9qP#}1o|@{t`2NrM%t{MW?X9d6o:MqHl6+z]],
	-- Western, 123 codepoints above U+007F
	[1252] = [[!)W$<c~\OdA5TJ%/J/{:yoE]K[d,c<Mv+gp_[_UuB52c;H&{leFk%Kd8%cHnvLrB[>|:)t.}QH*)]AD|LqjsB+JCdKmbRIjO,]],
	-- Greek, 111 codepoints above U+007F
	[1253] = [[!./yDCq;#WAuC\C1R{=[n'FpSuc!"R\EZ|4&J?A3-z?*TI?ufbhFq1J!x@Sjff\!G{o^dDXl|8NLZ!$d'8$f^=hh_DPm!<>>bCgV(>erUWhX
			?R+-JP@4ju:Yw#*C]],
	-- Turkish, 121 codepoints above U+007F
	[1254] = [[!-(R[SPKY>cgcK5cCs4vk%MuL`yFx^Bl#/!l#M@#yoe|Jx+pxZuvh%r>O</n_gb>hDjmG]j#lA{]2"R-Z@(6Wy:Q~%;327b&fRSkF#BM/d+%
			iWmSx4E*\F_z=s>QeJBqC^]],
	-- Hebrew, 105 codepoints above U+007F
	[1255] = [[!.b\.H?S\21+7efm'`w&MW_Jg,mRbB;{X@T\3::DC#7<m_cAE!:%C%c7/,./u[8w*h-iwpz03QY,ay%]MI*D]W&]UG^3(=20a7$zG[Ng7MLt
			sXIne(V37A?OO%|Hn13wMh-?^jNzhW`,-]],
	-- Arabic, 128 codepoints above U+007F
	[1256] = [[!3n8GE$.to/ka%Nx`uOpcib>|9KU-N72!1J4c2NAUE3a,HlOE=M`@rsa||Nh_!og]:dILz9KNlF~vigNH*a0KxwjjfR*]?tO87(a3-RQex^V
			Ww&SY{:AqE|s%}@U8%rKcr0,NCjR:N&L'YyGu<us'sN*1pl=gAXOwSJ[v?f;imBhDu_)d$F8T?%S[]],
	-- Baltic, 116 codepoints above U+007F
	[1257] = [[!:<_.XQ[;n35s%I?g9)b/7DiGwIR)zy&=6?/3)6iO%rSnC_6yjl'8#zeN0vcW_yX/2*J93+EJVrW,^Rhe,h7wWl"}neF2~F[PyD;BcrG*5=J
			fh<x!FJ?qSw9Xp!;WB3T<J^x?#Ie`xufezR'\I(eED]3d&)VJL$/+$Zf;W^I>L[3D5F<_IcGpn=oX"JR1%arS|FX|dia4]BeF>d5p`EV+:;*I<
			x^Voq{"f]],
	-- Vietnamese, 119 codepoints above U+007F
	[1258] = [[!3n8C{%C0}&p3gE0~|&RVm9Wr&^ln1}'$gV{bml1oByN*bb:Bm^E;~B3-WjF6Qubq^`Y*6\0^w!DKpK<\7lHVELmSXN{2~B"0C"<1CYN2{$a
			5M?>|7%~qm{pXphwm3$}iyXjBYwtGqxp(f[!g^Ee9H.}1~0H-k-dzNDh1L]],
}

local char, byte, gmatch, floor, string_reverse = string.char, string.byte, string.gmatch, math.floor, string.reverse
local table_insert, table_concat = table.insert, table.concat

local function decompress_mapping(codepage)

	local width, offset, base, CS1, CS2, get_next_char = 1.0, 0.0, 0.0, 7 ^ 18, 5 ^ 22, gmatch(compressed_mappings[codepage], "%S")
	local mapping, rev_mapping, trees, unicode, ansi, prev_delta_unicode, prev_delta_ansi = {}, {}, {}, 0x7F, 0x7F

	local function decompress_selection(qty, tree)
		while width <= 94 ^ 7 do
			width, offset, base = width * 94.0, offset * 94.0 + byte(get_next_char()) - 33.0, (base - floor((base + width - 1) / 94 ^ 7) * 94 ^ 7) * 94.0
		end

		if qty then
			local big_qty = width % qty
			local small_unit = (width - big_qty) / qty
			local big_unit = small_unit + 1.0
			local offset_small = big_qty * big_unit
			local from, offset_from, left, right

			if offset < offset_small then
				width = big_unit
				offset_from = offset - offset % big_unit
				from = offset_from / big_unit
			else
				width = small_unit
				offset_from = offset - (offset - offset_small) % small_unit
				from = big_qty + (offset_from - offset_small) / small_unit
			end

			local len, leaf = 1.0, from

			if tree then
				leaf, left, right = 4, 0, qty
				repeat
					local middle = tree[leaf]

					if from < middle then
						right = middle
					else
						left, leaf = middle, leaf + 1
					end

					leaf = tree[leaf + 1]
				until leaf < 0
				from, len = left, right - left
				offset_from = left < big_qty and left * big_unit or offset_small + (left - big_qty) * small_unit
				width = (right < big_qty and right * big_unit or offset_small + (right - big_qty) * small_unit) - offset_from
			end

			base, offset = base + offset_from, offset - offset_from
			CS1, CS2 = (CS1 % 93471801.0) * (CS2 % 93471811.0) + qty, (CS1 % 93471821.0) * (CS2 % 93471831.0) - from * 773.0 - len * 7789.0

			return leaf
		end

		assert((CS1 - CS2) % width == offset)
	end

	local function get_delta(tree_idx)
		local tree = trees[tree_idx]
		local val = tree[3]

		if val == 0.0 then
			local leaf = decompress_selection(tree[1], tree)
			local max_exp_cnt = tree[2]
			val = leaf % max_exp_cnt
			leaf = (leaf - val) / max_exp_cnt + 2.0
			val = 2.0 ^ val
			val = val + decompress_selection(val)
			if leaf ~= 0.0 then return leaf * val end
		end

		tree[3] = val - 1.0
	end

	for tree_idx = 1, 2 do
		local total_freq = decompress_selection(2 ^ 15)
		local max_exp_cnt = decompress_selection(17)

		local tree, qty_for_leaf_info = {total_freq, max_exp_cnt, 0.0}, 3 * max_exp_cnt

		local function build_subtree(left, right, idx)
			local middle, subtree = left + 1
			middle = decompress_selection(right - middle) + middle
			tree[idx], idx = middle, idx + 3

			for next_idx = idx - 2, idx - 1 do
				if decompress_selection(2) == 1 then
					subtree, idx = idx, build_subtree(left, middle, idx)
				else
					subtree = decompress_selection(qty_for_leaf_info) - qty_for_leaf_info
				end

				tree[next_idx], left, middle = subtree, middle, right
			end

			return idx
		end

		build_subtree(0, total_freq, 4)
		trees[tree_idx] = tree
	end

	while true do
		local delta = get_delta(1)

		if not delta then
			delta = prev_delta_unicode
		elseif delta == prev_delta_unicode then
			decompress_selection()

			return mapping, rev_mapping
		end

		unicode, prev_delta_unicode, delta = unicode + delta, delta, get_delta(2) or prev_delta_ansi
		ansi, prev_delta_ansi = ansi + delta, delta
		mapping[unicode] = ansi
		rev_mapping[ansi] = unicode
	end
end

-- Create Mappings for each codepage
local map_unicode_to_ansi, map_ansi_to_unicode = {}, {}
for codepage, _ in pairs(compressed_mappings) do
	map_unicode_to_ansi[codepage], map_ansi_to_unicode[codepage] = decompress_mapping(codepage)
end

--[[---------------------------------------------------------
   	Name: util.utf8_to_win( )
   	Desc: Converts UTF-8 strings to win-125x
   	Parameters:
			- str: Input String to Convert
			- condepage: win-125x codepage
	Note: missing or invalid codepages fallback to 1251 (Cyrillic)
-----------------------------------------------------------]]
function utf8_to_win(str, codepage)
	if not codepage or (codepage and not compressed_mappings[codepage]) then
		codepage = 1251 -- Fallback to Cyrillic
	end

	local result_ansi, map = {}, map_unicode_to_ansi[codepage]

	for u in gmatch(str, ".[\128-\191]*") do
		local code = byte(u) % 2 ^ (8 - #u)

		for j = 2, #u do
			code = (code - 2) * 64 + byte(u, j)
		end

		table_insert(result_ansi, char(code < 128 and code or map[code] or byte"?"))
	end

	return table_concat(result_ansi)
end

--[[---------------------------------------------------------
   	Name: util.win_to_utf8( )
   	Desc: Converts win-125x strings to UTF-8
   	Parameters:
			- str: Input String to Convert
			- condepage: win-125x codepage
	Note: missing or invalid codepages fallback to 1251 (Cyrillic)
-----------------------------------------------------------]]
function win_to_utf8(str, codepage)
	if not codepage or (codepage and not compressed_mappings[codepage]) then
		codepage = 1251 -- Fallback to Cyrillic
	end

	local result_utf8, map = {}, map_ansi_to_unicode[codepage]

	for pos = #str, 1, -1 do
		local code, h = byte(str, pos), 127
		code = code < 128 and code or map[code] or byte"?"

		while code > h do
			table_insert(result_utf8, char(128 + code % 64))
			code, h = floor(code / 64), 288067 % h
		end

		table_insert(result_utf8, char((127 - h) * 2 + code))
	end

	return string_reverse(table_concat(result_utf8))
end