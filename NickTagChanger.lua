NickTagChanger = {}

NickTagChanger.defaultNicks = {}
NickTagChanger.defaultTags = {}

function NickTagChanger:GetName()
    return "Nick/Tag"
end

-- CLIENT

function NickTagChanger:OnOpen()
    if not self.main.adminPanel.isClient then return end

    -- NICK

    self.main.adminPanel:CreateHeader("Change nick")

    local newName_inputField = self.main.adminPanel:CreateInputField("Новый ник", 30, CS.UnityEngine.UI.InputField.ContentType.Standard):GetComponent(typeof(CS.UnityEngine.UI.InputField))

    local horizontal_tr = self.main.adminPanel:CreateHorizontalGroup(30).transform

    local change_btn = self.main.adminPanel:CreateButton("Изменить на новый", horizontal_tr):GetComponent(typeof(CS.UnityEngine.UI.Button))
    local reset_btn = self.main.adminPanel:CreateButton("Вернуть изначальный", horizontal_tr):GetComponent(typeof(CS.UnityEngine.UI.Button)) 

    CS.UIManager.BindAction(change_btn.onClick, 
    function() 
        local selected = self.main.adminPanel:GetSelected()
        if selected == nil then return end
        for i = 0, selected.Length - 1 do   
            local ply = selected[i] 
            if ply ~= nil then
                self.main:SendToServer("ChangeNick", ply, newName_inputField.text)
            end
        end
    end)
    CS.UIManager.BindAction(reset_btn.onClick, 
    function() 
        local selected = self.main.adminPanel:GetSelected()
        if selected == nil then return end
        for i = 0, selected.Length - 1 do   
            local ply = selected[i] 
            if ply ~= nil then
                self.main:SendToServer("ResetNick", ply)
            end
        end
    end)

    -- TAG

    self.main.adminPanel:CreateHeader("Change tag")

    local newTag_inputField = self.main.adminPanel:CreateInputField("Новый тэг", 30, CS.UnityEngine.UI.InputField.ContentType.Standard):GetComponent(typeof(CS.UnityEngine.UI.InputField))

    horizontal_tr = self.main.adminPanel:CreateHorizontalGroup(30).transform

    change_btn = self.main.adminPanel:CreateButton("Изменить на новый", horizontal_tr):GetComponent(typeof(CS.UnityEngine.UI.Button))
    reset_btn = self.main.adminPanel:CreateButton("Вернуть изначальный", horizontal_tr):GetComponent(typeof(CS.UnityEngine.UI.Button)) 

    CS.UIManager.BindAction(change_btn.onClick, 
    function() 
        local selected = self.main.adminPanel:GetSelected()
        if selected == nil then return end
        for i = 0, selected.Length - 1 do   
            local ply = selected[i] 
            if ply ~= nil then
                self.main:SendToServer("ChangeTag", ply, newTag_inputField.text)
            end
        end
    end)
    CS.UIManager.BindAction(reset_btn.onClick, 
    function() 
        local selected = self.main.adminPanel:GetSelected()
        if selected == nil then return end
        for i = 0, selected.Length - 1 do   
            local ply = selected[i] 
            if ply ~= nil then
                self.main:SendToServer("ResetTag", ply)
            end
        end
    end)
end

function NickTagChanger:ChangeNick(ply, nick)
    if ply == nil or nick == nil then return end
    if self.main.adminPanel.isServer then
        if self.defaultNicks.ply == nil then
            self.defaultNicks.ply = ply.accountName
        end
        self.main:SendToEveryone("ChangeNick", ply, nick)
    end
    ply.accountName = nick
end

function NickTagChanger:ResetNick(ply)
    if ply == nil then return end
    if self.main.adminPanel.isServer then
        if self.defaultNicks.ply ~= nil then
            local nick = self.defaultNicks.ply
            self.defaultNicks.ply = nil
            self.main:SendToEveryone("ChangeNick", ply, nick)
            ply.accountName = nick
        end
    end
end

function NickTagChanger:ChangeTag(ply, tag)
    if ply == nil or tag == nil then return end
    if self.main.adminPanel.isServer then
        if self.defaultTags.ply == nil then
            self.defaultTags.ply = ply.globalTag
        end
        self.main:SendToEveryone("ChangeTag", ply, tag)
    end
    ply.globalTag = tag
end

function NickTagChanger:ResetTag(ply)
    if ply == nil then return end
    if self.main.adminPanel.isServer then
        if self.defaultTags.ply ~= nil then
            local tag = self.defaultTags.ply
            self.defaultTags.ply = nil
            self.main:SendToEveryone("ChangeTag", ply, tag)
            ply.globalTag = tag
        end
    end
end

return NickTagChanger