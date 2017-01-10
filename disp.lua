function animReload()
	if created then
        anims:reload(math.floor(width.value), math.floor(height.value), count.value)
        frame.max = anims.count + 0.9
    end 
end

function changeBackgroundColor(button)
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

    count.max   = anims.count + 0.9
    count.value = anims.count
    input_count.text = tostring(anims.count)

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
        local n = tonumber(input_width.text)

        checkNumber(n, width, input_width)

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

        checkNumber(n, height, input_height)

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

        checkNumber(n, frame, input_frame)

        if n > anims.count then
            n = anims.count
            input_frame.text = tostring(n)
        end

        anims.stop  = true
        anims.pos   = n
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

function displayNumberOfFramesTool()
	suit.Label("Number of frames: ", {align = "left"}, suit.layout:row(120, 20))

	if suit.Input(input_count, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_count.text)

        checkNumber(n, count, input_count)

        animReload()
    end

    suit.layout._x = 10

    if suit.Slider(count, {align = "left"}, suit.layout:row(250, 20)).changed then
        animReload()

        input_count.text = tostring(math.floor(count.value))
    end

    suit.layout:row(0, 5)
end

function displayAnimSpeedTool()
	suit.Label("Animation speed: ", {align = "left"}, suit.layout:row(120, 20))
    
    if suit.Input(input_speed, suit.layout:col(130, 20)).submitted then
        n = tonumber(input_speed.text)

        checkNumber(n, speed, input_speed)
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

        checkNumber(n, scale, input_scale)
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

function displayInfoButton(button)
	if suit.ImageButton(button.normal, {hovered = button.hover, active = button.active}, 10, lg.getHeight() - 30).hit then
        message = msg.not_yet
    end
end

function checkNumber(n, var, input_var)
    if not isNumber(input_var.text) then 
        input_var.text = tostring(math.floor(var.value))
        message = msg.only_nr
        return
    end 

	if n < var.max or n > 1 then
        input_var.text = tostring(math.floor(var.value))
    	message = msg.err_num
        return
    end

    var.value = n
end

function isNumber(i)
    if string.match(i, '[^0-9]') == nil then return true end
    return false
end

function drawDock()
	love.graphics.setColor(20, 30, 45, 255)
    love.graphics.rectangle('fill', 0, 0, dock_width, love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255, 255)
end

function drawConsole()
	love.graphics.setColor(140, 140, 140, 255)
    love.graphics.rectangle('fill', dock_width, lg.getHeight() - cli_height, lg.getWidth() - dock_width, cli_height)
    love.graphics.setColor(255, 255, 255, 255)
end

message = ""

msg = {
	welcome  = "Welcome to Animeye, drop a sprite sheet to the screen.",
	img_drop = "Sprite sheet dropped.",
	err_ext  = "Error! File type is not supported.",
	err_num  = "You can only use positive numbers in the margin.",
	not_yet  = "This feature is not yet implemented.",
    only_nr  = "You can only use numeric values."
}

function printMessage()
	love.graphics.print(message, dock_width + 5, love.graphics.getHeight() - cli_height + 5)
end
