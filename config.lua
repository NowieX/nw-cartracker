NW = {}

NW.Debug = true

NW.Notifies = {
    ["NotifyTitle"] = "Missionboss",
    ["NotifyPosition"] = 'center-right',
    ["NotifyTimer"] = 7500,
}

NW.NPC = {
    {
        location = vector3(1394.4181, 3649.3171, 33.6841),
        heading = 198.4233,
        model = 'ig_malc',
        targetDistance = 1.5
    }
}

NW.Animations = {
    ["Inspecting"] = {
        duration = 5000, -- Time in miliseconds
        text = "Inspecting...",
        animDictionary = 'amb@world_human_bum_wash@male@low@idle_a',
        animClip = 'idle_a',
    },

    ['PlacingTracker'] = {
        duration = 15000,
        text = "Placing Cartracker...",
        animDictionary = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        animClip = 'machinic_loop_mechandplayer',
    }
}

NW.BlipInformation = {
    ["CartrackerBlip"] = {
        Sprite = 485,
        Colour = 23,
        Scale = 1.0,
        Translation = "Tracker Vehicle"
    },

    ['PoliceBlip'] = {
        Sprite = 161,
        Colour = 59,
        Scale = 1.0,
        Route = true,
        Translation = "Suspicious activity"
    }
}

NW.Paying = {
    range = 10, -- Range the player has to be out to get paid from the npc
    payout = {account = 'bank', amount = 5000}, -- can also be random if you use the one down here
    -- payout = {account = 'bank', amount = math.random(1000, 2000)}, -- Gets random amount between 1000 and 2000
    discordMessage = {
        enabled = false,
        webhookURL = "", -- If enabled you HAVE to fill this with a webhookurl
        message = "**Player with the information underneath got paid out.**"
    }
}

NW.HackingInfo = {
    dropPlayer = true,
    dropMessage = "Trigger Protection.",
    discordMessage = "**Player with the following information maybe is a hacker. Check up on him to be sure.**",
    webhookURL = "" -- Leave empty if you don't want to use the webhooks
}

NW.PoliceInformation = {
    numberRequired = 1,
    removeBlipTimer = 5 -- In seconds
}

NW.TrackerItem = {
    item = 'cartracker',
    amount = 1
}

NW.VehicleModel = {
    vehicle = 'blista', 
    targetBone = 'wheel_rf', 
    targetDistance = 2.0, 
    targetText = "Place cartracker",
}

NW.CarSpawnLocations = {
    {coords = vec3(1684.2324, 6434.7104, 32.2688), heading = 338.1901},
    {coords = vec3(-261.9398, 6061.7637, 31.5776), heading = 299.9797},
    {coords = vec3(-777.1967, 372.6440, 87.8750), heading = 358.7797},
    {coords = vec3(696.5873, -1308.6938, 25.7963), heading = 96.3751},
}

NW.Translations = {
    ["getAwayAndPaid"] = "Now get away ASAP before the police arrives!",
    ["getPaid"] = "Good job, the money is in your bank. I hope to see you soon for another mission.",
    ["goodLuckMission"] = "Put this tracker on the vehicle marked on your GPS, after that get away ASAP because the police will get notified!",
    ["noPolice"] = 'There is not enough police in town.',
    ["policeNotify"] = {title = "Control Centre", description = "Suspicious activity has been reported, the location is on your GPS!"},
    ['PoliceBlipText'] = "Suspicious Activity",
    ["missionLocked"] = 'A person is already doing a mission for me, go away!',
}