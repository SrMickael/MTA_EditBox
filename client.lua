function createEditBox(x, y, width, height, text, maxLength, font, colors, fieldType)
    local editBox = {
        x = x or 100,
        y = y or 100,
        width = width or 200,
        height = height or 30,
        text = "",
        textLength = text or "",
        maxLength = maxLength or 50,
        font = font or 'default',
        textColor = colors['textColor'] or {255, 255, 255, 1},
        borderColor = colors['borderColor'] or {10, 10, 10, 1},
        selectedColor = {0, 119, 192},
        cursorIndex = 0,
        selectionStart = 0,
        selectionEnd = 0,
        isSelecting = false,
        isSelected = false,
        fieldType = fieldType or "text",
        eventHandlers = {}, -- Uma tabela para armazenar os manipuladores de eventos
    }
    
    function editBox:addEventHandler(eventName, handlerFunction)
        addEventHandler(eventName, root, handlerFunction)
        table.insert(self.eventHandlers, {eventName, root, handlerFunction})
    end

    function editBox:destroy()
        -- Remova todos os manipuladores de evento da tabela eventHandlers
        for _, eventHandler in ipairs(self.eventHandlers) do
            removeEventHandler(eventHandler[1], eventHandler[2], eventHandler[3])
        end
    end

    -- Função para desenhar a caixa de edição
    function editBox:draw(alpha)
        local alpha = alpha or 255
        local textToDraw = self.text

        dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.borderColor[1], self.borderColor[2], self.borderColor[3], alpha*self.borderColor[4]))

        if #textToDraw > 0 and self.fieldType == "password" then
            -- Substitua o texto por asteriscos para campos de senha
            local passwordText = string.rep("*", #textToDraw)
            textToDraw = passwordText
        end

        local WText = dxGetTextWidth(string.sub(textToDraw, 1, self.cursorIndex), 1, self.font)
        local waw = dxGetTextWidth(textToDraw, 1, self.font)
        local _, textHeight = dxGetTextSize(textToDraw, waw, 1, self.font)
        

        if self.isSelected then
            if self.isSelecting then
                textToDraw = string.sub(textToDraw, self.selectionStart + 1, self.selectionEnd)
                dxDrawRectangle(self.x + 5, self.y, (waw >= self.width and self.width - 5 or waw), self.height, tocolor(self.selectedColor[1], self.selectedColor[2], self.selectedColor[3], alpha*0.70))
            end
            dxDrawRectangle((self.x + (WText >= self.width and self.width - 5 or WText + 5)), self.y+(textHeight/2), 1, textHeight, tocolor(255, 255, 255, math.abs(math.sin(getTickCount() / 500) * 255)))
        else
            textToDraw = (#textToDraw > 0 and textToDraw or self.textLength)
        end

        dxDrawText(textToDraw, self.x + 5, self.y, self.x + self.width - 5, self.y + self.height, tocolor(self.textColor[1], self.textColor[2], self.textColor[3], alpha*self.textColor[4]), 1, self.font, (WText >= self.width - 5 and "right" or "left"), "center", true)
    end


    function editBox:onClientPaste(text)
        local clipboardText = text
        local texts = string.sub(self.text, 1, self.selectionStart) .. clipboardText .. string.sub(self.text, self.selectionEnd + 1)
        
        if self.isSelected and clipboardText and #texts <= self.maxLength then
            if self.isSelecting then
                self.text = string.sub(self.text, 1, self.selectionStart) .. clipboardText .. string.sub(self.text, self.selectionEnd + 1)
                self.cursorIndex = self.selectionStart + #clipboardText
                self.isSelecting = false
            else
                self.text = string.sub(self.text, 1, self.cursorIndex) .. clipboardText .. string.sub(self.text, self.cursorIndex + 1)
                self.cursorIndex = self.cursorIndex + #clipboardText
            end
        end
    end


    -- Função para manipular a entrada de texto
    function editBox:handleInput(key, state)
        if (state) then
            if key == "backspace" then
                if self.isSelected then
                    if self.isSelecting then
                        self.text = string.sub(self.text, 1, self.selectionStart) .. string.sub(self.text, self.selectionEnd + 1)
                        self.cursorIndex = self.selectionStart
                        self.isSelecting = false
                    elseif self.cursorIndex > 0 then
                        self.text = string.sub(self.text, 1, self.cursorIndex - 1) .. string.sub(self.text, self.cursorIndex + 1)
                        self.cursorIndex = self.cursorIndex - 1
                    end
                end   
            elseif key == "c" and getKeyState("lctrl") then
                if self.isSelecting then
                    local selectedText = string.sub(self.text, self.selectionStart + 1, self.selectionEnd)
                    setClipboard(selectedText)
                end
            elseif key == "a" and getKeyState("lctrl") then
                self.selectionStart = 0
                self.selectionEnd = #self.text
                self.isSelecting = true
            end
        end
    end

    -- Função para lidar com a digitação de caracteres
    function editBox:handleCharacter(char)
        if self.isSelected and #self.text < self.maxLength then
            if self.isSelecting then
                self.text = string.sub(self.text, 1, self.selectionStart) .. char .. string.sub(self.text, self.selectionEnd + 1)
                self.cursorIndex = self.selectionStart + 1
                self.isSelecting = false
            else
                self.text = string.sub(self.text, 1, self.cursorIndex) .. char .. string.sub(self.text, self.cursorIndex + 1)
                self.cursorIndex = self.cursorIndex + 1
            end
        end
    end

    -- Manipulação de eventos
    function editBox:onClientClick(button, state, mouseX, mouseY)
        if button == "left" and state == "down" then
            if mouseX >= self.x and mouseX <= self.x + self.width and mouseY >= self.y and mouseY <= self.y + self.height then
                self.isSelected = true
                guiSetInputMode("no_binds")
                local textWidth = {dxGetTextWidth(self.text, self.fontSize, self.font)}
                local mouseOffset = mouseX - self.x
                for i = 0, #self.text do
                    local subText = string.sub(self.text, 1, i)
                    local subTextWidth = dxGetTextWidth(subText, self.fontSize, self.font)
                    if subTextWidth >= mouseOffset or i == #self.text then
                        self.cursorIndex = i
                        break
                    end
                end
            else
                self.isSelected = false
                guiSetInputMode("allow_binds")
                self.isSelecting = false
            end
        end
    end

    editBox:addEventHandler("onClientPaste", function(text)
        editBox:onClientPaste(text)
    end)

    editBox:addEventHandler("onClientClick", function(button, state, mouseX, mouseY)
        editBox:onClientClick(button, state, mouseX, mouseY)
    end)

    editBox:addEventHandler("onClientCharacter", function(char)
        editBox:handleCharacter(char)
    end)

    editBox:addEventHandler("onClientKey", function(key, state)
        editBox:handleInput(key, state)
    end)

    return editBox
end
