local OldOnFirstUpdate = OnFirstUpdate
function OnFirstUpdate()
    OldOnFirstUpdate()
    ConExecute("WLD_GameSpeed 15")
end