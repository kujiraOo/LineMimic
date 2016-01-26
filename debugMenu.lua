-- File: debugMenu.lua

-- Create debug menu to configure gameplay options

-- Imports:
local widget = require("widget")
local composer = require("composer")
local tabtofile = require("tabtofile")

-- Class declaration
local debugMenu = class("debugMenu")

-- Constants
local DEFAULT_CONFIG = {
	startSpeed = 1,
	accelerationType = "nextLine",
	accelerationDelay = 10,
	normalSpeed = 2,
	baseAcceleration = 0.1,
	normAccelerationType = "linear",
	normAccelerationMult = 2,
	speedIncrementRate = 3,
	enableNormAcceleration = true,
	maxNumLines = 30,
	canSpeedUp = true,
	speedUpEnableType = "playerInput",
	speedUpEnableChance = 10,
	speedUpDisableType = "playerInput",
	movesToDisableSpeedUp = 10,
	enableMovesRandomInterval = false,
	movesRandomInterval = 5,
	enableAccelerationHelp = true,
	linesToEnableAccHelp = 15,
	enableVariableLength = true,
	variableLengthChance = 20,
	linesToDisableVarLength = 10,
	powerUpTime = 15,
	freezeTime = 2,
	speedDown = 3,
}


local fontSize = 12
local horOffset = 20


-- Local vars declaration
local initMenuElements


-- Local functions
local function newScrollView(sceneGroup)

	local scrollView = widget.newScrollView{
		top = 0.5 * (display.contentHeight - display.actualContentHeight),
	    left = 0.5 * (display.contentWidth - display.actualContentWidth),
	    width = display.actualContentWidth,
	    height = display.actualContentHeight,
	   	scrollHeight = 3000,
	   	horizontalScrollDisabled = true,
	}

	-- y coordinate of the first element of the scroll view
	scrollView.elY = 40

	sceneGroup:insert(scrollView)

	return scrollView
end


local function onStartButtonReleased( event )
	local button = event.target
	local config = button.onReleaseParams.config

	tabtofile.save(config, "config")
	composer.gotoScene( "scenes.gameScreen" , {params = {config = config}} )
end

local function newStartButton(config )

	local button = widget.newButton {
		label = "start",
		onRelease = onStartButtonReleased,
		shape = "roundedRect",
		width = 70,
		height = 30,
		cornerRadius = 5,
		fillColor = { default = {0, 1, 0.8, 1}, over = {0, 1, 1, 1} },
		labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}},
	}

	button.id = "start button"
	button.onReleaseParams = {config = config}

	return button 
end


local function onDefaultConfigButtonReleased( event )
	local button = event.target

	local config = button.onReleaseParams.config
	local scrollView = button.onReleaseParams.scrollView
	local sceneGroup = button.onReleaseParams.sceneGroup

	sceneGroup:remove(scrollView)
	scrollView = newScrollView(sceneGroup)

	for k, v in pairs(config) do
		config[k] = DEFAULT_CONFIG[k]
	end

	initMenuElements(config, scrollView, sceneGroup)
end


-- Create button that resets config to default
local function newDefaultConfigButton(config, scrollView, sceneGroup )

	local button = widget.newButton {
		label = "default config",
		onRelease = onDefaultConfigButtonReleased,
		shape = "roundedRect",
		width = 150,
		height = 30,
		cornerRadius = 5,
		fillColor = { default = {0, 1, 0.8, 1}, over = {0, 1, 1, 1} },
		labelColor = {default = {0, 0, 0, 1}, over = {0, 0, 0, 1}},
	}

	button.onReleaseParams = {
		sceneGroup = sceneGroup, 
		scrollView = scrollView, 
		config = config
	}

	return button 
end


local function onStepperPressed( event )

	local stepper = event.target

	local isEnabled = stepper.parent.isEnabled
	local config = stepper.onPressParams.config
	local k = stepper.onPressParams.k
	local step = stepper.onPressParams.step
	local max = stepper.onPressParams.max
	local min = stepper.onPressParams.min
	local valueTextObject = stepper.onPressParams.valueTextObject

	if isEnabled then
		if ( "increment" == event.phase ) then
       		config[k] = config[k] + step
	    elseif ( "decrement" == event.phase ) then
	        config[k] = config[k] - step
	    end

	    if config[k] > max then
	    	config[k] = max
	    end

	    if config[k] < min then
	    	config[k] = min
	    end

	    valueTextObject.text = config[k]
	end
	
