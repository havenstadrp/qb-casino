local inCasino              = false

AddEventHandler("chCasinoWall:enteredCasino", function()
    inCasino = true
    if Config.SetAnimatedWalls then
        startCasinoThreads()
    end
    if Config.SetShowCarOnDisplay then
        spinMeRightRoundBaby()
    end
    if Config.PlayCasinoAmbientNoise then
        playSomeBackgroundAudioBaby()      
    end
end)

AddEventHandler("chCasinoWall:exitedCasino", function()
    inCasino = false
end)

RegisterNetEvent('chCasinoWall:bigWin')
AddEventHandler('chCasinoWall:bigWin', function()
    if not inCasino then
        return
    end
    showBigWin = true
end)

function enterCasino()
    InCasino = true
    TriggerEvent("chCasinoWall:enteredCasino") 
    print("Entered Casino area")
    
    if Config.SendWelcomeMail then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = Config.WelcomeMailsender,
        subject = Config.WelcomeMailsubject,
        message = Config.WelcomeMailmessage,
        button = {}
    })
    end
end

function exitCasino()
    TriggerEvent("chCasinoWall:exitedCasino")
    print("Exited Casino area")
    InCasino = false
    StopAudioScene("DLC_VW_Casino_General")
    Wait(5000)
    
end

CreateThread(function()
    local casinoCoords = vector3(945.85, 41.58, -170.50)
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        if #(pCoords - casinoCoords) < 250.0 then
            if not inCasino then
                enterCasino()
            end
        else
        if inCasino then
            exitCasino()
        end
    end
    Wait(1000)
    end
end)


function playSomeBackgroundAudioBaby()
	CreateThread(function()
        local function audioBanks()
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
                Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
                Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
                Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
                Wait(0)
            end
        end
        audioBanks()
        while inCasino do
            if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
                PlayStreamFromPosition(945.85, 41.58, 75.82)
            end
            if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
                StartAudioScene("DLC_VW_Casino_General")
            end
            Wait(1000)
        end
        if IsStreamPlaying() then
            StopStream()
        end
        if IsAudioSceneActive("DLC_VW_Casino_General") then
            StopAudioScene("DLC_VW_Casino_General")
        end
	end)
end