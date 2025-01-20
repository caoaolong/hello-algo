tb = {}


function tb.contains(array, element)
    for i = 1, #array do
        if array[i] == element then
            return true  -- 如果找到了元素，返回true
        end
    end
    return false  -- 如果未找到元素，返回false
end

return tb