
-- Abstract: Star Explorer
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Created by: Andrew Barrett on 8/21/2019
---------------------------------------------------------------------------------------

local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Reserver channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=1 } )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Construct a Fire", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local letterboxWidth = math.abs( display.screenOriginX )
local shapeCenterY = display.contentCenterY - 150
local currentShapeIndex = 1
local selectShapeButton
local pickerWheel
local currentShape
local prevShape
local tempShape

-- Variables for Easter Eggs =D
local eastereggLabel
-- local triangleShape = false -- Maybe some ship skin unlockable?
local fillShape = false
local strokeShape = false
local fireStar = false

-- Unlocking steppers
local angleSlider = false
local speedSlider = false
local gravityXSlider = false
local gravityYSlider = false
local gamePartiallyUnlocked = false

-- Unlocking Star Explorer game
local redStepper = false
local greenStepper = false
local blueStepper = false
local alphaStepper = false
local gameUnlocked = false

-- Emitter
local emitterValues = {
	{ property="gravityy", label="Y Gravity", current=0, range=4000, offset=-2000, multiplier=40 },
	{ property="gravityx", label="X Gravity", current=0, range=4000, offset=-2000, multiplier=40 },
	{ property="speed", label="Speed", current=0, range=1000, offset=0, multiplier=10 },
	{ property="angle", label="Angle", current=-90, range=360, offset=-180, multiplier=3.6 }	
}
local lbX = display.screenOriginX
local lbY = display.screenOriginY
local labelAlignX = 140 + lbX
local valueAlignX = 760 - lbX
local sliderWidth = 485 - lbX - lbX

-- Picker wheel column labels
local label1 -- Shape
local label2 -- Fill
local label3 -- Stroke

-- Configure image sheet for steppers
local sheetOptions = {
	width = 77,
	height = 40,
	numFrames = 20,
	sheetContentWidth = 385,
	sheetContentHeight = 160
}
local stepperSheet = graphics.newImageSheet( "stepperSheet.png", sheetOptions )

-- Load module containing table of emitter params
local emitterParams = require( "emitter" )

