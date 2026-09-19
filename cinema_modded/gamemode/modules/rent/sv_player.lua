local meta = FindMetaTable("Player")
if not meta then return end

function meta:GetRentedTheater()
	return theater.GetByLocation(self._rentedTheater)
end

function meta:IsRentingTheater()
	return self._rentedTheater ~= nil
end