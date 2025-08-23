----------------------------------------------------------------------
-- Accelerated Day Cycle
-- Author: minemetero
-- Version: 1.0.0
-- Features:
--  - Adjustable speed multiplier (faster day/night)
--  - Wraps back at 24 hours to stay valid
--
-- Note:
-- This addon is modified from the official day/night example
-- provided in the SCP:RP Server Addons documentation.
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local RATE = 20   -- speed multiplier

------------------------------------------------------
-- Cycle Loop
------------------------------------------------------
task.spawn(function()
    while true do
        local dt = task.wait()
        local newTime = getClockTime() + dt * RATE

        -- Wrap to 0–24 range
        if newTime >= 24 then
            newTime = newTime - 24
        elseif newTime < 0 then
            newTime = newTime + 24
        end

        setClockTime(newTime)
    end
end)
