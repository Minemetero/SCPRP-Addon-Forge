----------------------------------------------------------------------
-- Role Giver Addon
-- Author: epic_y
-- Version: 1.1.2
-- Features:
--  - Max Team Limit
--  - Cooldown Mechanism (for the player)
--
-- NOTES:
--  - how to use
--  - edit the 4 locals below this comment.
--  - make sure to have a interactable named and name it exactly in the part name after parenthesis.
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local COOLDOWN_TIME = 30            -- Cooldown for per role cuz we dont want bozos spamming
local TARGET_TEAM_LIMIT = "inf"     -- inf is for any amount, any number is for a specific amount.
local PART_NAME = "REPLACE"         -- change this to ur part name for the interactable to work.
local TARGET_TEAM_NAME = "REPLACE"  -- change this so it teams you lol

------------------------------------------------------
-- State
------------------------------------------------------
local cooldowns = {} -- store each player's last interaction time

------------------------------------------------------
-- Events
------------------------------------------------------
event("interaction", function(Data)
    local player = Data.Value[1]
    local part   = Data.Value[2]

    if part ~= PART_NAME then
        return
    end

    local now = os.time()
    local last = cooldowns[player] or 0

    -- respect cooldown
    if now - last < COOLDOWN_TIME then
        return
    end

    -- already on target team? do nothing
    local currentTeamName, _ = getTeam(player)
    if currentTeamName == TARGET_TEAM_NAME then
        return
    end

    -- team capacity check
    if TARGET_TEAM_LIMIT ~= "inf" then
        local limit = tonumber(TARGET_TEAM_LIMIT)
        if limit and limit >= 0 then
            local members = getTeamMembers(TARGET_TEAM_NAME) or {}
            local size = #members
            if size >= limit then
                return
            end
        end
    end

    -- assign team and update cooldown
    setTeam(player, TARGET_TEAM_NAME)
    cooldowns[player] = now
end)
