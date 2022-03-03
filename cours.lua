---- TIMERS ----
local timerTir = 0
local frequenceTir = 0.5


function jeu.update(dt)
    if love.mouse.isDown(1) then
        timerTir = timerTir - dt
        if timerTir <= 0 then
            print("tir!")
            timerTir = frequenceTir
        end
    else
        timerTir = frequenceTir
    end
end

---- ROOOLLLLBAAAACKKKK ----