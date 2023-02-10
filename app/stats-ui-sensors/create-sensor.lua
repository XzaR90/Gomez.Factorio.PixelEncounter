---comment
---@param caption table
---@param name string
---@return {name:string,caption:table, color:{r:number,g:number,b:number, a: number}}
return function(caption, name)
    return { caption = caption or {}, name = name or "", color = nil  }
end