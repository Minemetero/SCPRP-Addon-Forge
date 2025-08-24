----------------------------------------------------------------------
-- Touch-To-Teleport
-- Author: addonshub(edit:minemetero)
-- Version: 1.0.1
-- Features:
--  - When a player touches a configured Part, teleport them
--  - Teleports the player to the CFrame of the configured Part
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local CONFIG = {
  PART_NAME = "Part", -- the part that triggers teleport
}

------------------------------------------------------
-- Setup
------------------------------------------------------
local trigger = f(CONFIG.PART_NAME)
if not trigger then
  return -- stop if the part doesn’t exist
end

------------------------------------------------------
-- Events
------------------------------------------------------
trigger.Touched:Connect(function(playerName)
  if playerName then
      setPlayerPosition(playerName, trigger.CFrame)
  end
end)
