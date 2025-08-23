f("Part").Touched:Connect(function(Player) -- You can change the "Part".
    if Player then
        setTeam(Player.Name, "MyTeam") -- Team that player will be teamed to. (CHANGE THIS!)
        kill(Player) -- Kills the player.
    end
end)
