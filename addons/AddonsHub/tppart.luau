f("Part").Touched:Connect(function(Player) -- You can change the "Part".
    if Player then
        setPlayerPosition(Player, f("Part").CFrame)
    end
end)
