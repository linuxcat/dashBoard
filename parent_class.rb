class ParentClass

class << self

  def element(method, loc)
    locator = Proc.new { puts loc }
    tap = Proc.new {|x| x.concat('another hello')}

    define_method(method) do
      puts loc
    end

    define_singleton_method(method) do
      locator.call
    end






  end


end

end

