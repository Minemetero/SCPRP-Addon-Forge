--------------------------------------------------------------------------------------------------------------------
-- AntiCheat Addon (Advanced)
-- Author: epic_y
-- Version: 1.1.2

-- Features

-- Noclip Lagback (will lagback if you got caught noclipping/suspected)
-- AAGUN Mechanic (Kills you instantly if you triggered it more then 2 times)
-- Max Walkspeed to see if any speed hacks or so.



-- NOTES:
--how to use
-- edit the 3 locals below (if you want to)
-- its ready and set to use you just need to paste in

-- WARNING THIS SCRIPT HAS NOT BEEN TESTED YET!! (for obvious reason, mostly no exploiters to test it lol)
----------------------------------------------------------------------------------------------------------------------

local NOCLIP_RESET_SECONDS = 30 -- time to reset lagback (to prevent aagun)
local ANTICHEAT_CHECK_INTERVAL = 0.2 -- how much should it check per second (prevent ratelimiting/bugging)
local MAX_WALK_SPEED = 45 --standard walkspeed/run speed in scp rp


-- DO NOT TOUCH/EDIT/MODIFY ANYTHING BELOW IF YOU DO NOT KNOW WHAT YOUR DOING!

local anticheatData = {}

task.spawn(function()
    while true do
        local players = getPlayers()
        local playersInGame = {}
        for _, name in ipairs(players) do
            playersInGame[name] = true
            
        
            if not anticheatData[name] then
                anticheatData[name] = {
                    noclipCount = 0,
                    lastNoclipTime = 0,
                    lastValidPosition = getPlayerPosition(name)
                }
            end

            local playerData = anticheatData[name]
            local currentPosition = getPlayerPosition(name)
            local lastPosition = playerData.lastValidPosition

            if lastPosition and currentPosition then
                
                local direction = currentPosition - lastPosition
                local distance = direction.Magnitude
                local speed = distance / ANTICHEAT_CHECK_INTERVAL

            
                if speed > MAX_WALK_SPEED then
                    local ray = Ray.new(lastPosition, direction)
                    local hitPart = workspace.Raycast(ray)
                    
                   
                    if hitPart then
                        playerData.noclipCount += 1
                        playerData.lastNoclipTime = os.time()
                        
                        if playerData.noclipCount <= 2 then
                            setPlayerPosition(name, playerData.lastValidPosition)
                        else
                            kill(name)
                            playerData.noclipCount = 0
                            playerData.lastNoclipTime = os.time()
                        end
                    end
                end
            end
            
            if os.time() - playerData.lastNoclipTime >= NOCLIP_RESET_SECONDS then
                playerData.noclipCount = 0
            end
            
            
            playerData.lastValidPosition = currentPosition
        end
        
       
        for name in pairs(anticheatData) do
            if not playersInGame[name] then
                anticheatData[name] = nil
            end
        end
        
        task.wait(ANTICHEAT_CHECK_INTERVAL)
    end
end)
