--[[
Name: EnchantScrollMats
Description: Shows the required materials to make things like enchant scrolls in the tooltip of the item

Copyright 2010 Quaiche

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

assert(TradeskillInfo, "EnchantScrollMats requires TradeSkillInfo")

local addonName, ns = ...
local origs = {}

local function OnTooltipSetItem(frame, ...)
	local name, link = frame:GetItem()
	if link then
		local id = tonumber(link:match("item:(%d+):"))
		local class, subclass = select(6, GetItemInfo(id))
		if class == "Consumable" and subclass == "Item Enhancement" then
			local components = TradeskillInfo:GetCombineComponents(id)
			if components then
				local left = "Materials"
				for i,v in ipairs(components) do
					frame:AddDoubleLine(left, v.name .. " x" .. v.num)
					left = " "
				end
			end
		end
	end
	if origs[frame] then return origs[frame](frame, ...) end
end

for _,frame in pairs{GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2} do
	origs[frame] = frame:GetScript("OnTooltipSetItem")
	frame:SetScript("OnTooltipSetItem", OnTooltipSetItem)
end