end

-- Create a stepper that changes value of a table field
local function newStepper(config, k, min, max, step)
	local nameX = 20
	local valueX = 175
	local stepperX = 250

	local group = display.newGroup( )

	group.id = "stepper"
	group.isEnabled = true

	local nameTextObject = display.newText(group, k, nameX, 0, nil, 12)
	nameTextObject:setFillColor( 0 )
	nameTextObject.anchorX = 0

	-- If value is not registered in current config then get it from DEFAULT_CONFIG
	if not config[k] then
		config[k] = DEFAULT_CONFIG[k]
	end

	local valueTextObject = display.newText(group, config[k], valueX, 0, nil, 12)
	valueTextObject:setFillColor( 0 )
	valueTextObject.anchorX = 0

	local stepper = widget.newStepper{
		minimumValue = -math.huge,
		maximumValue = math.huge,
		onPress = onStepperPressed,
		timerIncrementSpeed = 200,
	}
	stepper.x = stepperX
	stepper.anchorY = 1

	stepper.onPressParams = {
		config = config,
		k = k,
		min = min,
		max = max,
		step = step,
		valueTextObject = valueTextObject,
	}

	group:insert(stepper)

	return group
end

local function disableSubCheckBoxesLinkedEls( subCheckBoxes )
	
	for i = 1, #subCheckBoxes do

		local subCheckBox = subCheckBoxes[i]
		local linkedEls = subCheckBox.linkedEls
		local isOn = subCheckBox.checkBox.isOn

		for j = 1, #linkedEls do

			local el = linkedEls[j]

			if not isOn then
				el.alpha = 0.5
				el.isEnabled = false
			end
		end
	end
end

local function updateCheckBoxLinkedElements(isOn, linkedEls )

	local subCheckBoxes = {}

	for i = 1, #linkedEls do
		local el = linkedEls[i]

		if isOn then
			el.alpha = 1
			el.isEnabled = true
		else
			el.alpha = 0.5
			el.isEnabled = false
		end

		if el.id == "checkBox" then
			table.insert( subCheckBoxes, el )
		end

	end

	-- If linked element is a checkbox then check if it has somed linked elemets too

	if isOn and #subCheckBoxes > 0 then
		disableSubCheckBoxesLinkedEls(subCheckBoxes)
	end
end

local function onCheckBoxPressed( event )

	local checkBox = event.target
	local checkBoxGroup = event.target.parent

	local isEnabled = checkBoxGroup.isEnabled
	local config = checkBox.config
	local k = checkBox.k

	if isEnabled then

    	config[k] = not config[k]
    	local isOn = config[k]

    	local linkedEls = checkBoxGroup.linkedEls

    	if linkedEls then

    		updateCheckBoxLinkedElements(isOn, linkedEls)
    	end
    else
    	checkBox:setState( {isOn = isOn} )
    end
end

local function newCheckBox( config, k, linkedEls)

	local group = display.newGroup( )
	group.isEnabled = true
	group.id = "checkBox"
	group.linkedEls = linkedEls
	group.isOn = config[k]

	local nameTextObject = display.newText( group, k, 20, 0, native.systemFont, fontSize )
	nameTextObject.anchorX = 0
	nameTextObject:setFillColor( 0 )

	local isOn = group.isOn

	local checkBox = widget.newSwitch{
	    style = "checkbox",
	    initialSwitchState = config[k],
	    left = 200,

	    onPress = onCheckBoxPressed,
	}
	checkBox.anchorY = 1
	checkBox.config = config
	checkBox.k = k
	group:insert(checkBox)
	group.checkBox = checkBox

	if linkedEls then
		updateCheckBoxLinkedElements(isOn, linkedEls)
	end
	
	return group
end


local function onRadioButtonPressed( event )
	local radioButton = event.target

	local config = radioButton.onPressParams.config
	local k = radioButton.onPressParams.k
	local id = radioButton.id

	config[k] = id
end

