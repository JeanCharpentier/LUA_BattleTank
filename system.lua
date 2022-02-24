function limit(v,c1,c2)
    local value = v
    if value < c1 then
        value = c1
    elseif value > c2 then
        value = c2
    end
    return value
end