-- Function to show emitter, sliders, steppers
local function displayEmitterBasics()

	-- Create and position emitter object
	local emitter = display.newEmitter( emitterParams )
	-- Center the emitter within the content area
	emitter.x = display.contentCenterX
	emitter.y = shapeCenterY
	mainGroup:insert( emitter )

	-- Slider vars
	local index
	local propertyName
	local propertyValue
	local label
	local labelValue
	local slider
	local hasSliderBeenCreated = false

	-- Stepper vars
	local propertyNameStart
	local propertyNameFinish
	local newVal
	local count
	local steppers
	local propertyValue
	local stepper
	local labelStep
	local hasStepperBeenCreated = false

	local function sliderListener( event )

		index = emitterValues[event.target.indexValue]
		print( "index = ", index )
		propertyName = index.property
		print( "pN = ", propertyName )
		propertyValue = ( event.value * index.multiplier ) + index.offset
		print( "pV = ", propertyValue )
		event.target.valueLabel.text = propertyValue

		-- Update emitter property
		emitter[propertyName] = propertyValue

		-- These booleans are part of the piece when unlocking our Star Explorer Game
		if ( propertyName == "angle" and propertyValue == 90 ) then
			angleSlider = true
			print( "angleSlider = ", angleSlider )
		elseif ( propertyName == "speed" and propertyValue == 1000 ) then
			speedSlider = true
			print( "speedSlider = ", speedSlider )
		elseif ( propertyName == "gravityx" and propertyValue == 0 ) then
			gravityXSlider = true
			print( "gravityXSlider = ", gravityXSlider )
		elseif ( propertyName == "gravityy" and propertyValue == 0 ) then
			gravityYSlider = true
			print( "gravityYSlider = ", gravityYSlider )
		end
	
		-- Get the right slider values for the easter egg
		if ( fireStar == true and angleSlider == true and speedSlider == true and gravityXSlider == true and gravityYSlider == true ) then
			gamePartiallyUnlocked = true

			if ( gamePartiallyUnlocked == true ) then

				if ( hasStepperBeenCreated == false ) then
					print( "Holy Smokes, You Found the Space Settings = ", gamePartiallyUnlocked )
					sampleUI:newUI( { theme="darkgrey", title="Now Press the Colorful Buttons", showBuildNum=false } )
					display.remove( eastereggLabel )

					local function onStepperPress( event )

						print( "eti = ", event.target.id )
						propertyNameStart = "startColor" .. event.target.id
						propertyNameFinish = "finishColor" .. event.target.id

						newVal = event.value / 10
						print( "nV = ", newVal )

						-- Set emitter values based on property
						if ( "increment" == event.phase or "decrement" == event.phase ) then
							emitter[propertyNameStart] = newVal
							emitter[propertyNameFinish] = newVal
						end
						-- Update stepper value label
						event.target.valueLabel.text = string.format( "%3.2f", newVal )

						-- Track the values of each color stepper and we want 4x(1.00) steppers to unlock our game
						if ( event.target.id == "Red" and newVal == 1 ) then
							redStepper = true
							print( "redStepper = ", redStepper )
						elseif ( event.target.id == "Green" and newVal == 1 ) then
							greenStepper = true
							print( "greenStepper = ", greenStepper )
						elseif ( event.target.id == "Blue" and newVal == 1 ) then
							blueStepper = true
							print( "blueStepper = ", blueStepper )
						elseif ( event.target.id == "Alpha" and newVal == 1 ) then
							alphaStepper = true
							print( "alphaStepper = ", alphaStepper )
						end

						-- Game: Star Explorer
						if ( fireStar == true and gamePartiallyUnlocked == true and
							redStepper == true and greenStepper == true and blueStepper == true and alphaStepper == true ) then
							-- Star Explorer game booleans go here
							gameUnlocked = true
							print( "Holy Smokes, You Unlocked a Game! = ", gameUnlocked )
							sampleUI:newUI( { theme="darkgrey", title="Game Unlocked: Star Explorer", showBuildNum=false } )
							display.remove( mainGroup )

							if ( gameUnlocked == true ) then
								-- Go to the menu screen
								print( "Going to menu screen" )
								composer.gotoScene( "menu" )
							end
						end
					end

					-- Stepper controls and labels	
					count = 0
					steppers = { "Red", "Green", "Blue", "Alpha" }
					for j = 1,#steppers do

						propertyValue = "startColor" .. steppers[j]
						stepper = widget.newStepper({
							id = steppers[j],
							x = -1 + (j*152),
							y = 950 - lbY,
							initialValue = emitter[propertyValue] * 10,
							minimumValue = 1,
							maximumValue = 10,
							timerIncrementSpeed = 200,
							sheet = stepperSheet,
							defaultFrame = 1 + count,
							noMinusFrame = 2 + count,
							noPlusFrame = 3 + count,
							minusActiveFrame = 4 + count,
							plusActiveFrame = 5 + count,
							onPress = onStepperPress
						})
						labelStep = display.newText( mainGroup, string.format( "%3.2f", emitter[propertyValue] ), stepper.x, stepper.y+60, appFont, 32 )
						stepper.valueLabel = labelStep
						print( "making steppers= ", stepper.valueLabel )
						mainGroup:insert( stepper )
						count = count + 5
					end
					hasStepperBeenCreated = true
				end
			end
		end
	end

	-- This will allow a stepper to display if we do not select the fireStar for playing around
	if ( fireStar == false ) then

		local function sliderListener( event )

			index = emitterValues[event.target.indexValue]
			propertyName = index.property
			propertyValue = ( event.value * index.multiplier ) + index.offset
			event.target.valueLabel.text = propertyValue

			-- Update emitter property
			emitter[propertyName] = propertyValue
		end

		local function onStepperPress( event )

			propertyNameStart = "startColor" .. event.target.id
			propertyNameFinish = "finishColor" .. event.target.id

			newVal = event.value / 10

			-- Set emitter values based on property
			if ( "increment" == event.phase or "decrement" == event.phase ) then
				emitter[propertyNameStart] = newVal
				emitter[propertyNameFinish] = newVal
			end
			-- Update stepper value label
			event.target.valueLabel.text = string.format( "%3.2f", newVal )
		end

		-- Slider controls and labels
		for i = 1,#emitterValues do
			label = display.newText( mainGroup, emitterValues[i].label, labelAlignX, 900-(i*72)-lbY, appFont, 32 )
			label.anchorX = 1
			labelValue = display.newText( mainGroup, emitterValues[i].current, valueAlignX, label.y, appFont, 32 )
			labelValue:setFillColor( 0.7 )
			labelValue.anchorX = 1
			slider = widget.newSlider(
			{
				id = emitterValues[i].property,
				left = labelAlignX + 40,
				width = sliderWidth,
				value = ( ( emitterValues[i].current - emitterValues[i].offset ) / emitterValues[i].range ) * 100,
				listener = sliderListener
			})
			slider.y = label.y
			slider.indexValue = i
			slider.valueLabel = labelValue
			mainGroup:insert( slider )
		end

		-- Stepper controls and labels
		count = 0
		steppers = { "Red", "Green", "Blue", "Alpha" }
		for j = 1,#steppers do

			propertyValue = "startColor" .. steppers[j]
			stepper = widget.newStepper({
				id = steppers[j],
				x = -1 + (j*152),
				y = 950 - lbY,
				initialValue = emitter[propertyValue] * 10,
				minimumValue = 1,
				maximumValue = 10,
				timerIncrementSpeed = 200,
				sheet = stepperSheet,
				defaultFrame = 1 + count,
				noMinusFrame = 2 + count,
				noPlusFrame = 3 + count,
				minusActiveFrame = 4 + count,
				plusActiveFrame = 5 + count,
				onPress = onStepperPress
			})
			labelStep = display.newText( mainGroup, string.format( "%3.2f", emitter[propertyValue] ), stepper.x, stepper.y+60, appFont, 32 )
			stepper.valueLabel = labelStep
			mainGroup:insert( stepper )
			count = count + 5
			print( "count = ", count )
		end
	elseif ( fireStar == true and gamePartiallyUnlocked == false and hasSliderBeenCreated == false ) then
		-- Slider controls and labels
		for i = 1,#emitterValues do
			label = display.newText( mainGroup, emitterValues[i].label, labelAlignX, 900-(i*72)-lbY, appFont, 32 )
			label.anchorX = 1
			labelValue = display.newText( mainGroup, emitterValues[i].current, valueAlignX, label.y, appFont, 32 )
			labelValue:setFillColor( 0.7 )
			labelValue.anchorX = 1
			slider = widget.newSlider({
				id = emitterValues[i].property,
				left = labelAlignX + 40,
				width = sliderWidth,
				value = ( ( emitterValues[i].current - emitterValues[i].offset ) / emitterValues[i].range ) * 100,
				listener = sliderListener
			})
			slider.y = label.y
			slider.indexValue = i
			print( "sliderindexvalue=", slider.indexValue )
			slider.valueLabel = labelValue
			mainGroup:insert( slider )
		end
		hasSliderBeenCreated = true
	end
