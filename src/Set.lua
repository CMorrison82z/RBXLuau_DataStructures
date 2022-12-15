local t_insert = table.insert
local t_remove = table.remove
local t_find = table.find

local Module = {}

export type Map = {any : boolean}
export type Array = {any}

Module.ArrayToMap = function(array : Array)
	local map : Map = {}

	for _, value in array do
		map[value] = true
	end

	return map
end

-- Uses Array's values as keys, and the value mapped to that key is also the value itself.
Module.ArrayToKVMap = function(array : Array)
	local map : Map = {}

	for _, value in array do
		map[value] = value
	end

	return map
end

Module.IsSuperMap = function(Map1 : Map, ...: Map)
	for _, aMap in {...} do
		for value in aMap do
			if not Map1[value] then
				return false
			end
		end
	end

	return true
end

Module.IsSuperArray = function(Array1 : Array, ...: Array)
	local _map = Module.ArrayToMap(Array1)

	for _, aArray in {...} do
		for _, value in aArray do
			if not _map[value] then
				return false
			end
		end
	end

	return true
end

Module.IsSubMap = function(Map1 : Map, ...: Map)
	local _nMaps = {...}

	for value in Map1 do
		for _, aMap in _nMaps do
			if not aMap[value] then
				return false
			end
		end
	end

	return true
end

Module.IsSubArray = function(Array1 : Array, ...: Array)
	local _nMaps = {}

	local _toMap = Module.ArrayToMap

	-- converting to maps reduces O from "#a1 * #a_i" to "#a1 + #a_i
	for _, aArray in {...} do
		table.insert(_nMaps, _toMap(aArray))
	end

	for _, value in Array1 do
		for _, _map in _nMaps do
			if not _map[value] then
				return false
			end
		end
	end

	for _, aArray in {...} do
		
	end

	return true
end

--## Get all values that are both in map1 and map2
Module.IntersectionMap = function(Map1 : Map, Map2 : Map)
	local Map3 = {}

	for Value in Map1 do
		if Map2[Value] then
			Map3[Value] = true
		end
	end

	return Map3
end

Module.IntersectionArray = function(Array1 : Array, Array2 : Array)
	local Array3 = {}

	local _map = Module.ArrayToMap(Array2)

	for _, Value in Array1 do
		if _map[Value] then
			t_insert(Array3, Value)
		end
	end

	return Array3
end

--## Get all values both in map1 and map2
Module.UnionMap = function(Map1 : Map, Map2 : Map)
	local Map3 = table.clone(Map1)

	for value in Map2 do
		Map3[value] = true
	end

	return Map3
end

Module.UnionArray = function(Array1 : Array, Array2 : Array)
	local Array3 = table.clone(Array1)

	local _added = Module.ArrayToMap(Array3)

	for index, value in Array2 do
		if _added[value] then continue end

		t_insert(Array3, value)
		_added[value] = true
	end

	return Array3
end

--## Gets the map : (Map1 - Map2 : Map)
Module.ComplementationMap = function(Map1 : Map, Map2 : Map)
	local Map3 = {}

	for Value in Map1 do
		if not Map2[Value] then
			Map3[Value] = true
		end
	end

	return Map3
end

Module.ComplementationArray = function(Array1 : Array, Array2 : Array)
	local Array3 = {}

	local _map = Module.ArrayToMap(Array2)

	for _, Value in Array1 do
		if not _map[Value] then
			t_insert(Array3, Value)
		end
	end

	return Array3
end

Module.SymmetricComplimentationMap = function(Map1, Map2)
	local rMap = Module.UnionMap(Map1, Map2)
	Module.ComplementMap(rMap, Module.IntersectionMap(Map1, Map2)) -- Using the imperative 'Complement' Map on the returned map from the pure "Union" Map. The function itself is Pure.
	
	return rMap
end

Module.SymmetricComplimentationArray = function(Array1 : Array, Array2 : Array)
	local rArray = Module.UnionArray(Array1, Array2)
	Module.ComplementArray(rArray, Module.IntersectionArray(Array1, Array2))
	
	return rArray
end

--================= TUPLE ===============|>

Module.FiniteIntersectionMap = function(Map1 : Map, ...: Map)
	local rMap = {}

	-- Elements must be in all sets, so choosing an arbitrary map from the list yields the same thing.
	local nMaps = {...}

	for value in Map1 do
		local include = true

		for _, oMap : Map in nMaps do
			if not oMap[value] then
				include = false
				break
			end
		end

		if include then
			rMap[value] = true
		end
	end

	return rMap
