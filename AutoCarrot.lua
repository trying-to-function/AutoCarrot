if not AutoCarrotDB then
    AutoCarrotDB = { enabled = true, ridingGloves = true, mithrilSpurs = true, swimBelt = true, swimHelm = true, button = false, buttonScale = 1.0, trinketSlot1 = false, instance = false }
end

local CROP_OR_CARROT_ID = nil
local hasEnteredWorld = false
local f = CreateFrame("Frame")
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('PLAYER_LEAVING_WORLD')
f:RegisterEvent('BAG_UPDATE')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
f:SetScript("OnUpdate", function()
    if(not hasEnteredWorld or not UnitExists("player") or not UnitIsConnected("player") or not AutoCarrotDB.enabled or InCombatLockdown() or UnitIsDeadOrGhost("player")) then return end
    if(UnitLevel("player") <= 70) then
        if(IsMounted() and not UnitOnTaxi("player")) then
            local itemId = GetInventoryItemID("player", AutoCarrotDB.trinketSlot1 and 13 or 14) -- trinket slot 1/2
            if(itemId) then
                if(itemId ~= 25653 and itemId ~= 11122 and itemId ~= 32863) then
                    AutoCarrotDB.trinketId = itemId
                    if(CROP_OR_CARROT_ID and not StaticPopup1:IsShown()) then
                        EquipItemByName(CROP_OR_CARROT_ID, AutoCarrotDB.trinketSlot1 and 13 or 14)
                    end
                end
            else
                AutoCarrotDB.trinketId = nil
                if(CROP_OR_CARROT_ID and not StaticPopup1:IsShown()) then
                    EquipItemByName(CROP_OR_CARROT_ID, AutoCarrotDB.trinketSlot1 and 13 or 14)
                end
            end
            if(AutoCarrotDB.ridingGloves and AutoCarrotDB.enchantHandsLink) then
                itemLink = GetInventoryItemLink("player", 10) -- hands
                if(itemLink) then
                    local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                    if(enchantId ~= "930") then
                        AutoCarrotDB.handsLink = "item:"..itemId..":"..enchantId..":"
                        if(not StaticPopup1:IsShown()) then
                            EquipItemByName(AutoCarrotDB.enchantHandsLink, 10)
                        end
                    end
                else
                    AutoCarrotDB.handsLink = nil
                    if(not StaticPopup1:IsShown()) then
                        EquipItemByName(AutoCarrotDB.enchantHandsLink, 10)
                    end
                end
            end
            if(AutoCarrotDB.mithrilSpurs and AutoCarrotDB.enchantBootsLink) then    
                itemLink = GetInventoryItemLink("player", 8) -- feet
                if(itemLink) then
                    local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                    if(enchantId ~= "464") then
                        AutoCarrotDB.bootsLink = "item:"..itemId..":"..enchantId..":"
                        if(not StaticPopup1:IsShown()) then
                            EquipItemByName(AutoCarrotDB.enchantBootsLink, 8)
                        end
                    end
                else
                    AutoCarrotDB.bootsLink = nil
                    if(not StaticPopup1:IsShown()) then
                        EquipItemByName(AutoCarrotDB.enchantBootsLink, 8)
                    end
                end
            end
        else
            local itemId = GetInventoryItemID("player", AutoCarrotDB.trinketSlot1 and 13 or 14) -- trinket slot 1/2
            if(itemId) then
                if(itemId ~= 25653 and itemId ~= 11122 and itemId ~= 32863) then
                    AutoCarrotDB.trinketId = itemId
                elseif(AutoCarrotDB.trinketId and AutoCarrotDB.trinketId ~= GetInventoryItemID("player", AutoCarrotDB.trinketSlot1 and 14 or 13)) then
                    EquipItemByName(AutoCarrotDB.trinketId, AutoCarrotDB.trinketSlot1 and 13 or 14)
                end
            else
                AutoCarrotDB.trinketId = nil
            end
            if(AutoCarrotDB.ridingGloves and AutoCarrotDB.enchantHandsLink) then
                itemLink = GetInventoryItemLink("player", 10) -- hands
                if(itemLink) then
                    local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                    if(enchantId ~= "930") then
                        AutoCarrotDB.handsLink = "item:"..itemId..":"..enchantId..":"
                    elseif(AutoCarrotDB.handsLink) then
                        EquipItemByName(AutoCarrotDB.handsLink, 10)
                    end
                else
                    AutoCarrotDB.handsLink = nil
                end
            end
            if(AutoCarrotDB.mithrilSpurs and AutoCarrotDB.enchantBootsLink) then 
                itemLink = GetInventoryItemLink("player", 8) -- feet
                if(itemLink) then
                    local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
                    if(enchantId ~= "464") then
                        AutoCarrotDB.bootsLink = "item:"..itemId..":"..enchantId..":"
                    elseif(AutoCarrotDB.bootsLink) then
                        EquipItemByName(AutoCarrotDB.bootsLink, 8)
                    end
                else
                    AutoCarrotDB.bootsLink = nil
                end
            end    
        end
    end
    if(IsSwimming() and AutoCarrotDB.swimBelt) then
        local itemId = GetInventoryItemID("player", 6) -- waist
        if(itemId) then
            if(itemId ~= 7052) then
                AutoCarrotDB.beltId = itemId
                if(not StaticPopup1:IsShown()) then
                    EquipItemByName(7052, 6)
                end
            end
        else
            AutoCarrotDB.beltId = nil
            if(not StaticPopup1:IsShown()) then
                EquipItemByName(7052, 6)
            end
        end
    else
        local itemId = GetInventoryItemID("player", 6) -- waist
        if(itemId) then
            if(itemId ~= 7052) then
                AutoCarrotDB.beltId = itemId
            elseif(AutoCarrotDB.beltId) then
                EquipItemByName(AutoCarrotDB.beltId, 6)
            end
        else
            AutoCarrotDB.beltId = nil
        end
    end
    if(IsSubmerged() and AutoCarrotDB.swimHelm) then
        local itemId = GetInventoryItemID("player", 1) -- head
        if(itemId) then
            if(itemId ~= 10506) then
                AutoCarrotDB.headId = itemId
                if(not StaticPopup1:IsShown()) then
                    EquipItemByName(10506, 1)
                end
            end
        else
            AutoCarrotDB.headId = nil
            if(not StaticPopup1:IsShown()) then
                EquipItemByName(10506, 1)
            end
        end
    else
        local itemId = GetInventoryItemID("player", 1) -- head
        if(itemId) then
            if(itemId ~= 10506) then
                AutoCarrotDB.headId = itemId
            elseif(AutoCarrotDB.headId) then
                EquipItemByName(AutoCarrotDB.headId, 1)
            end
        else
            AutoCarrotDB.headId = nil
        end
    end
end)
f:SetScript('OnEvent', function(self, event, ...)
    if(event == 'ADDON_LOADED') then 
        local addon = ...
        if(addon == 'AutoCarrot') then
            AutoCarrot_OnLoad()
        end
    elseif(event == 'PLAYER_LEAVING_WORLD') then
        hasEnteredWorld = false
    else -- PLAYER_ENTERING_WORLD / BAG_UPDATE / PLAYER_EQUIPMENT_CHANGED
        if(event == 'PLAYER_ENTERING_WORLD' and AutoCarrotDB.instance) then
            if (IsInInstance()) then
                if (AutoCarrotDB.enabled) then
                    AutoCarrotButton:Click()
                    AutoCarrotDB.wasAutoDisabled = true
                end
            else
                if (not AutoCarrotDB.enabled and AutoCarrotDB.wasAutoDisabled) then
                    AutoCarrotButton:Click()
                end
            end
        end
        hasEnteredWorld = true
        CROP_OR_CARROT_ID = nil
        local itemId = GetInventoryItemID("player", 13)
        if(itemId == 25653 or itemId == 32863) then
            CROP_OR_CARROT_ID = itemId
            AutoCarrotDB.trinketSlot1 = true
            AutoCarrotDB.enchantHandsLink = nil
            AutoCarrotDB.enchantBootsLink = nil
            return
        elseif(itemId == 11122) then
            CROP_OR_CARROT_ID = 11122
            AutoCarrotDB.trinketSlot1 = true
        end
        itemId = GetInventoryItemID("player", 14)
        if(itemId == 25653 or itemId == 32863) then
            CROP_OR_CARROT_ID = itemId
            AutoCarrotDB.trinketSlot1 = false
            AutoCarrotDB.enchantHandsLink = nil
            AutoCarrotDB.enchantBootsLink = nil
            AutoCarrotDB.handsLink = nil
            AutoCarrotDB.bootsLink = nil
            return
        elseif(itemId == 11122) then
            CROP_OR_CARROT_ID = 11122
            AutoCarrotDB.trinketSlot1 = false
        end
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 0, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if(link) then
                    local sItemId, enchantId = link:match("item:(%d+):(%d*)")
                    if(sItemId == "25653" or sItemId == "32863") then
                        CROP_OR_CARROT_ID = tonumber(sItemId)
                        AutoCarrotDB.enchantHandsLink = nil
                        AutoCarrotDB.enchantBootsLink = nil
                        AutoCarrotDB.handsLink = nil
                        AutoCarrotDB.bootsLink = nil
                        return
                    elseif(sItemId == "11122") then
                        CROP_OR_CARROT_ID = 11122
                    elseif(enchantId == "930") then -- riding gloves
                        AutoCarrotDB.enchantHandsLink = "item:"..sItemId..":930:"
                    elseif(enchantId == "464") then -- mithril spurs
                        AutoCarrotDB.enchantBootsLink = "item:"..sItemId..":464:"
                    end
                end
            end
        end
    end
end)

