-- Pickpocket Addon 
-- Author: epic_y
-- Version: 1.0.1





-- this is supposed to be used like jailbreak but won't work since no client sided scp rp scripting yet.



--updates: announcing does not work since its bugged, will have a purpose in a diff update.

local ALLOWED_TEAM = "replace" -- replace so only (prisoner/specific team can do the pickpocketting)



-- DO NOT EDIT ANYTHING BELOW IF YOU DON'T KNOW WHAT YOUR DOING! (aside from the replace part)

event("interaction", function(Data)
    local player = Data.Value[1]
    local part   = Data.Value[2]

    if part == "REPLACE" then --edit REPLACE to the partname for ur pickpocketting interactable name.
        local teamName, _ = getTeam(player)

        
        if teamName == ALLOWED_TEAM then
            
            local playerTools = getTools(player)
            local hasPistol = false
            local hasKeycard = false

            for i, toolName in ipairs(playerTools) do
                if toolName == "Pistol" then
                    hasPistol = true
                elseif toolName == "L2 Keycard" then
                    hasKeycard = true
                end
            end

            local reward = nil

            if not hasPistol and not hasKeycard then
                local rewards = {"Pistol", "L2 Keycard"}
                reward = rewards[math.random(1, #rewards)]
            elseif hasPistol and not hasKeycard then
                reward = "L2 Keycard"
            elseif not hasPistol and hasKeycard then
                reward = "Pistol"
            end




            -- i thought this was working but it doesn't work.
            if reward then
                giveTool(player, reward)
                announce(player .. " successfully pickpocketed and got a " .. reward .. "!", player)
            else
                announce(player .. ", you already have both items.", player)
            end
        else
            announce(player .. ", you are not authorized to pickpocket.", player)
        end
    end
end)
