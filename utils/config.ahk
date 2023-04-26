eventType := IniRead("config.ini", "settings", "eventType", "none")

featuredInstaList := []
x := 0
Loop {
    x++
    if IniRead("config.ini", "featuredInstas", "f" x) {
        featuredInstaList.InsertAt(x, IniRead("config.ini", "featuredInstas", "f" x))
    } else {
        break
    }
}
featuredInstaList := ReverseArray(featuredInstaList)
;Reverse the Array to have the last click on most wanted featured Insta Monkey

overwriteSave := IniRead("config.ini", "settings", "overwriteSave", false) == "true"

logging := IniRead("config.ini", "settings", "logging", false) == "true"
logFile := IniRead("config.ini", "settings", "logFile", "logs\" FormatTime(, "yyyyMMdd-HHmmss") ".log")