end

Module.FiniteIntersectionArray = function(Array1 : Array, ...: Array)
	local rArray = {}
	
	-- Elements must be in all sets, so choosing an arbitrary map from the list yields the same thing.
	local _nMaps = {}

	local _toMap = Module.ArrayToMap

	-- converting to maps reduces O from "#a1 * #a_i" to "#a1 + #a_i
	for _, aArray in {...} do
		table.insert(_nMaps, _toMap(aArray))
	end
	
	for _, value in Array1 do
		local include = true

		for _, oMap : Array in _nMaps do
			if not oMap[value] then
				include = false
				break
			end
		end

		if include then
			t_insert(rArray, value)
		end
	end

	return rArray
end

Module.FiniteUnionMap = function(...: Map)
	local rMap = {}

	for _, aMap : Map in {...} do
		for value in aMap do
			rMap[value] = true
		end
	end

	return rMap
end

Module.FiniteUnionArray = function(...: Array)
	local rArray = {}

	local _added = {}

	for _, aArray : Array in {...} do
		for _, value in aArray do
			if _added[value] then continue end

			t_insert(rArray, value)
			_added[value] = true
		end
	end

	return rArray
end

Module.FiniteComplementationMap = function(Map1 : Map, ...: Map)
	local rMap = {}

	local nMaps = {...}

	for value in Map1 do
		local include = true

		for _, aMap : Map in nMaps do
			if aMap[value] then
				include = false
				break
			end
		end

		if include then
			rMap[value] = true
		end
	end

	return rMap
end

Module.FiniteComplementationArray = function(Array1 : Array, ...: Array)
	local rArray = {}

	local _nMaps = {}

	local _toMap = Module.ArrayToMap

	-- converting to maps reduces O from "#a1 * #a_i" to "#a1 + #a_i
	for _, aArray in {...} do
		table.insert(_nMaps, _toMap(aArray))
	end

	for _, value in Array1 do
		local include = true

		for _, aMap : Array in _nMaps do
			if aMap[value] then
				include = false
				break
			end
		end

		if include then
			t_insert(rArray, value)
		end
	end

	return rArray
end

Module.FiniteSymmetricComplementationMap = function(...: Map)
	local rMap = Module.FiniteUnionMap(...)
	Module.ComplementMap(rMap, Module.FiniteIntersectionMap(...))
	
	return rMap
end

Module.FiniteSymmetricComplementationArray = function(...: Array)
	local rArray = Module.FiniteUnionArray(...)
	Module.ComplementArray(rArray, Module.FiniteIntersectionArray(...))
	
	return rArray
end

--================= IMPERATIVES ===============|>

Module.IntersectMap = function(Map1:Map, Map2:Map)
	local _toRemove = {}

	for value in Map1 do
		if not Map2[value] then
			t_insert(_toRemove, value)
		end
	end

	for _, value in _toRemove do
		Map1[value] = nil
	end
end

Module.IntersectArray = function(Array1 : Array, Array2 : Array)
	local i = 1

	local _map = Module.ArrayToMap(Array2)

	while i <= #Array1 do
		-- * when removing, the index of the next element shifts down to the same index that we are already on, so DO NOT INCREMENT.
		if not _map[Array1[i]] then
			t_remove(Array1, i)
		else
			i += 1
		end
	end
end

Module.UniteMap = function(Map1 : Map, Map2 : Map)
	for Value in Map2 do
		Map1[Value] = true
	end
end

Module.UniteArray = function(Array1 : Array, Array2 : Array)
	local _contains = Module.ArrayToMap(Array1)
	
	for _, v in Array2 do
		if _contains[v] then continue end
		
		t_insert(Array1, v)
		_contains[v] = true
	end
end

-- Mutate Map1 : (Map1 - Map2)
Module.ComplementMap = function(Map1, Map2)
	for Value in Map2 do
		Map1[Value] = nil
	end
end

-- Mutate Array1 : (Array1 - Array2)
Module.ComplementArray = function(Array1, Array2)
	for Index, Value in Array2 do
		local i = t_find(Array1, Value)
		if i then
			t_remove(Array1, i)
		end
	end
end

