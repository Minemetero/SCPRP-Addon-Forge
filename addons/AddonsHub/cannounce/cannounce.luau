local function startswith(str, start)
    return string.sub(str, 1, #start) == start
end

-- Chatted event
event("chatted", function(Data)
    local player = Data.Value[1]
    local msg = Data.Value[2]

    if player == "YTBr_KralKayraGeldi1" then -- Change it to the person who is able to do the announcement.
        if startswith(msg, ":cannounce") then
            -- Example Command: :cannounce|Hello everyone!|157636218
            local parts = {}
            for part in string.gmatch(msg, "[^|]+") do
                table.insert(parts, part)
            end

            local announceMsg = parts[2] -- second arguement: Message
            local soundId = parts[3] -- third arguement: ID

            announce(announceMsg) -- Announce

            if soundId then
                local Sound = Instance.new("Sound")
                Sound.SoundId = "rbxassetid://" .. soundId -- Play the sound id
                playSound(Sound)
            end
        end
    end
end)
