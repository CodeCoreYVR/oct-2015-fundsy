class Hello

  def instance_method
    puts self.object_id
  end

  def  .class_method
    puts self
  end

end

a = Hello.new

puts a.object_id

a.instance_method   # this will print the same object id of a.object_id
Hello.class_method  # this will print the class