function AutoCarrot_EquipNormalSet()
    if(InCombatLockdown() or UnitIsDeadOrGhost("player")) then return end

    if(AutoCarrotDB.trinketId) then
        EquipItemByName(AutoCarrotDB.trinketId, AutoCarrotDB.trinketSlot1 and 13 or 14)
    end
    if(AutoCarrotDB.handsLink) then
        EquipItemByName(AutoCarrotDB.handsLink, 10)
    end
    if(AutoCarrotDB.bootsLink) then
        EquipItemByName(AutoCarrotDB.bootsLink, 8)
    end
    if(AutoCarrotDB.beltId) then
        EquipItemByName(AutoCarrotDB.beltId, 6)
    end
    if(AutoCarrotDB.headId) then
        EquipItemByName(AutoCarrotDB.headId, 1)
    end
end

-- Print handler
function AutoCarrot_Print(msg)
    print("|cff00ff00Auto|cffed9121Carrot|r: "..(msg or ""))
end

function AutoCarrot_OnLoad()
    if AutoCarrotDB.enabled then
        AutoCarrotButton.overlay:SetColorTexture(0, 1, 0, 0.3)
    else
        AutoCarrotButton.overlay:SetColorTexture(1, 0, 0, 0.5)
    end
    if AutoCarrotDB.button then 
        AutoCarrotButton:Show() 
    else
        AutoCarrotButton:Hide() 
    end
    
    AutoCarrotButton:SetScale(AutoCarrotDB.buttonScale or 1)
