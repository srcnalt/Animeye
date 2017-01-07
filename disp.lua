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