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
      unless rules.nil?
        rules.each do |rule|
          # =S Run all matched rules or run first matched rule...?
          # rule = rules.first

          captures = rule[meth].captures || []
          block = rule.block
        
          # Remove the possibility of optional arguments
          arity = block.arity == -1 ? 0 : block.arity

          # Define the method
          meta_def(meth) do |*args|
            instance_exec(*(captures + args).take(arity), &block)
          end 

          # klass = self.class
          # klass.send(:define_method, meth) do |*args|
          #   instance_exec(*(captures + args).take(arity), &block)
          # end 
        
          # Call the method and return the result
          return send(meth, *args, &block)
        end
      else
        super
      end
    end
  end
end