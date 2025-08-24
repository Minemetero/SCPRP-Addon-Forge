----------------------------------------------------------------------
-- AntiCheat Addon (Advanced)
-- Author: epic_y (edit: minemetero)
-- Version: 1.2.0
-- Features:
--  - Detects suspicious movement spikes (speed / noclip-like teleports)
--  - Lagback on first/second detection within a window
--  - AAGUN mechanic: third detection within window = kill
--  - Configurable speed limit, check interval, and reset window
--
-- Notes:
--  - This addon relies on movement spike detection (speed across checks).
--  - No engine raycasts are used (sandbox limitation); keeps logic simple & safe.
--  - Test and tune MAX_WALK_SPEED and multipliers for your server.
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local NOCLIP_RESET_SECONDS     = 30    -- resets detection counters after this many seconds
local ANTICHEAT_CHECK_INTERVAL = 0.20  -- seconds between checks
local MAX_WALK_SPEED           = 45    -- base walk/run speed (studs/sec)

-- How aggressive the detector is:
local SPEED_MULTIPLIER_SUSPECT = 1.75  -- > base * this = suspicious (lagback)
local SPEED_MULTIPLIER_KILL    = 3.50  -- > base * this = count 2 detections at once

-- If true, only update "lastValidPosition" when movement looks legit (prevents saving bad spots)
local ONLY_SAVE_WHEN_LEGIT     = true

------------------------------------------------------
-- Helpers
------------------------------------------------------
local function v3(pos)
    -- get Vector3 from Vector3 or CFrame
    if typeof(pos) == "Vector3" then return pos end
    if typeof(pos) == "CFrame" then return pos.Position end
    return nil
end

local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

------------------------------------------------------
-- State
------------------------------------------------------
local anticheatData = {}  -- [playerName] = { lastPos, lastCheck, count, lastDetect }

------------------------------------------------------
-- Main Loop
------------------------------------------------------
task.spawn(function()
    while true do
        local tickStart = os.clock()

        -- Build presence set to purge leavers later
        local present = {}
        for _, name in ipairs(getPlayers()) do
            present[name] = true

            -- Skip players not spawned (API returns -1)
            local hp = getPlayerHealth(name)
            if hp and hp >= 0 then
                -- Init per-player state
                local st = anticheatData[name]
                if not st then
                    st = {
                        lastPos    = v3(getPlayerPosition(name)),
                        lastCheck  = os.clock(),
                        count      = 0,
                        lastDetect = 0,
                    }
                    anticheatData[name] = st
                end

                local now     = os.clock()
                local current = v3(getPlayerPosition(name))
                local last    = st.lastPos
                local dt      = now - st.lastCheck

                if current and last and dt > 0 then
                    local distance = (current - last).Magnitude
                    local speed    = distance / dt

                    -- Reset stale counters after window
                    if (now - st.lastDetect) >= NOCLIP_RESET_SECONDS then
                        st.count = 0
                    end

                    -- Thresholds
                    local suspect = MAX_WALK_SPEED * SPEED_MULTIPLIER_SUSPECT
                    local instant = MAX_WALK_SPEED * SPEED_MULTIPLIER_KILL

                    local flagged = false
                    local severity = 0

                    if speed > suspect then
                        flagged = true
                        severity = 1
                        if speed > instant then
                            -- Very large spike: count as two detections at once
                            severity = 2
                        end
                    end

                    if flagged then
                        st.count = st.count + severity
                        st.lastDetect = now

                        if st.count <= 2 then
                            -- Lagback
                            if st.lastPos then
                                setPlayerPosition(name, st.lastPos)
                            end
                        else
                            -- AAGUN mechanic: kill, then reset counter window
                            kill(name)
                            st.count = 0
                            st.lastDetect = now
                        end
                    end

                    -- Save last valid pos
                    if (not ONLY_SAVE_WHEN_LEGIT) or (speed <= suspect) then
                        st.lastPos = current
                    end
                else
                    -- No current or no last; seed state
                    st = st or { }
                    st.lastPos   = current or st.lastPos
                end

                -- Update checkpoint time
                anticheatData[name].lastCheck = now
            else
                -- Not spawned: clear their state so we don't hold stale positions
                anticheatData[name] = nil
            end
        end

        -- Purge players who left
        for pname in pairs(anticheatData) do
            if not present[pname] then
                anticheatData[pname] = nil
            end
        end

        -- Pace the loop
        local elapsed = os.clock() - tickStart
        local waitFor = ANTICHEAT_CHECK_INTERVAL - elapsed
        if waitFor < 0 then waitFor = 0 end
        task.wait(waitFor)
    end
end)
