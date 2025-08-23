----------------------------------------------------------------------
-- <Name>
-- Author: <your-username>
-- Version: 1.0.0
-- Features:
--  - <bullet>
--  - <bullet>
--  - <bullet>
--  - <bullet>
----------------------------------------------------------------------

------------------------------------------------------
-- Events
------------------------------------------------------

event("joined", function(data)
    local player = data.Value
    print(player .. " joined")
end)

------------------------------------------------------
-- Loops
------------------------------------------------------

task.spawn(function()
    while true do
        -- Example loop logic
        task.wait(1)
    end
end)
