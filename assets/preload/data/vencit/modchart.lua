function start(song)

end

function update(elapsed)
    if curBeat < 141 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 3 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 3 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
    end
    if curBeat > 141 and curBeat < 208 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 3 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
	    if curBeat > 208 and curBeat < 272 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 7 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 3 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
	    if curBeat > 272 and curBeat < 304 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 9 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 3 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
	    if curBeat > 304 and curBeat < 560 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 12 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 6 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
	    if curBeat > 560 then
        local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 15 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 15 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
	end
end

function beatHit(beat)

end

function stepHit(step)

end

function playerTwoTurn()

end

function playerOneTurn()

end