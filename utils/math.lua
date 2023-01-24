local MathUtil = {}

math.round = function(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

return MathUtil