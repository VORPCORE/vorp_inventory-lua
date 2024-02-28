Prompt = {}

PromptType = {
    JustPressed = 0,
    JustReleased = 1,
    Pressed = 2,
    Released = 3,
    StandardHold = 4,
    StandardizedHold = 5
}

Prompt.handle = 0
Prompt.visible = true
Prompt.label = ''
Prompt.type = PromptType.Pressed
Prompt.group = 0
Prompt.eventTriggered = false


function Prompt:Delete()
    return UiPromptDelete(self.handle)
end

function Prompt:HasHoldModeCompleted()
    return UiPromptHasHoldModeCompleted(self.handle)
end

function Prompt:GetEnabled()
    return UiPromptIsEnabled(self.handle) == 1
end

function Prompt:SetEnabled(enabled)
    return UiPromptSetEnabled(self.handle, enabled)
end

function Prompt:GetVisible()
    return self.visible
end

function Prompt:SetVisible(visible)
    if visible == self.visible then
        return
    end
    self.visible = visible
    self:SetEnabled(visible)
    UiPromptSetVisible(self.handle, visible)
end

function Prompt:New(control, label, promptType, group)
    local priority = 1
    local transportMode = 0
    local timedEventHash = 0

    local promptHandle = UiPromptRegisterBegin()
    UiPromptSetControlAction(promptHandle, control)
    local strLabel = CreateVarString(10, "LITERAL_STRING", label)
    UiPromptSetText(promptHandle, strLabel)
    UiPromptSetPriority(promptHandle, priority)
    UiPromptSetTransportMode(promptHandle, transportMode)
    UiPromptSetAttribute(promptHandle, 18, true)

    if promptType == PromptType.JustReleased or promptType == PromptType.Released then
        UiPromptSetStandardMode(promptHandle, true)
    elseif promptType == PromptType.JustPressed or promptType == PromptType.Pressed then
        UiPromptSetStandardMode(promptHandle, false)
    elseif promptType == PromptType.StandardHold then
        UiPromptSetHoldMode(promptHandle, 1500)
    elseif promptType == PromptType.StandardizedHold then
        UiPromptSetStandardizedHoldMode(promptHandle, timedEventHash)
    end

    if group > 0 then
        UiPromptSetGroup(promptHandle, group, 0)
    end

    UiPromptSetVisible(promptHandle, false)
    UiPromptSetEnabled(promptHandle, false)
    UiPromptRegisterEnd(promptHandle)

    local t = { handle = promptHandle, type = promptType, label = label }
    setmetatable(t, self)
    self.__index = self
    return t
end
