Reload() {
    Run(A_ScriptFullPath)
    ExitApp()
}

SlowClick(x, y) {
    Sleep(100)
    MouseMove(x,y)
    Sleep(100)
    Click(x,y)
    Sleep(100)
}

StartGame() {
    Sleep(100)
    Send("{vk20}")      ; Start game
    Sleep(100)
    Send("{vk20}")      ; Increase speed
    Sleep(100)
}

join(strArray)
{
  s := ""
  for i,v in strArray
    s .= ", " . v
  return substr(s, 3)
}

ReverseArray(a) {
    r := []
    for i, e in a {
        r.InsertAt(i, e)
    }
    return r
}