local function newRadioGroup( config, k, options )

	local elHeight = 40
	local offset = 20

	local group = display.newGroup( )
	group.isEnabled = true

	local nameTextObject = display.newText( group, k, 20, 0, native.systemFont, fontSize )
	nameTextObject.anchorX = 0
	nameTextObject:setFillColor( 0 )

	for i = 1, #options do

		local id = options[i]
		local y = (i - 1) * elHeight + (i - 1) * offset

		local buttonName = display.newText( group, id, 175, y, native.systemFont, fontSize )
		buttonName.anchorX = 0
		buttonName:setFillColor( 0 )

		local button = widget.newSwitch{
		    left = 250,
		    style = "radio",
		    id = id,
		    onPress = onRadioButtonPressed,
		}
		button.anchorY = 0.5
		button.y = y

		button.onPressParams = {
			config = config,
			k = k,
		}

		if id == config[k] then
			button:setState{ isOn = true }
		end

		group:insert( button )
	end

	return group
end

-- Add line objects to the top and to the bottom of a menu group to provide
-- proper visual demarcation of menu's categories
local function newDivider( group )
	local x1 = 0.5 * (display.contentWidth - display.actualContentWidth)
	local x2 = display.actualContentWidth
	local top = -30
	local bottom = group.elY - 30

	local dividerTop = display.newLine( group, x1, top, x2, top)
	dividerTop:setStrokeColor( 0 )

	local dividerBottom = display.newLine( group, x1, bottom, x2, bottom)
	dividerBottom:setStrokeColor( 0 )
end

-- All elements that are added are of a fixed height
-- If a group of elements such as radio button is added then
-- number of elements in this group must be specified to 
-- calculate group's height
local function addElement( group, el, nEls )
	local offset = 20
	local elHeight = 40

	group:insert( el )
	el.y = group.elY
	nEls = nEls or 1
	group.elY = group.elY + nEls * (offset + elHeight)
end

