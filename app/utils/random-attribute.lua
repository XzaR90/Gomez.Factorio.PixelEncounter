local Attributes = require 'app.character-base.attributes'

local RandomAttribute = {}

local total_attributes = 4

local attributeArr = {
    'dexterity',
    'intelligence',
    'endurance',
    'strength'
}

local function remaining_points_split_by_attributes(remaining_ap)
    if remaining_ap > total_attributes then
        return math.floor(remaining_ap / total_attributes)
    end

    return remaining_ap
end

function RandomAttribute.random(level)
    level = math.ceil(level)
    local total_ap = Attributes.max_points_by_level(level)
    local remaining_ap = total_ap
    local attributes = Attributes.create()

    while (remaining_ap > 0)
    do
        local random_attribute = attributeArr[math.random(1,#attributeArr)]
        local ap_to_spend = remaining_points_split_by_attributes(remaining_ap)
        ap_to_spend = math.random(1, ap_to_spend)
        attributes[random_attribute] = attributes[random_attribute] + ap_to_spend
        remaining_ap = remaining_ap - ap_to_spend
    end

    return attributes
end

return RandomAttribute