----------------------------------------------------------------------
-- Touch-To-Team
-- Author: addonshub (edited: minemetero)
-- Version: 2.0.1
-- Features:
--  - When a player touches a configured Part, set their team
--  - Kill to force respawn, then restore previous position
--  - Configurable part name, team name, and respawn wait
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local CONFIG = {
  PART_NAME = "Part",        -- the touch trigger part's name
  TEAM_NAME = "MyTeam",      -- team to assign on touch
  RESPAWN_WAIT_SECONDS = 3,  -- time to wait for respawn before restoring position
}

------------------------------------------------------
-- Setup
------------------------------------------------------
local trigger = f(CONFIG.PART_NAME)
if not trigger then
  -- No such part in the map; nothing to wire up.
  return
end

------------------------------------------------------
-- Events
------------------------------------------------------
trigger.Touched:Connect(function(playerName)
  if not playerName then
      return
  end

  -- Assign team (before or after respawn both work; keeping original flow)
  setTeam(playerName, CONFIG.TEAM_NAME)

  -- Remember old position, then force respawn
  local oldPos = getPlayerPosition(playerName)
  kill(playerName)

  -- Wait for the player to respawn before restoring position
  task.wait(CONFIG.RESPAWN_WAIT_SECONDS)

  -- Restore position (works with Vector3 or CFrame as returned)
  if oldPos then
      setPlayerPosition(playerName, oldPos)
  end
end)
