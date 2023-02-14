#SingleInstance Force
#MaxThreadsPerHotkey 3
#Include %A_ScriptDir%

#Include utils.ahk
#Include maps\dark_easy.ahk
#Include maps\ouch_easy.ahk
#Include maps\quad_easy.ahk
#Include maps\muddy_easy.ahk
#Include maps\bloody_easy.ahk
#Include maps\ravine_easy.ahk
#Include maps\flooded_easy.ahk
#Include maps\infernal_easy.ahk
#Include maps\workshop_easy.ahk
#Include maps\sanctuary_easy.ahk

maps := Map(
    "sanc", sancGameScript,
    "ravine", ravineGameScript,
    "flooded", floodedgameScript,
    "infernal", infernalGameScript,
    "bloody", bloodyGameScript,
    "workshop", workshopGameScript,
    "quad", quadGameScript,
    "dark", darkGameScript,
    "muddy", muddyGameScript,
    "ouch", ouchGameScript,
)

states := ["play_home", "stage_select", "in_game"]
if eventType != "none" {
    states.Push("collect", eventType "\event")
}

^!+j:: {
    ClearLogFile()
    LogMsg("Script started")
    while WinActive("BloonsTD6") {
        switch CheckMenuState() {
            case "play_home":
                ClickImage("play_home")
            case "stage_select":
                SelectExpertMap()
            case "in_game":
                SelectGameScript()
            case "collect":
                OpenBoxes()
            case eventType "\event":
                ClickImage("play_collect")
        }
    }
}

^!+p:: {
    LogMsg("Script stopped")
    Reload()
}

Reload() {
    Run(A_ScriptFullPath)
    ExitApp()
}

CheckMenuState() {
    for state in states {
        if SearchImage(state) {
            LogMsg(state)
            return state
        }
    }
    LogMsg("Menu state not recognized")
    ScaledSleep(10000)
}

CheckHero() {
    styles := ["normal", "dj", "sushi"]

    for style in styles {
        if SearchImage("hero\" style) {
            return
        }
    }
    LogMsg("Benjamin not selected, changing the hero")
    clickImage("hero\change")

    changed := false
    for style in styles {
        if ClickImage("hero\select_" style) {
            clickImage("hero\select")
            clickImage("hero\back")
            changed := true
        }
    }
    if !changed {
        LogMsg("Couldn't change the hero, stopping the script...")
        Reload()
    }
}

FindExpertMap() {
    while true {
        ClickImage("expert")
        if eventType == "none" {
            if clickImage("dark") {
                return
            }
        } else {
            for tileNumber in [0, 1, 2, 3, 4, 5] {
                if ClickImage(eventType "\" tileNumber) {
                    return
                }
            }
        }
    }
}

CheckOwerwrite() {
    if SearchImage("overwrite") {
        if overwriteSave {
            ClickImage("overwrite_ok")
        } else {
            LogMsg("Script stopped to protect an existing save")
            Reload()
        }
    }
}

SelectExpertMap() {
    CheckHero()
    FindExpertMap()
    ClickImage("easy")
    ClickImage("standard")
    CheckOwerwrite()
    ScaledSleep(4000)
}

GetMapName() {
    while true {
        for map, _ in maps {
            if SearchImage("maps/" map) {
                LogMsg("Map recognized: " map)
                return map
            }
        }
        LogMsg("Map not recognized")
    }
}

SelectGameScript() {
    map := GetMapName()
    maps[map]()
    LogMsg("Waiting for the game to end...")
    CheckVictoryOrDefeat()
}

OpenBoxes() {
    ClickImage("collect")
    LogMsg("Opening boxes")
    while !SearchImage(eventType "\event") {
        for coords in ["683,535","900,550","897,535","900,550","1190,535","900,550","950,930"] {
            Click(coords)
            ScaledSleep()
        }
    }
}

CheckVictoryOrDefeat() {
    Loop {
        if SearchImage("defeat") {
            ClickImage("home_defeat", 2000)
            LogMsg("Defeat")
            break
        }
        if SearchImage("victory") {
            ClickImage("next")
            ClickImage("home", 2000)
            LogMsg("Victory")
            break
        }
        ScaledSleep()
    }
}
