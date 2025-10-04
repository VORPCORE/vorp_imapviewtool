local LIB <const> = Import '/imaps_with_coords_and_heading'
local Core <const> = exports.vorp_core:GetCore()
local ACTIVATED = false
local CLOSEST_IPLS <const> = {}
local CLOSEST_IPLS_ARRAY <const> = {}
local SELECTED_INDEX = 1
local DISTANCE = 20.0
local Key1 <const> = "INPUT_DOCUMENT_PAGE_PREV"
local Key2 <const> = "INPUT_DOCUMENT_PAGE_NEXT"
local Key3 <const> = "INPUT_INTERACT_ANIMAL"

print("^1DO NOT USE THIS SCRIPT IN LIVE SERVERS^7")

local function DEC_HEX(decimal)
    return string.format("0x%X", decimal)
end

local function drawText3D(x, y, z, text, r, g, b, a, scale_multiplier, font)
    local onScreen <const>, _x <const>, _y <const> = GetScreenCoordFromWorldCoord(x, y, z)
    local dist <const> = #(GetGameplayCamCoord() - vector3(x, y, z))
    if scale_multiplier == nil then
        scale_multiplier = 2
    end
    local scale       = (1 / dist) * scale_multiplier
    local fov <const> = (1 / GetGameplayCamFov()) * 100
    scale             = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        BgSetTextColor(r, g, b, a)
        SetTextFontForCurrentCommand(font)
        BgDisplayText(VarString(10, "LITERAL_STRING", text), _x, _y)
    end
end

local function findClosestIpls()
    while ACTIVATED do
        local sleep = 1000
        local startCoords <const> = GetEntityCoords(PlayerPedId())
        for imapHash, value in pairs(LIB.IPL_LIST) do
            local endCoords <const> = vec3(value.x, value.y, value.z)
            local distance <const> = #(startCoords - endCoords)
            if distance <= DISTANCE then
                if not CLOSEST_IPLS[imapHash] then
                    CLOSEST_IPLS[imapHash] = value
                end
            else
                CLOSEST_IPLS[imapHash] = nil
            end
        end

        table.wipe(CLOSEST_IPLS_ARRAY)
        for hash, value in pairs(CLOSEST_IPLS) do
            table.insert(CLOSEST_IPLS_ARRAY, { hash = hash, data = value })
        end

        table.sort(CLOSEST_IPLS_ARRAY, function(a, b)
            local distA = #(startCoords - vec3(a.data.x, a.data.y, a.data.z))
            local distB = #(startCoords - vec3(b.data.x, b.data.y, b.data.z))
            return distA < distB
        end)

        if SELECTED_INDEX > #CLOSEST_IPLS_ARRAY then
            SELECTED_INDEX = #CLOSEST_IPLS_ARRAY
        end

        if SELECTED_INDEX < 1 and #CLOSEST_IPLS_ARRAY > 0 then
            SELECTED_INDEX = 1
        end

        Wait(sleep)
    end
end

