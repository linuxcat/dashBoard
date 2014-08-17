require_relative './parent_class'
class ChildClass < ParentClass

  element :title, "text_locator"
  element :login, "this is a login"


  class << self

    def title?
      title
    end
  end

end

child = ChildClass.new

child.login

ChildClass.title?

array = "Done signing the test server. Moved it to test_servers/f07329c48c54fef51ff6bf2492d47998_0.4.20.apk".split("to ")


puts array[1]