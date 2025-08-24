----------------------------------------------------------------------
-- Pickpocket Addon
-- Author: epic_y
-- Version: 1.1.1
-- Features:
--  - limits to one single time (prisoner or smth)
--  - pickpocketting mechanic
--
-- Notes:
--  - this is supposed to be used like jailbreak but won't work since no client sided scp rp scripting yet.
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local CONFIG = {
  INTERACT_PART_NAME = "PickpocketStation", -- name used in event("interaction") Data.Value[2]
  ALLOWED_TEAM       = "CHANGEME",           -- e.g., "Prisoner" (team name from getTeam())
  ONE_TIME_ONLY      = true,                -- if true, player can succeed only once per session
}

------------------------------------------------------
-- Helpers
------------------------------------------------------
local function playerHasTool(name, toolList)
  if not toolList then return false end
  for _, t in ipairs(toolList) do
      if t == name then
          return true
      end
  end
  return false
end

------------------------------------------------------
-- State (per-session)
------------------------------------------------------
local GrantedOnce = {} -- [playerName] = true when ONE_TIME_ONLY is enabled and reward granted

------------------------------------------------------
-- Events
------------------------------------------------------
event("interaction", function(Data)
  local player = Data.Value[1]
  local part   = Data.Value[2]

  -- Only handle our configured interaction part
  if part ~= CONFIG.INTERACT_PART_NAME then
      return
  end

  -- Check team
  local teamName, _ = getTeam(player)
  if teamName ~= CONFIG.ALLOWED_TEAM then
      return
  end

  -- One-time limiter (optional)
  if CONFIG.ONE_TIME_ONLY and GrantedOnce[player] then
      return
  end

  -- Check inventory and decide reward
  local tools = getTools(player) or {}
  local hasPistol  = playerHasTool("Pistol", tools)
  local hasKeycard = playerHasTool("L2 Keycard", tools)

  local reward = nil
  if not hasPistol and not hasKeycard then
      local pool = {"Pistol", "L2 Keycard"}
      reward = pool[math.random(1, #pool)]
  elseif hasPistol and not hasKeycard then
      reward = "L2 Keycard"
  elseif not hasPistol and hasKeycard then
      reward = "Pistol"
  else
      return -- already has both
  end

  -- Grant reward
  if reward then
      giveTool(player, reward)
      if CONFIG.ONE_TIME_ONLY then
          GrantedOnce[player] = true
      end
  end
end)
