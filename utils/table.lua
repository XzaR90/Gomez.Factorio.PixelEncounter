local TableUtil = {}

TableUtil.CombineStrategy = {first = 0, second = 1}

function TableUtil.merge(t1, t2, mergeType)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            TableUtil.merge(t1[k], t2[k], mergeType)
        else
            if mergeType == TableUtil.CombineStrategy.second then 
              t1[k] = v
            elseif mergeType == TableUtil.CombineStrategy.first and (not t1[k] or type(t1[k]) ~= type(v)) then 
              t1[k] = v
            end
        end
    end

    return t1
end

function TableUtil.copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[TableUtil.copy(k, s)] = TableUtil.copy(v, s) end
    return res
  end

  function TableUtil.get_length(tbl)
    local count = 0
    for _ in pairs(tbl) do 
      count = count + 1 
    end
    return count
  end

table.get_length = TableUtil.get_length
table.copy = TableUtil.copy
table.merge = TableUtil.merge

return TableUtil