--
-- For more information on emitter properties, see the EmitterObject documentation at:
-- https://docs.coronalabs.com/api/type/EmitterObject/index.html
--

local emitterParams = {

	-- General emitter properties
	textureFileName = "particle.png",
	maxParticles = 256,
	angle = -244.11,
	angleVariance = -142.62,
	emitterType = 0,  -- Change to 1 for radial emitter type (see below)
	duration = -1,
	yCoordFlipped = -1, -- may or may not need this value

	-- Point/line/field emitter properties
	speed = 0,
	speedVariance = 90.79,
	sourcePositionVariancex = 0,
	sourcePositionVariancey = 0,
	gravityx = 0,
	gravityy = -671.05,
	radialAcceleration = 0,
	radialAccelVariance = 0,
	tangentialAcceleration = -144.74,
	tangentialAccelVariance = -92.11,

	-- Radial emitter properties
	maxRadius = 0,
	maxRadiusVariance = 72.63,
	minRadius = 0,
	minRadiusVariance = 0,
	rotatePerSecond = 0,
	rotatePerSecondVariance = 153.95,

	-- General particle properties
	particleLifespan = 0.7237,
	particleLifespanVariance = 0,
	startParticleSize = 50.95,
	startParticleSizeVariance = 53.47,
	finishParticleSize = 64,
	finishParticleSizeVariance = 64,
	rotationStart = 0,
	rotationStartVariance = 0,
	rotationEnd = 0,
	rotationEndVariance = 0,
	
	-- Color/alpha particle properties
	startColorRed = 0,
	startColorGreen = 0,
	startColorBlue = 0,
	startColorAlpha = 0,
	startColorVarianceRed = 0.8373094,
	startColorVarianceGreen = 0.3031555,
	startColorVarianceBlue = 0,
	startColorVarianceAlpha = 0,
	finishColorRed = 1,
	finishColorGreen = 1,
	finishColorBlue = 1,
	finishColorAlpha = 1,
	finishColorVarianceRed = 1,
	finishColorVarianceGreen = 1,
	finishColorVarianceBlue = 1,
	finishColorVarianceAlpha = 1,
	
	-- Blend mode properties
	blendFuncSource = 770,
	blendFuncDestination = 1
}

return emitterParams