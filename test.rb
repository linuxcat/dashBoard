require 'ostruct'

element = {:name => "sarndeep", :dimensions => {:height => 20, :length => 10}}



e = OpenStruct.new(element)

puts e.dimensions