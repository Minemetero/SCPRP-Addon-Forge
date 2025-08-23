f("Part").Touched:Connect(function(Player) -- You can change the "Part".
    if Player then
        kill(Player) -- Kills the player.
    end
end)