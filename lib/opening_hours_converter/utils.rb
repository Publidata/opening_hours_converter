class Array
  def equals(array)
    return false if !array.instance_of?(Array)
    return false if array.length != length
    each_with_index do |val, i|
      if val.instance_of?(Array)
        return false unless val.equals(array[i])
      end
      return false if val != array[i]
    end
    return true
  end
end