end

-- Function to update shape
local function updateShape( event )

	local values = pickerWheel:getValues()
	local swapShapes = false

	-- Handle selection of new shape
	if ( event and event.column == 1 ) then
		if ( event.row ~= currentShapeIndex ) then
			currentShapeIndex = event.row
			if ( currentShapeIndex == 1 ) then
				starShape = false
				tempShape = display.newRect( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, 440, 320 )
			elseif ( currentShapeIndex == 2 ) then
				starShape = false
				tempShape = display.newRoundedRect( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, 440, 320, 32 )
			elseif ( currentShapeIndex == 3 ) then
				starShape = false
				tempShape = display.newCircle( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, 190 )
			elseif ( currentShapeIndex == 4 ) then
				starShape = false
				tempShape = display.newPolygon( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, { 0,-150,190,180,-190,180 } )
			elseif ( currentShapeIndex == 5 ) then
				starShape = true
				print( "Selected star shape = ", starShape )
				tempShape = display.newPolygon( mainGroup, display.contentCenterX+display.actualContentWidth, shapeCenterY, { 0,-198,48.6,-63,189,-63,77.4,28.8,117,162,0,81,-117,162,-77.4,28.8,-189,-63,-48.6,-63 } )
			end
			tempShape.strokeWidth = 40
			prevShape = currentShape
			currentShape = tempShape
			tempShape = nil
			swapShapes = true
		end
	end

	-- Handle fill
	local fillValue
	if ( event and event.column == 2 ) then
		fillValue = event.row
	else
		fillValue = values[2].index
	end
	if ( fillValue == 1 ) then
		fillShape = false
		currentShape.fill = { 0.9, 0, 0.2 }
	elseif ( fillValue == 2 ) then
		fillShape = false
		currentShape.fill = { type="gradient", color1={ 0.9, 0, 0.2 }, color2={ 0.3, 0, 0.06 } }
	elseif ( fillValue == 3 ) then
		fillShape = false
		currentShape.fill = { type="image", filename="fire-background.png" }
		-- Calculate scale factor for the filled texture
		local scaleFactorX, scaleFactorY = 1, 1
		if ( currentShape.width > currentShape.height ) then
			scaleFactorY = currentShape.width / currentShape.height
		else
			scaleFactorX = currentShape.height / currentShape.width
		end
		currentShape.fill.scaleX = scaleFactorX
		currentShape.fill.scaleY = scaleFactorY
	elseif ( fillValue == 4 ) then
		fillShape = true
		print( "Filling your shape = ", fillShape )
		currentShape.fill = { type="image", filename="fire-texture.jpg" }
		-- Calculate scale factor for the filled texture
		local scaleFactorX, scaleFactorY = 1, 1
		if ( currentShape.width > currentShape.height ) then
			scaleFactorY = currentShape.width / currentShape.height
		else
			scaleFactorX = currentShape.height / currentShape.width
		end
		currentShape.fill.scaleX = scaleFactorX
		currentShape.fill.scaleY = scaleFactorY
	end

	-- Handle stroke
	local strokeValue
	if ( event and event.column == 3 ) then
		strokeValue = event.row
	else
		strokeValue = values[3].index
	end
	if ( strokeValue == 1 ) then
		strokeShape = false
		currentShape.stroke = { 163, 162, 165 }
	elseif ( strokeValue == 2 ) then
		strokeShape = false
		currentShape.stroke = { type="gradient", color1={ 1, 0.5, 0.2 }, color2={ 161, 165, 162 } }
	elseif ( strokeValue == 3 ) then
		strokeShape = false
		currentShape.stroke = { type="image", filename="brick-texture.jpg" }
	elseif ( strokeValue == 4 ) then
		strokeShape = false
		currentShape.stroke = { type="image", filename="fire-background.png" }
	elseif ( strokeValue == 5 ) then
		strokeShape = true
		print ( "Handling your stroke ;P = ", strokeShape )
		currentShape.stroke = { type="image", filename="fire-texture.jpg" }
	end

	-- Swap shape positions (if necessary)
	if ( swapShapes == true and prevShape and currentShape ) then
		transition.to( prevShape, { time=500, x=display.contentCenterX-display.actualContentWidth, transition=easing.inQuart,
			onComplete = function()
				display.remove( prevShape )
				prevShape = nil
			end
		})
		transition.to( currentShape, { time=500, delay=320, x=display.contentCenterX, transition=easing.outQuart } )
	end

	-- Easter Egg # 1
	if ( starShape == true and fillShape == true and strokeShape == true ) then
		fireStar = true
		sampleUI:newUI( { theme="darkgrey", title="Send the Star to Space", showBuildNum=false } )
		print( "fireStar = ", fireStar )
		-- TODO: Make this to showPopup could be a string or an image/url
		print ( "CONGRATULATIONS! YOU HAVE FOUND A BURNING HOT STAR! = ", fireStar )
		eastereggLabel = display.newText( { parent=mainGroup, text="Bonus Unlocked: Glowing Hot Star", x=display.contentCenterX, y=0, width=0, height=0, font=appFont, fontSize=30, align="center" } )
		eastereggLabel:setFillColor( 1, 0, 0 )
		mainGroup:insert( eastereggLabel )
		mainGroup:remove( selectShapeButton )
		mainGroup:remove( label1 )
		mainGroup:remove( label2 )
		mainGroup:remove( label3 )
		mainGroup:remove( pickerWheel )
		print( "Showing emitter" )
		displayEmitterBasics()
	end
