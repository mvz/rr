module RR
  class MockCreator
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    
    def initialize(space, subject)
      @space = space
      @subject = subject
      yield(self) if block_given?
    end

    protected
    def method_missing(method_name, *args, &returns)
      double = @space.create_double(@subject, method_name)
      scenario = @space.create_scenario(double)
      scenario.with(*args).once.returns(&returns)
      scenario
    end
  end
end
