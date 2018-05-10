-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Gravity

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local playerBullets = {} -- Table that holds the players Bullets

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround1 = display.newImage( "./assets/sprites/land.png" )
theGround1.x = 520
theGround1.y = display.contentHeight
theGround1.id = "the ground"
physics.addBody( theGround1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "./assets/sprites/land.png" )
theGround2.x = 1520
theGround2.y = display.contentHeight
theGround2.id = "the ground" -- notice I called this the same thing
physics.addBody( theGround2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )


-- characters on screen
local sheetOptionsIdleNinja =
{
    width = 232,
    height = 439,
    numFrames = 10
}
local sheetIdleNinja = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyIdle.png", sheetOptionsIdleNinja )

local sheetOptionsRunningNinja =
{
    width = 363,
    height = 458,
    numFrames = 10
}
local sheetRunningNinja = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyRun.png", sheetOptionsRunningNinja )

local sheetOptionsShootingNinja =
{
    width = 377,
    height = 451,
    numFrames = 10
}
local sheetShootingNinja = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyThrow.png", sheetOptionsShootingNinja )

local sheetOptionsJumpingNinja =
{
    width = 362,
    height = 483,
    numFrames = 10
}
local sheetJumpingNinja = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyJump.png", sheetOptionsJumpingNinja )


-- sequences table
local sequenceDataNinja = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 0,
        sheet = sheetIdleNinja
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 1,
        sheet = sheetRunningNinja
    },
    {
        name = "shoot",
        start = 1,
        count = 10,
        time = 500,
        loopCount = 1,
        sheet = sheetShootingNinja
    },
    {
        name = "jump",
        start = 1,
        count = 10,
        time = 2000,
        loopCount = 1,
        sheet = sheetJumpingNinja
    }
}

local ninja = display.newSprite( sheetIdleNinja, sequenceDataNinja )
ninja.id = "ninja"
ninja.isFixedRotation = true
physics.addBody( ninja, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } ) 
ninja.x = 400
ninja.y = 1000
ninja:setSequence( "idle" )
ninja:play()

-- robot
local sheetOptionsIdleRobot =
{
    width = 567,
    height = 556,
    numFrames = 10
}
local sheetIdleRobot = graphics.newImageSheet( "./assets/spritesheets/robot/robotIdle.png", sheetOptionsIdleRobot )

local sheetOptionsDeadRobot =
{
    width = 562,
    height = 519,
    numFrames = 10
}
local sheetDeadRobot = graphics.newImageSheet( "./assets/spritesheets/robot/robotDead.png", sheetOptionsDeadRobot )

-- sequences table
local sequenceDataRobot = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 0,
        sheet = sheetIdleRobot
    },
    {
        name = "dead",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 1,
        sheet = sheetDeadRobot
    }
}

local robot = display.newSprite( sheetIdleRobot, sequenceDataRobot )
robot.id = "enemy"
robot.isFixedRotation = true
physics.addBody( robot, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } ) 
robot.x = 1800
robot.y = 1000
robot:setSequence( "idle" )
robot:play()


local leftArrow = display.newImage( "./assets/sprites/leftButton.png" )
leftArrow.x = 140
leftArrow.alpha = 0.5
leftArrow.y = display.contentHeight - 80
leftArrow.id = "left arrow"

local rightArrow = display.newImage( "./assets/sprites/rightButton.png" )
rightArrow.x = 400
rightArrow.alpha = 0.5
rightArrow.y = display.contentHeight - 80
rightArrow.id = "right arrow"

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

 
local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

-- if character falls off the end of the world, respawn back to where it came from
local function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if ninja.y > display.contentHeight + 500 then
        ninja.x = display.contentCenterX - 200
        ninja.y = display.contentCenterY
    end
end

local function checkPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 , -1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "enemy" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "enemy" ) ) then
 			
 			--remove character
            --if obj1.id == "enemy" then
            --    obj1:removeSelf()
            --    obj1 = nil
            --else
            --    obj2:removeSelf()
            --    obj2 = nil
            --end
            robot:setSequence("dead")
            robot:play()

            -- remove the bullet
 			local bulletCounter = nil
 			
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

            -- make an explosion happen
            -- Table of emitter parameters
			local emitterParams = {
			    startColorAlpha = 1,
			    startParticleSizeVariance = 250,
			    startColorGreen = 0.3031555,
			    yCoordFlipped = -1,
			    blendFuncSource = 770,
			    rotatePerSecondVariance = 153.95,
			    particleLifespan = 0.7237,
			    tangentialAcceleration = -1440.74,
			    finishColorBlue = 0.3699196,
			    finishColorGreen = 0.5443883,
			    blendFuncDestination = 1,
			    startParticleSize = 400.95,
			    startColorRed = 0.8373094,
			    textureFileName = "./assets/sprites/fire.png",
			    startColorVarianceAlpha = 1,
			    maxParticles = 256,
			    finishParticleSize = 540,
			    duration = 0.25,
			    finishColorRed = 1,
			    maxRadiusVariance = 72.63,
			    finishParticleSizeVariance = 250,
			    gravityy = -671.05,
			    speedVariance = 90.79,
			    tangentialAccelVariance = -420.11,
			    angleVariance = -142.62,
			    angle = -244.11
			}
			local emitter = display.newEmitter( emitterParams )
			emitter.x = whereCollisonOccurredX
			emitter.y = whereCollisonOccurredY

        end
    end
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
        	x = -50, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
        	x = 200, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 1000 -- move in a 1/10 of a second
        	} )
        ninja:setSequence("walk")
        ninja:play()
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        ninja:setLinearVelocity( 0, -750 )
        ninja:setSequence( "jump" )
        ninja:play()
    end

    return true
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- start ninja animation
        ninja:setSequence( "shoot" )
        ninja:play()
        -- make a bullet appear
        local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
        aSingleBullet.x = ninja.x
        aSingleBullet.y = ninja.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.isFixedRotation = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

-- rest to idle 
local function resetToIdle (event)
    if event.phase == "ended" then
        ninja:setSequence("idle")
        ninja:play()
    end
end


leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )

jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

ninja:addEventListener("sprite", resetToIdle)

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )