-- Role Giver Addon

-- Author: epic_y
--Version: 1.1.2
-- Features

-- Max Team Limit 
-- Cooldown Mechanism (for the player)


-- how to use
-- edit the 4 locals below this comment.
-- make sure to have a interactable named and name it exactly in the part name after parenthesis.

local COOLDOWN_TIME = 30 -- Cooldown for per role cuz we dont want bozos spamming
local TARGET_TEAM_LIMIT = "inf" -- inf is for any amount, any number is for a specific amount.
local PART_NAME = "REPLACE" -- change this to ur part name for the interactable to work.
local TARGET_TEAM_NAME = "REPLACE" -- change this so it teams you lol


-- do not touch ANYTHING BELOW if your in-experience/insanely stupid/have no knowledge of lua/scprp sandbox
-- only edit if you know what your doing! changing anything may cause bugs!

local cooldowns = {} -- store each player's last interaction time

event("interaction", function(Data)
    local player = Data.Value[1]
    local part   = Data.Value[2]

    if part == PART_NAME then
        local currentTime = os.time()
        local lastInteractionTime = cooldowns[player] or 0

        -- if player is on cooldown
        if currentTime - lastInteractionTime >= COOLDOWN_TIME then
            local currentTeamName, _ = getTeam(player)

            if currentTeamName == TARGET_TEAM_NAME then
                return
            end

            -- if the team has an open slot
            local teamMembers = getTeamMembers(TARGET_TEAM_NAME)
            local currentTeamSize = #teamMembers

            if TARGET_TEAM_LIMIT ~= "inf" and currentTeamSize >= tonumber(TARGET_TEAM_LIMIT) then
                return
            end
            
           
            setTeam(player, TARGET_TEAM_NAME)
            cooldowns[player] = currentTime
        else
            
            return
        end
    end
end)
