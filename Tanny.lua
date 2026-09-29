-- Tanny Script — สำหรับเกมของเราเองเท่านั้น
-- =============================================

local Tanny = {}
Tanny.Settings = {
    WalkSpeedBoost = 32,
    AutoPlaceInterval = 3,
    AutoStealRange = 15,
    AutoFarmSpeed = true
}

-- 🚀 เดินเร็ว
function Tanny.SetWalkSpeed(enabled)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = enabled and Tanny.Settings.WalkSpeedBoost or 16
    end
end

-- 🥚 วางไข่อัตโนมัติ
function Tanny.AutoPlaceEgg()
    while task.wait(Tanny.Settings.AutoPlaceInterval) do
        if not Tanny.Enabled then break end
        print("[Tanny] วางไข่อัตโนมัติ...")
        -- ใส่โค้ดวางไข่ตามระบบในเกมของเรา
    end
end

-- 🔁 ขโมย/เก็บไข่อัตโนมัติ
function Tanny.AutoStealEgg()
    while task.wait(1) do
        if not Tanny.Enabled then break end
        local myPos = game.Players.LocalPlayer.Character and 
                      game.Players.LocalPlayer.Character.PrimaryPart and
                      game.Players.LocalPlayer.Character.PrimaryPart.Position
        if not myPos then continue end
        
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant.Name == "Egg" and descendant:IsA("BasePart") then
                local dist = (descendant.Position - myPos).Magnitude
                if dist < Tanny.Settings.AutoStealRange then
                    print("[Tanny] พบไข่ ระยะ " .. math.floor(dist) .. " หน่วย → เก็บแล้ว")
                    -- ใส่โค้ดเก็บไข่ตามระบบในเกมของเรา
                end
            end
        end
    end
end

-- ⚡ ฟาร์มความเร็วอัตโนมัติ
function Tanny.AutoFarmSpeed()
    while task.wait(5) do
        if not Tanny.Enabled or not Tanny.Settings.AutoFarmSpeed then break end
        print("[Tanny] อัปเกรดความเร็ว/ฟาร์ม...")
        -- ใส่โค้ดอัปเกรดความเร็วตามระบบในเกมของเรา
    end
end

-- ▶️ เริ่มทำงาน
function Tanny.Start()
    Tanny.Enabled = true
    Tanny.SetWalkSpeed(true)
    task.spawn(Tanny.AutoPlaceEgg)
    task.spawn(Tanny.AutoStealEgg)
    task.spawn(Tanny.AutoFarmSpeed)
    print("[Tanny] ทำงานเรียบร้อย ✅")
end

-- ⏹️ หยุดทำงาน
function Tanny.Stop()
    Tanny.Enabled = false
    Tanny.SetWalkSpeed(false)
    print("[Tanny] หยุดทำงานแล้ว ⏹️")
end

-- เริ่มทำงานทันที
Tanny.Start()

-- ส่งออกไปใช้งาน
return Tanny