local function drawIplView()
    Core.NotifyObjective("IPL VIEWER IS ACTIVATED", 3000)
    Core.NotifyTip(("press ~%s~ and ~%s~ to scroll and ~%s~ to toggle selected"):format(Key1, Key2, Key3), -1)
    CreateThread(findClosestIpls)

    local red <const>    = { r = 255, g = 0, b = 0, a = 255 }
    local green <const>  = { r = 0, g = 255, b = 0, a = 255 }
    local yellow <const> = { r = 255, g = 255, b = 0, a = 255 }
    while ACTIVATED do
        local sleep = 1000
        local startCoords <const> = GetEntityCoords(PlayerPedId())

        if #CLOSEST_IPLS_ARRAY > 0 then
            sleep = 0

            for index, entry in ipairs(CLOSEST_IPLS_ARRAY) do
                local hash <const> = entry.hash
                local hashString <const> = DEC_HEX(hash)
                local value <const> = entry.data
                local endCoords <const> = vec3(value.x, value.y, value.z)
                local distance <const> = #(startCoords - endCoords)

                if distance <= DISTANCE then
                    local name <const> = value.hashname or "Unknown"


                    local color = red
                    if IsIplActiveByHash(hash) == 1 then
                        color = green
                    end

                    if index == SELECTED_INDEX then
                        color = yellow
                        DrawLine(startCoords.x, startCoords.y, startCoords.z, endCoords.x, endCoords.y, endCoords.z, color.r, color.g, color.b, 255)
                        drawText3D(endCoords.x, endCoords.y, endCoords.z, "[SELECTED " .. index .. "/" .. #CLOSEST_IPLS_ARRAY .. "] | HASH: " .. hashString .. " | NAME: " .. name, color.r, color.g, color.b, 255, 9, 6)
                    else
                        DrawLine(startCoords.x, startCoords.y, startCoords.z, endCoords.x, endCoords.y, endCoords.z, color.r, color.g, color.b, 150)
                        drawText3D(endCoords.x, endCoords.y, endCoords.z, index .. " hash: " .. hashString .. " name: " .. name, color.r, color.g, color.b, 150, 9, 5)
                    end
                end
            end

            if IsControlJustPressed(0, joaat(Key1)) then
                SELECTED_INDEX = SELECTED_INDEX - 1
                if SELECTED_INDEX < 1 then
                    SELECTED_INDEX = #CLOSEST_IPLS_ARRAY
                end
                if CLOSEST_IPLS_ARRAY[SELECTED_INDEX] then
                    print("Selected IPL " .. SELECTED_INDEX .. "/" .. #CLOSEST_IPLS_ARRAY, "IsActive: ", IsIplActiveByHash(CLOSEST_IPLS_ARRAY[SELECTED_INDEX].hash))
                end
            end

            if IsControlJustPressed(0, joaat(Key2)) then
                SELECTED_INDEX = SELECTED_INDEX + 1
                if SELECTED_INDEX > #CLOSEST_IPLS_ARRAY then
                    SELECTED_INDEX = 1
                end
                if CLOSEST_IPLS_ARRAY[SELECTED_INDEX] then
                    print("Selected IPL " .. SELECTED_INDEX .. "/" .. #CLOSEST_IPLS_ARRAY, "IsActive: ", IsIplActiveByHash(CLOSEST_IPLS_ARRAY[SELECTED_INDEX].hash))
                end
            end

            if IsControlJustPressed(0, joaat(Key3)) then
                if CLOSEST_IPLS_ARRAY[SELECTED_INDEX] then
                    local selectedHash <const> = CLOSEST_IPLS_ARRAY[SELECTED_INDEX].hash
                    if IsIplActiveByHash(selectedHash) == 1 then
                        RemoveIplByHash(selectedHash)
                        print("Removed IPL: " .. DEC_HEX(selectedHash))
                    else
                        RequestIplByHash(selectedHash)
                        print("Loaded IPL: " .. DEC_HEX(selectedHash))
                    end
                end
            end
        end

        Wait(sleep)
    end
    Core.NotifyObjective("IPL VIEWER IS DEACTIVATED", 3000)
    UiFeedClearChannel(1, true, true)
end

TriggerEvent("chat:addSuggestion", "/removeAll", "Removes all ipls in view", {})
TriggerEvent("chat:addSuggestion", "/requestAll", "Requests all ipls in view", {})
TriggerEvent("chat:addSuggestion", "/testIpl", "Tests an ipl remove and add", {
    { name = "hash", help = "The hash of the ipl" }
})
TriggerEvent("chat:addSuggestion", "/toggleIplView", "Toggles the ipl viewer", {
    { name = "distance", help = "The distance to the ipls optional" }
})
TriggerEvent("chat:addSuggestion", "/iplDistanceView", "Sets the distance to the ipls", {
    { name = "distance", help = "The distance to the ipls in view" }
})

-- 2851576798 removes fog, but adds pile
local isActive = false
RegisterCommand("testIpl", function(s, args)
    local hash <const> = tonumber(args[1])
    local hashString <const> = DEC_HEX(hash)
    if isActive then
        isActive = false
        RequestIplByHash(hashString)
        print("Loaded IPL: " .. hashString)
    else
        isActive = true
        RemoveIplByHash(hashString)
        print("Removed IPL: " .. hashString)
    end
end, false)


-- remove all in view with command
RegisterCommand("removeAll", function(s, args)
    for _, ipl in ipairs(CLOSEST_IPLS_ARRAY) do
        RemoveIplByHash(ipl.hash)
    end
end, false)

-- add all in view with command
RegisterCommand("requestAll", function(s, args)
    for _, ipl in ipairs(CLOSEST_IPLS_ARRAY) do
        RequestIplByHash(ipl.hash)
    end
end, false)

-- command to stop and start
RegisterCommand("toggleIplView", function(s, args)
    ACTIVATED = not ACTIVATED

    if args[1] then
        DISTANCE = tonumber(args[1])
    end

    if ACTIVATED then
        drawIplView()
    end
end, false)

-- just distance
RegisterCommand("iplDistanceView", function(s, args)
    if not ACTIVATED then
        print("^1The ipl viewer is not activated^7")
        return
    end

    if not args[1] then
        print("^1You need to specify a distance^7")
        return
    end
    DISTANCE = tonumber(args[1])
end, false)