end

-- Slash handler
local function OnSlash(key, value, ...)
    if key and key ~= "" then
        if key == "enabled" then
            if value == "toggle" or tonumber(value) then
                if value == "toggle" then
                    AutoCarrotButton:Click()
                elseif AutoCarrotDB.enabled ~= (tonumber(value) == 1 and true or false) then
                    AutoCarrotButton:Click()
                end
                AutoCarrot_Print("'enabled' set: "..( AutoCarrotDB.enabled and "1" or "0" ))
            else
                AutoCarrot_Print("'enabled' = "..( AutoCarrotDB.enabled and "1" or "0" ))
            end
        elseif key == "ridinggloves" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.ridingGloves = enable
                AutoCarrot_Print("'ridingGloves' set: "..( enable and "1" or "0" ))
            else
                AutoCarrot_Print("'ridingGloves' = "..( AutoCarrotDB.ridingGloves and "1" or "0" ))
            end
        elseif key == "mithrilspurs" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.mithrilSpurs = enable
                AutoCarrot_Print("'mithrilSpurs' set: "..( enable and "1" or "0" ))
            else
                AutoCarrot_Print("'mithrilSpurs' = "..( AutoCarrotDB.mithrilSpurs and "1" or "0" ))
            end

        elseif key == "swimbelt" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.swimBelt = enable
                AutoCarrot_Print("'swimBelt' set: "..( enable and "1" or "0" ))
            else
                AutoCarrot_Print("'swimBelt' = "..( AutoCarrotDB.swimBelt and "1" or "0" ))
            end
        elseif key == "swimhelm" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.swimHelm = enable
                AutoCarrot_Print("'swimHelm' set: "..( enable and "1" or "0" ))
            else
                AutoCarrot_Print("'swimHelm' = "..( AutoCarrotDB.swimHelm and "1" or "0" ))
            end
        elseif key == "instance" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.instance = enable
                AutoCarrot_Print("'instance' set: "..( enable and "1" or "0" ))
            else
                AutoCarrot_Print("'instance' = "..( AutoCarrotDB.instance and "1" or "0" ))
            end
        elseif key == "button" then
            if tonumber(value) then
                local enable = tonumber(value) == 1 and true or false
                AutoCarrotDB.button = enable
                AutoCarrot_Print("'button' set: "..( enable and "1" or "0" ))
                AutoCarrot_OnLoad()
            elseif value == "reset" then
                AutoCarrotButton:ClearAllPoints()
                AutoCarrotButton:SetPoint("CENTER")
                AutoCarrotDB.buttonScale = 1
                AutoCarrot_OnLoad()
                AutoCarrot_Print("Button position/scale reset.")
            elseif value == "scale" then
                local arg2 = ...
                if tonumber(arg2) then
                    AutoCarrotDB.buttonScale = arg2
                    AutoCarrot_Print("'buttonScale' set: "..AutoCarrotDB.buttonScale)
                    AutoCarrot_OnLoad()
                else
                    AutoCarrot_Print("'buttonScale' = "..AutoCarrotDB.buttonScale or "1.0")
                    AutoCarrot_Print("Usage: /autocarrot button scale 1.0")
                end
            else
                AutoCarrot_Print("'button' = "..( AutoCarrotDB.button and "1" or "0" ))
            end   
        end
    else
        AutoCarrot_Print("Slash commands")
        AutoCarrot_Print(" - enabled 0/1/toggle ("..(AutoCarrotDB.enabled and "1" or "0")..")")
        AutoCarrot_Print(" - ridingGloves 0/1 ("..(AutoCarrotDB.ridingGloves and "1" or "0")..")")
        AutoCarrot_Print(" - mithrilSpurs 0/1 ("..(AutoCarrotDB.mithrilSpurs and "1" or "0")..")")
        AutoCarrot_Print(" - swimBelt 0/1 ("..(AutoCarrotDB.swimBelt and "1" or "0")..")")
        AutoCarrot_Print(" - swimHelm 0/1 ("..(AutoCarrotDB.swimHelm and "1" or "0")..")")
        AutoCarrot_Print(" - instance 0/1 ("..(AutoCarrotDB.instance and "1" or "0")..")")
        AutoCarrot_Print(" - button 0/1/reset/scale ("..(AutoCarrotDB.button and "1" or "0")..")")
    end
