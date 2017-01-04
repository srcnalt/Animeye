function changeBackgroundColor(button, suit)
	if suit.ImageButton(button.normal, {hovered = button.hover, active = button.active}, suit.layout:col(66, 20)).hit then
        love.graphics.setBackgroundColor(button.color)
    end
end