Total_Nuked = 0
nuked = false

function warp(world)
    local negro = 0
    while getBot():getWorld().name:upper() ~= world:upper() and not nuked do
        getBot():sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
        sleep(MADS.DelayWArp)
        if negro == 5 then
            nuked = true
        else
            negro = negro + 1
        end
    end
end
local function log(text) 
    if MADS.Input_Txt then
        file = io.open("WORLD STATUS.txt", "a")
        file:write(text.."\n")
        file:close()
    end
end
local function scanFossil()
    local count = 0
    for index,fosil in pairs(getBot():getWorld():getTiles()) do
        if fosil.fg == 3918 then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function scanReady(id)
    local count = 0
    for index,tile in pairs(getBot():getWorld():getTiles()) do
        if tile.fg == id and tile:canHarvest(tile.x,tile.y) then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function UnReady(id)
    local count = 0
    for index,tile in pairs(getBot():getWorld():getTiles()) do
        if tile.fg == id and not tile:canHarvest(tile.x,tile.y) then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function infokan(description)
    if MADS.Input_Webhook then
        local script = [[
            $webHookUrl = "]]..MADS.Webhook..[["
            $content = "]]..description..[["
            $payload = @{
                content = $content 
            }
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
        ]]
        local pipe = io.popen("powershell -command -", "w")
        pipe:write(script)
        pipe:close()
    end
end
log("-----------------------------------------------")
while true do
    for index,farm in pairs(MADS.FarmList) do
        warp(farm)
        if not nuked then
            treek = scanReady(MADS.Tree)
            sleep(math.ceil(MADS.DelayAfk / 3))
            treeks = UnReady(MADS.Tree)
            sleep(math.ceil(MADS.DelayAfk / 3))
            posil = scanFossil()
            sleep(math.ceil(MADS.DelayAfk / 3))
            log(farm:upper().." SAFE | ".."[ "..treek.." Ready & "..treeks.." Not Ready ] | "..posil.." Fossil")
            infokan(farm:upper().." SAFE | ".."[ "..treek.." Ready & "..treeks.." Not Ready ] | "..posil.." Fossil")
            sleep(100)
        else
            log(farm:upper().." | NUKED")
            infokan(farm:upper().." | NUKED")
            sleep(100)
            nuked = false
            Total_Nuked = Total_Nuked + 1
        end
    end
    if not MADS.Loop then
        infokan("Total Nuked "..Total_Nuked.." World")
        log("Total Nuked "..Total_Nuked.." World\n")
        break
    end
end
