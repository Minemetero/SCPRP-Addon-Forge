----------------------------------------------------------------------
-- Chat Command: Custom announce
-- Author: AddonsHub
-- Version: 1.0.0
-- Features:
--  - Listens for a chat command to send an announcement
--  - Optional sound playback by asset id
--  - Configurable authorized users & command keyword
--
-- Notes:
--  - Example usage in chat:
--      :cannounce|Hello everyone!|157636218
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local CONFIG = {
  AUTHORIZED_USER = "YTBr_KralKayraGeldi1", -- who can run the command
  COMMAND        = ":cannounce",            -- command keyword
  DELIMITER      = "|",                     -- field separator
}

-- Minimal helper
local function startswith(s, prefix)
  if type(s) ~= "string" or type(prefix) ~= "string" then return false end
  return s:sub(1, #prefix) == prefix
end

------------------------------------------------------
-- Chatted event
------------------------------------------------------
event("chatted", function(Data)
  local player = Data.Value[1]
  local msg = Data.Value[2]

  if player == CONFIG.AUTHORIZED_USER then
      if startswith(msg, CONFIG.COMMAND) then
          -- Example: :cannounce|Hello everyone!|157636218
          local parts = {}
          for part in string.gmatch(msg, "[^" .. CONFIG.DELIMITER .. "]+") do
              table.insert(parts, part)
          end

          local announceMsg = parts[2] -- second argument: Message
          local soundId = parts[3]     -- third argument: ID

          announce(announceMsg) -- Announce

          if soundId then
              local Sound = Instance.new("Sound")
              Sound.SoundId = "rbxassetid://" .. soundId -- Play the sound id
              playSound(Sound)
          end
      end
  end
end)
