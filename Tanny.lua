-- =====================================================
--  SCRIPT: tanny
--  ฟังก์ชัน: เดินเร็ว, วางไข่อัตโนมัติ, ขโมยไข่อัตโนมัติ, ฟาร์มความเร็วอัตโนมัติ
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ================= ตั้งค่าพื้นฐาน =================
local CONFIG = {
    WALK_SPEED = 80,          -- ความเร็วในการเดิน (ปรับได้ตามต้องการ)
    AUTO_PLACE = true,        -- เปิด/ปิด การวางไข่อัตโนมัติ
    AUTO_STEAL = true,        -- เปิด/ปิด การขโมยไข่อัตโนมัติ
    AUTO_FARM_SPEED = true,   -- เปิด/ปิด การฟาร์มความเร็วอัตโนมัติ
    FARM_SPEED_INTERVAL = 0.5 -- ระยะเวลาในการฟาร์มความเร็ว (วินาที)
}

-- ================= ฟังก์ชัน: เดินเร็ว =================
local function setWalkSpeed(speed)
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
        -- ป้องกันไม่ให้เกมรีเซ็ตค่า
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= speed then
                humanoid.WalkSpeed = speed
            end
        end)
    end
end

-- เรียกใช้เมื่อตัวละครเกิดใหม่
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    setWalkSpeed(CONFIG.WALK_SPEED)
end)

-- เรียกใช้ทันทีเมื่อรันสคริปต์
if LocalPlayer.Character then
    setWalkSpeed(CONFIG.WALK_SPEED)
end

print("[tanny] เปิดใช้งาน: เดินเร็ว (" .. CONFIG.WALK_SPEED .. ")")

-- ================= ฟังก์ชัน: วางไข่อัตโนมัติ =================
-- หมายเหตุ: ฟังก์ชันนี้ต้องปรับให้เข้ากับเกม "Steal an Egg" โดยเฉพาะ
-- โดยทั่วไปจะทำงานผ่านการกดปุ่มวางไข่ (Place) เมื่อมีไข่ในมือ
local function autoPlaceEgg()
    if not CONFIG.AUTO_PLACE then return end
    
    -- ตัวอย่าง: กดปุ่ม E หรือปุ่มที่ใช้วางไข่ (ปรับตามเกม)
    -- คุณสามารถใช้ VirtualInputManager หรือ KeyPress เพื่อจำลองการกดปุ่ม
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

-- ================= ฟังก์ชัน: ขโมยไข่อัตโนมัติ =================
-- หมายเหตุ: ฟังก์ชันนี้ต้องปรับให้เข้ากับเกม "Steal an Egg"
-- โดยทั่วไปจะทำงานเมื่อผู้เล่นอยู่ใกล้ไข่ของคนอื่นแล้วกดปุ่มขโมย (Steal)
local function autoStealEgg()
    if not CONFIG.AUTO_STEAL then return end
    
    -- ตัวอย่าง: กดปุ่ม F หรือปุ่มที่ใช้ขโมยไข่ (ปรับตามเกม)
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, "F", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "F", false, game)
end

-- ================= ฟังก์ชัน: ฟาร์มความเร็วอัตโนมัติ =================
local function autoFarmSpeed()
    if not CONFIG.AUTO_FARM_SPEED then return end
    
    -- ตัวอย่าง: เพิ่มความเร็วในการฟาร์มโดยการเดินไปมา
    -- หรือใช้การกดปุ่มเพื่อเพิ่มความเร็ว (ปรับตามเกม)
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- ตัวอย่าง: เพิ่มความเร็วชั่วคราว
        humanoid.WalkSpeed = CONFIG.WALK_SPEED + 20
        task.wait(CONFIG.FARM_SPEED_INTERVAL)
        humanoid.WalkSpeed = CONFIG.WALK_SPEED
    end
end

-- ================= ลูปหลัก =================
-- ทำงานเบื้องหลังเพื่อตรวจสอบและเรียกใช้ฟังก์ชันต่างๆ
task.spawn(function()
    while task.wait(1) do
        -- ตรวจสอบและเรียกใช้ฟังก์ชันที่เปิดใช้งาน
        if CONFIG.AUTO_PLACE then
            pcall(autoPlaceEgg)
        end
        if CONFIG.AUTO_STEAL then
            pcall(autoStealEgg)
        end
        if CONFIG.AUTO_FARM_SPEED then
            pcall(autoFarmSpeed)
        end
    end
end)

print("[tanny] สคริปต์โหลดสำเร็จ! ฟังก์ชันทั้งหมดทำงานอยู่เบื้องหลัง")
