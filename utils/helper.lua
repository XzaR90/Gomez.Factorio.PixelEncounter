local HelperUtil = {}

function HelperUtil.ternary ( cond , T , F )
    if cond then return T else return F end
end

return HelperUtil