end

-- Create picker wheel for shapes, fill options, and stroke options
local columnData = {
	{
		align = "center",
		width = 270,
		labelPadding = 40,
		startIndex = 1,
		labels = { "Rectangle", "Rounded Rect.", "Circle", "Triangle", "Star" }
	},
	{
		align = "center",
		width = 116,
		startIndex = 1,
		labels = { "solid", "gradient", "fire", "hot" }
	},
	{
		align = "center",
		width = 190,
		startIndex = 1,
		labels = { "solid", "gradient", "brick", "fire", "burning" }
	}
}
pickerWheel = widget.newPickerWheel({
	columns = columnData,
	style = "resizable",
	width = display.actualContentWidth,
	rowHeight = 64,
	font = appFont,
	fontSize = 30,
	onValueSelected = updateShape
})
pickerWheel.x = display.contentCenterX
pickerWheel.y = display.contentHeight - display.screenOriginY - 80
mainGroup:insert( pickerWheel )

-- Function to handle Construct:button events
local function handleButtonEvent( event )
	 
	if ( "ended" == event.phase ) then
	    print( "Button was pressed and released" )
	    -- do stuff here
	    mainGroup:remove( selectShapeButton )
		mainGroup:remove( label1 )
		mainGroup:remove( label2 )
		mainGroup:remove( label3 )
		mainGroup:remove( pickerWheel )
		--then display other sliders
		sampleUI:newUI( { theme="darkgrey", title="Adjust the Fire Settings or Color", showBuildNum=false } )
		displayEmitterBasics()
	end
