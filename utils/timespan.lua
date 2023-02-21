--- Not actual date time
local TimeSpan = {}

local second = 60
local minute = second * 60
local hour = minute * 60
local day = hour * 24
local days_90 = day * 90

TimeSpan = {
    Second = second,
    Minute = minute,
    Hour = hour,
    Day = day,
    Days_90 = days_90
}

return TimeSpan;