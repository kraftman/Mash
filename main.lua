

local canvas = require('canvas')
local player = require('player')
local lg = love.graphics
local controllers = {}
local buttonListeners = {}

local function RemoveController(controller)
    if controller.joystick:isConnected() == false then
        for k, player in pairs(controller.players) do
            canvas:RemovePlayer(player)
            for k,v in pairs(listenButtons) do
                if v == player then
                    listenButtons[v] = nil
                end
            end
        end
        controller[k] = nil
    end
end

local function AddController(joystick)
    local joyID = joystick:getID()
    if not controllers[joyID] then
        controllers[joystick:getID()] = {players = {}, joystick = joystick, id = joyID}
    end
end

function love.update(dt)
    local joysticks = love.joystick.getJoysticks()
    -- add controllers
    for i, joystick in ipairs(joysticks) do
        AddController(joystick)
    end 
    --remove controllers
    for id, controller in pairs(controllers) do
        RemoveController(controller)
    end
    canvas:Update(dt)
end

function AddPlayer(controller, playerID)
    print('creating player: ', playerID)
    local listenButtons = {}
    listenButtons.player1 = {'leftstick',}
    listenButtons.player2 = {'rightstick'}

    local lOrR = playerID == 'player1' and 'left' or 'right'
    local player = player:Create(50, 50, controller.joystick, lOrR)
    canvas:AddPlayer(player)
    controller.players[playerID] = player
    for k, v in pairs(listenButtons[playerID]) do
        buttonListeners[controller.id..v] = player
    end

end



function love.gamepadpressed(joystick, button)
    AddController(joystick)
    local controller = controllers[joystick:getID()]
    if button == 'leftstick' and not controller.players.player1 then
        AddPlayer(controller, 'player1')
    end
    
    if button == 'rightstick' and not controller.players.player2 then
        AddPlayer(controller, 'player2')
    end
    local playerToUpdate = buttonListeners[controller.id..button]
    if playerToUpdate then
        playerToUpdate:ButtonDown(button)
        print(button)
    end
end

function love.gamepadreleased( joystick, button )
    AddController(joystick)
    local controller = controllers[joystick:getID()]
    
    local playerToUpdate = buttonListeners[controller.id..button]
    if playerToUpdate then
        playerToUpdate:ButtonUp(button)
    end
end

function love.gamepadaxis( joystick, axis, value )
    AddController(joystick)
    local controller = controllers[joystick:getID()]

    if (axis == 'leftx' or axis == 'lefty') then
        if not controller.players.player1 then
            AddPlayer(controller, 'player1')
        end
        local playerToUpdate = buttonListeners[controller.id..axis]
        if playerToUpdate then
            if axis == 'leftx' then
                print(value)
                playerToUpdate:SteerX(value)
            else
                playerToUpdate:SteerY(value)
            end


        end

    end
    
    if (axis == 'rightx' or axis == 'righty') then
        if not controller.players.player2 then
            AddPlayer(controller, 'player2')
        end
        
        local playerToUpdate = buttonListeners[controller.id..axis]
        if playerToUpdate then
            if axis == 'rightx' then
                playerToUpdate:SteerX(value)
            else
                playerToUpdate:SteerY(value)
            end
        end
    end
end

function love.draw()
    canvas:Draw()
    
    local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do
        love.graphics.print(joystick:getName(), 10, i * 20)
        love.graphics.print(joystick:getID(), 150, i * 20)

    end 
    love.timer.sleep(0.01)
end