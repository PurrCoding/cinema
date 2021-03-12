local meta = FindMetaTable("Vector")
if not meta then return end

function meta:InBox( vec1, vec2 )
	return self.x >= vec1.x and self.x <= vec2.x and
		self.y >= vec1.y and self.y <= vec2.y and
		self.z >= vec1.z and self.z <= vec2.z
end