Module.SymmetricComplimentMap = function(Map1, Map2)
	local cMap1 = table.clone(Map1) -- Map1 will be modified by Unite, but is needed in Intersection to be its original form
	
	Module.UniteMap(Map1, Map2)
	Module.ComplementMap(Map1, Module.IntersectionMap(cMap1, Map2))
end

Module.SymmetricComplimentArray = function(Array1 : Array, Array2 : Array)
	local cArray1 = table.clone(Array1)
	
	Module.UniteArray(Array1, Array2) -- Imperative, so Array1 is now Array1 U Array2
	warn(Array1, Module.IntersectionArray(cArray1, Array2))
	Module.ComplementArray(Array1, Module.IntersectionArray(cArray1, Array2))
end

--================= IMPERATIVE TUPLE ===============|>

Module.FiniteIntersectMap = function(Map1 : Map, ...: Map)
	local nMaps = {...}

	local _toRemove = {}

	for value in Map1 do
		local remove = false

		for _, oMap : Map in nMaps do
			if not oMap[value] then
				remove = true
				break
			end
		end

		if remove then
			t_insert(_toRemove, value)
		end
	end

	for _, value in _toRemove do
		Map1[value] = nil
	end
end

Module.FiniteIntersectArray = function(Array1 : Array, ...: Array)
	-- We're removing from Map1, instead of Adding to rMap

	local _nMaps = {}

	local _toMap = Module.ArrayToMap

	-- converting to maps reduces O from "#a1 * #a_i" to "#a1 + #a_i
	for _, aArray in {...} do
		table.insert(_nMaps, _toMap(aArray))
	end

	local i = 1

	while i <= #Array1 do
		local value = Array1[i]
		local remove = false

		for _, oMap : Map in _nMaps do
			if not oMap[value] then
				remove = true
				break
			end
		end

		-- * when removing, the index of the next element shifts down to the same index that we are already on, so DO NOT INCREMENT.
		if remove then
			t_remove(Array1, i)
		else
			i += 1
		end
	end
end

Module.FiniteUniteMap = function(Map1 : Map, ...: Map)
	for _, aMap : Map in {...} do
		for value in aMap do
			Map1[value] = true
		end
	end
end

Module.FiniteUniteArray = function(Array1 : Array, ...: Array)
	local _added = Module.ArrayToMap(Array1)

	for _, aArray : Array in {...} do
		for _, value in aArray do
			if _added[value] then continue end

			t_insert(Array1, value)
			_added[value] = true
		end
	end
end


Module.FiniteComplementMap = function(Map1 : Map, ...: Map) 
	local nMaps = {...}

    --[[
        -- ! This method would be always be O(n * mapSize_i)
        for _, aMap : Map in nMaps do
            for value in aMap do
                Map1[value] = nil
            end
        end
    ]]

	local _toRemove = {}

	-- O(map1Size * (x <= n))
	for value in Map1 do
		local remove = false

		for _, aMap : Map in nMaps do
			if aMap[value] then
				remove = true
				break
			end
		end

		if remove then
			t_insert(_toRemove, value)
		end
	end

	for _, value in _toRemove do
		Map1[value] = nil
	end
end

Module.FiniteComplementArray = function(Array1 : Array, ...: Array)
	local _nMaps = {}

	local _toMap = Module.ArrayToMap

	-- converting to maps reduces O from "#a1 * #a_i" to "#a1 + #a_i
	for _, aArray in {...} do
		table.insert(_nMaps, _toMap(aArray))
	end

	local i = 1

	while i <= #Array1 do
		local value = Array1[i]
		local remove = false

		for _, aMap : Map in _nMaps do
			if aMap[value] then
				remove = true
				break
			end
		end

		if remove then
			t_remove(Array1, i)
		else
			i += 1
		end
	end
end

Module.FiniteSymmetricComplementMap = function(Map1 : Map, ...: Map)
	local cMap = table.clone(Map1)
	
	Module.FiniteUniteMap(Map1, ...)
	Module.ComplementMap(Map1, Module.FiniteIntersectionMap(cMap, ...))
end

Module.FiniteSymmetricComplementArray = function(Array1 : Array, ...: Array)
	local cArray = table.clone(Array1)
	
	Module.FiniteUniteArray(Array1, ...)
	Module.ComplementArray(Array1, Module.FiniteIntersectionArray(cArray, ...))
end

--## Get the size of the map
Module.MapSize = function(Map)
	local Size = 0

	for _ in Map do
		Size += 1
	end

	return Size
end

return Module