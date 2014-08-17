lambda {

  setups = []
  events = []

  Kernel.send :define_method, :event do |description, &block|
    events << {:description => description, :condition => block}
  end

  Kernel.send :define_method, :setup do |&block|
    setups << block
  end

  #-------------------------------------------------
  # This creates
  # def each_event(&block)
  #
  # end


  Kernel.send :define_method, :each_event do |&block|
    events.each do |event|
        block.call(event)
    end
  end

  Kernel.send :define_method, :each_setup do |&block|
    setups.each do |setup|
      block.call(setup)
    end
  end

}.call

#This loads the file and executes the dynamic methods that have been crated in the lambda above, populating events and setups.
load 'events.rb'

each_event do |i|
  env = Object.new

  each_setup do |s|
    env.instance_eval &s
  end

  puts "ALERT: #{i[:description]}" if env.instance_eval &(i[:condition])



end

sarndeeps = [{:value => 1,:block => Proc.new {puts "calling block from an array"}},{:value => 2,:block => Proc.new {puts "calling block from an array again"}}]


Kernel.send :define_method, :sarndeepical do |&b|
  sarndeeps.each do |sn|
    b.call(sn)
  end
end

sarndeepical do |me|
  puts me[:block].call
end


test_proc = Proc.new {|argument| puts argument}


test_proc.call("this is the arugment")
