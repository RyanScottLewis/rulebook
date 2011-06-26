class Rulebook
  module InstanceMethods
    def method_missing(meth, *args, &blk)
      # Classes and instances find their rulebook differently.
      begin
        rulebook = self.class.rulebook
      rescue NoMethodError
        rulebook = metaclass.rulebook
      end

      rules = rulebook.rules_that_match_against(meth)
      
      pp rules
      
      unless rules.nil?
        # The first defined rule that matches the method is run
        rule = rules.first
        
        captures = rule[meth].captures || []
        block = rule.block
      
        # Remove the possibility of optional arguments
        arity = block.arity == -1 ? 0 : block.arity

        # Define the method
        meta_def(meth) do |*args|
          instance_exec(*(captures + args).take(arity), &block)
        end 
      
        # Call the method and return the result
        return send(meth, *args, &block)
      else
        super
      end
    end
  end
end