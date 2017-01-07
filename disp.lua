function animReload()
	if created then
        anims:reload(math.floor(width.value), math.floor(height.value))
        frame.max = anims.count + 0.9
    end 
end

function changeBackgroundColor(button, suit)
	if suit.ImageButton(button.normal, {hovered = button.hover, active = button.active}, suit.layout:col(66, 20)).hit then
        love.graphics.setBackgroundColor(button.color)
    end
end

function createAnimation(img)
    image = love.graphics.newImage(img)
    anims = anim.new(image, width.value, height.value, speed.value)
    
    frame.max   = anims.count + 0.9
    frame.value = 1
    input_frame.text = '1'

    created = true
end

function getImageData()
    local file = io.open(image_path, 'rb')
    file_data = file:read('*all')
    file:close()

    image_data = love.filesystem.newFile("temp.png", "w")
    image_data:write(file_data)
    image_data:close()

    image = love.graphics.newImage("temp.png")
end

function displayFrameWidthTool()
	suit.Label("Frame width: ", {align = "left"}, suit.layout:row(120, 20))

    if suit.Input(input_width, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_width.text)

        --TODO: Add error message for this
        --also should be moved into a function for max and minus check
        if n > width.max or n < 1 then
            input_width.text = tostring(math.floor(width.value))
            return
        end

        width.value = n

        animReload()
    end

    suit.layout._x = 10

    if suit.Slider(width, {align = "left"}, suit.layout:row(250, 20)).changed then
        
        animReload()

        input_width.text = tostring(math.floor(width.value))
    end

    suit.layout:row(0, 5)
end

function displayFrameHeightTool()
	suit.Label("Frame height: ", {align = "left"}, suit.layout:row(120, 20))

	if suit.Input(input_height, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_height.text)

        --TODO: Add error message for this
        if n > height.max or n < 1 then
            input_height.text = tostring(math.floor(height.value))
            return
        end

        height.value = n

        animReload()
    end

    suit.layout._x = 10

    if suit.Slider(height, {align = "left"}, suit.layout:row(250, 20)).changed then
        
        animReload()

        input_height.text = tostring(math.floor(height.value))
    end

    suit.layout:row(0, 5)
end

function displayGoToFrameTool()
	suit.Label("Go to frame: ", {align = "left"}, suit.layout:row(120, 20))

    if suit.Input(input_frame, suit.layout:col(60, 20)).submitted then
        n = tonumber(input_frame.text)

        --TODO: Add error message for this
        if n > frame.max or n < 1 then
            input_frame.text = tostring(math.floor(frame.value))
            return
        end

        if n > anims.count then
            n = anims.count
            input_frame.text = tostring(n)
        end

        anims.stop  = true
        anims.pos   = n
        frame.value = n
    end

    suit.layout:col(10, 0)

    if suit.Button("Play", suit.layout:col(60, 20)).hit and created then
        anims.stop = false
    end

    suit.layout._x = 10

    if suit.Slider(frame, {align = "left"}, suit.layout:row(250, 20)).changed then
        anims.stop = true
        input_frame.text = tostring(math.floor(frame.value))
        anims.pos  = tonumber(input_frame.text)
    end

    suit.layout:row(0, 5)
end

function displayAnimSpeedTool()
	suit.Label("Animation speed: ", {align = "left"}, suit.layout:row(120, 20))
    
    if suit.Input(input_speed, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_speed.text)

        --TODO: Add error message for this
        if n > speed.max or n < 1 then
            input_speed.text = tostring(math.floor(speed.value))
            return
        end

        speed.value = n
    end

    suit.layout._x = 10

    if suit.Slider(speed, {align = "left"}, suit.layout:row(250, 20)).changed then
        anims.speed = (math.floor(speed.value * 10) * 0.1)
        input_speed.text = tostring(math.floor(speed.value * 100) * 0.01)
    end

    suit.layout:row(0, 5)
end

function displayScaleFactorTool()
    suit.Label("Scale factor: ", {align = "left"}, suit.layout:row(120, 20))
    
    if suit.Input(input_scale, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_scale.text)

        --TODO: Add error message for this
        if n > scale.max or n < 0 then
            input_scale.text = tostring(math.floor(scale.value))
            return
        end

        scale.value = n

    end

    suit.layout._x = 10

    if suit.Slider(scale, suit.layout:row(250, 20)).changed then
        anims.scale = math.floor(speed.value * 10) * 0.1
        input_scale.text = tostring(math.floor(scale.value * 10) * 0.1)
    end

    suit.layout:row(0, 5)
end

function displayRefreshTool()
    if suit.Button("Refresh", suit.layout:row(250, 20)).hit and created then
        getImageData(image_path)
        createAnimation(image_data)
    end

    suit.layout:row(0, 5)
end

function drawDock()
	love.graphics.setColor(20, 30, 45, 255)
    love.graphics.rectangle('fill', 0, 0, dock_width, love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255, 255)
end

function drawConsole()
	love.graphics.setColor(140, 140, 140, 255)
    love.graphics.rectangle('fill', dock_width, love.graphics.getHeight() - cli_height, love.graphics.getWidth() - dock_width, cli_height)
    love.graphics.setColor(255, 255, 255, 255)
end

message = ""

msg = {
	welcome  = "Welcome to Animeye, drop a sprite sheet to the screen.",
	img_drop = "Sprite sheet dropped.",
	err_ext  = "Error! File type is not supported.",
	err_num  = "You can only use positive numbers in the margin.",
	err_flt  = "You can only use positive decimals in the margin."
}

function printMessage()
	love.graphics.print(message, dock_width + 5, love.graphics.getHeight() - cli_height + 5)
end