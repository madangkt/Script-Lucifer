
console = {
  say = function(str)
    return getBot():say(tostring(str))
  end
}

find = {
  item = function(int)
    return getBot():getInventory():getItemCount(int)
  end
}