end

SLASH_AUTOCARROT1 = "/autocarrot";
SLASH_AUTOCARROT2 = "/ac";
SlashCmdList["AUTOCARROT"] = function(msg)
    msg = string.lower(msg)
    msg = { string.split(" ", msg) }
    if #msg >= 1 then
        local exec = table.remove(msg, 1)
        OnSlash(exec, unpack(msg))
    end
end

AutoCarrotButton = CreateFrame("Button", "AutoCarrotButton", UIParent, "ActionButtonTemplate")
AutoCarrotButton.icon:SetTexture(134010)
AutoCarrotButton:SetPoint("CENTER")
AutoCarrotButton.overlay = AutoCarrotButton:CreateTexture(nil, "OVERLAY")
AutoCarrotButton.overlay:SetAllPoints(AutoCarrotButton)
AutoCarrotButton:RegisterForDrag("LeftButton")
AutoCarrotButton:SetMovable(true)
AutoCarrotButton:SetUserPlaced(true)
AutoCarrotButton:SetScript("OnDragStart", function() if IsAltKeyDown() then AutoCarrotButton:StartMoving() end end)
AutoCarrotButton:SetScript("OnDragStop", AutoCarrotButton.StopMovingOrSizing)
AutoCarrotButton:SetScript("OnClick", function()
    if AutoCarrotDB.enabled then
        AutoCarrotButton.overlay:SetColorTexture(1, 0, 0, 0.5)
        AutoCarrotDB.enabled = false
        AutoCarrot_EquipNormalSet()
    else
        AutoCarrotButton.overlay:SetColorTexture(0, 1, 0, 0.3)
        AutoCarrotDB.enabled = true
    end
    AutoCarrotDB.wasAutoDisabled = false
end)
