local Globals = {}

function Globals.FindValue(tab: {}, value: any)
	for _, v in ipairs(tab) do
		if v == value then
			return v
		end
	end
	return nil
end

function Globals.CommaNumber(num: number)
	local numStr = tostring(num)
	while true do
		local subsMade
		numStr, subsMade = string.gsub(numStr, "^(-?%d+)(%d%d%d)", "%1,%2")
		if subsMade == 0 then
			break
		end
	end
	return numStr
end

function Globals.MoveToMemory(inst: Instance)
	local clone = inst:Clone()
	inst:Destroy()
	return clone
end

function Globals.ShiftColorBrightness(color: Color3, scale: number)
	local r = math.clamp(color.R + scale, 0, 1)
	local g = math.clamp(color.G + scale, 0, 1)
	local b = math.clamp(color.B + scale, 0, 1)
	return Color3.new(r, g, b)
end

return Globals