end

-- Select shape button widget
selectShapeButton = widget.newButton({
	label = "Construct",
    onEvent = handleButtonEvent,
    emboss = false,
    -- Properties for a rounded rectangle button
    shape = "roundedRect",
    width = 500,
    height = 80,
    cornerRadius = 4,
    fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
    strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
    strokeWidth = 8
})
selectShapeButton.x = display.contentCenterX
selectShapeButton.y = shapeCenterY + 280
mainGroup:insert( selectShapeButton )

-- Picker wheel column labels (above)
label1 = display.newText( { parent=mainGroup, text="Shape", x=200-letterboxWidth, y=pickerWheel.contentBounds.yMin-36, width=190, height=0, font=appFont, fontSize=30, align="center" } )
label1:setFillColor( 0.8 )
label1.anchorX = 0
label2 = display.newText( { parent=mainGroup, text="Fill", x=384-letterboxWidth, y=pickerWheel.contentBounds.yMin-36, width=190, height=0, font=appFont, fontSize=30, align="center" } )
label2:setFillColor( 0.8 )
label2.anchorX = 0
label3 = display.newText( { parent=mainGroup, text="Stroke", x=568-letterboxWidth, y=pickerWheel.contentBounds.yMin-36, width=190, height=0, font=appFont, fontSize=30, align="center" } )
label3:setFillColor( 0.8 )
label3.anchorX = 0

-- Create default current shape
currentShape = display.newRect( mainGroup, display.contentCenterX, shapeCenterY, 440, 320 )
currentShape.strokeWidth = 40
updateShape()
print( "Shape has been updated" )