function initMenuElements(config, scrollView, sceneGroup )

	local startButton = newStartButton(config)
	startButton.x = 0.5 * scrollView.contentWidth
	addElement(scrollView, startButton)

	-- Speed and acceleration section
	local maxNumLinesStepper = newStepper(config, "maxNumLines", 10, 50, 1)
	addElement(scrollView, maxNumLinesStepper)

	local speedStepper = newStepper(config, "startSpeed", 1, 10, 0.1)
	addElement(scrollView, speedStepper)

	local accelerationTypeRadioGroup = newRadioGroup(config, "accelerationType", {"time", "nextLine"})
	addElement(scrollView, accelerationTypeRadioGroup, 2)

	local accelerationDelayStepper = newStepper(config, "accelerationDelay", 1, 15, 1)
	addElement(scrollView, accelerationDelayStepper)

	local defaultAccelerationStepper = newStepper(config, "baseAcceleration", 0, 1, 0.05)
	addElement(scrollView, defaultAccelerationStepper)

	local speedIncrRateStepper = newStepper(config, "speedIncrementRate", 1, 50, 1)
	addElement(scrollView, speedIncrRateStepper)

	-- Normal acceleration section
	local normAccelerationGroup = display.newGroup( )
	normAccelerationGroup.elY = 0
	addElement(scrollView, normAccelerationGroup, 5)

	local normalSpeedStepper = newStepper(config, "normalSpeed", 1, 10, 0.1)

	local normAccelerationMultStepper = newStepper(config, "normAccelerationMult", 1, 30, 1)

	local normalAccRadioGroup = newRadioGroup(config, "normAccelerationType", 
											{"linear", "quadratic"})

	local normAccelerationCheckBox = newCheckBox( config, "enableNormAcceleration", 
											{normalSpeedStepper, normAccelerationMultStepper, normalAccRadioGroup})

	addElement(normAccelerationGroup, normAccelerationCheckBox)
	addElement(normAccelerationGroup, normalSpeedStepper)
	addElement(normAccelerationGroup, normalAccRadioGroup, 2)
	addElement(normAccelerationGroup, normAccelerationMultStepper)
	newDivider(normAccelerationGroup)

	-- Speed up section
	-- Speed up main section
	local speedUpGroup = display.newGroup( )
	speedUpGroup.elY = 0
	addElement(scrollView, speedUpGroup, 9)

	local speedUpEnableRadioGroup = newRadioGroup(config, "speedUpEnableType", {"playerInput", "auto"})

	local speedUpEnableChanceStepper = newStepper(config, "speedUpEnableChance", 0.1, 20, 0.1)

	local speedUpDisableRadioGroup = newRadioGroup(config, "speedUpDisableType", {"playerInput", "auto"})

	local movesToDisableSpeedUpStepper = newStepper(config, "movesToDisableSpeedUp", 5, 50, 1)

	-- Speed up random interval section
	local movesRandomIntervalStepper = newStepper(config, "movesRandomInterval", 5, 20, 1)

	local enableMovesRandomIntervalCheckBox = newCheckBox(config, "enableMovesRandomInterval", {
		movesRandomIntervalStepper
	}) 

	local speedUpCheckBox = newCheckBox(config, "canSpeedUp", {
		speedUpEnableRadioGroup,
		speedUpEnableChanceStepper,
		speedUpDisableRadioGroup,
		movesToDisableSpeedUpStepper,
		enableMovesRandomIntervalCheckBox,
		movesRandomIntervalStepper,
	})

	addElement(speedUpGroup, speedUpCheckBox)
	addElement(speedUpGroup, speedUpEnableRadioGroup, 2)
	addElement(speedUpGroup, speedUpEnableChanceStepper)
	addElement(speedUpGroup, speedUpDisableRadioGroup, 2)
	addElement(speedUpGroup, movesToDisableSpeedUpStepper)
	addElement(speedUpGroup, enableMovesRandomIntervalCheckBox)
	addElement(speedUpGroup, movesRandomIntervalStepper)
	newDivider(speedUpGroup)

	-- Acceleration help section
	local accelerationHelpGroup = display.newGroup( )
	accelerationHelpGroup.elY = 0
	addElement(scrollView, accelerationHelpGroup, 2)

	local accelerationHelpStepper = newStepper(config, "linesToEnableAccHelp", 5, 30, 1)

	local accelerationHelpCheckBox = newCheckBox(config, "enableAccelerationHelp", {
		accelerationHelpStepper
	})

	addElement(accelerationHelpGroup, accelerationHelpCheckBox)
	addElement(accelerationHelpGroup, accelerationHelpStepper)
	newDivider(accelerationHelpGroup)

	-- Variable length section
	local variableLengthGroup = display.newGroup( )
	variableLengthGroup.elY = 0
	addElement(scrollView, variableLengthGroup, 3)

	local variableLengthChanceStepper = newStepper(config, "variableLengthChance", 0.1, 50, 0.1)

	local linesToDisableVarLengthStepper = newStepper(config, "linesToDisableVarLength", 5, 30, 1)

	local variableLengthCheckBox = newCheckBox(config, "enableVariableLength", {
		variableLengthChanceStepper,
		linesToDisableVarLengthStepper,
	})

	addElement(variableLengthGroup, variableLengthCheckBox)
	addElement(variableLengthGroup, variableLengthChanceStepper)
	addElement(variableLengthGroup, linesToDisableVarLengthStepper)
	newDivider(variableLengthGroup)

	-- Power up section
	local powerUpGroup = display.newGroup( )
	powerUpGroup.elY = 0
	addElement(scrollView, powerUpGroup, 3)

	local powerUpChanceStepper = newStepper(config, "powerUpTime", 5, 60, 1)

	local freezeTimeStepper = newStepper(config, "freezeTime", 0.1, 4, 0.1)

	local speedDownStepper = newStepper(config, "speedDown", 1, 4, 0.1)

	addElement(powerUpGroup, powerUpChanceStepper)
	addElement(powerUpGroup, freezeTimeStepper)
	addElement(powerUpGroup, speedDownStepper)

	-- Buttons section
	local startButton = newStartButton(config)
	startButton.x = 0.5 * scrollView.contentWidth
	addElement(scrollView, startButton)

	local defaultConfigButton = newDefaultConfigButton(config, scrollView, sceneGroup)
	defaultConfigButton.x = 0.5 * scrollView.contentWidth
	addElement(scrollView, defaultConfigButton)

	local scrollViewFooter = display.newRect(0, 0, 100, 100 )
	addElement(scrollView, scrollViewFooter)
end


function debugMenu:init(sceneGroup)
	local config = tabtofile.load("config") or DEFAULT_CONFIG

	local scrollView = newScrollView(sceneGroup)

	initMenuElements(config, scrollView, sceneGroup)
end

return debugMenu