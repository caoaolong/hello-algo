strings = {}

function strings.startsWith(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

return strings