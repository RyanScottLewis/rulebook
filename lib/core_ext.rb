class Module
  # This declares that the current class has a rulebook 
  # with rules that it wants it's instances to follow.
  #
  # I picked this name because the probability of someone needing the method 
  # 'follows_the_rules!' (with a bang) is slim... hopefully.
  def follows_the_rules!
    extend(MetaTools)
    include(MetaTools)
    
    meta_def(:def_class_rule) do |what_to_capture, &class_block|

      class_eval { @rulebook ||= Rulebook.new }.add(what_to_capture, &class_block)

      # unless respond_to?(:method_missing)
        meta_def(:method_missing) do |meth, *args, &block|

          matching_rules = @rulebook[meth]

          unless matching_rules.empty?
            rule = matching_rules.first
            rule_block = rule.block
            rule_captures = rule[meth].captures || []
            rule_arity = rule_block.arity == -1 ? 0 : rule_block.arity
            # The above removes the possibility of optional arguments

            # Define the method
            unless meta_class.respond_to?(meth)
              meta_def(meth) do |*rule_args|
                rule_args = (rule_captures + rule_args).take(rule_arity)
                instance_exec(*rule_args, &rule_block)
              end
            end

            send(meth, *args, &block)
          else
            super(meth, *args, &block)
          end # matching_rules.empty?

        end # meta_def(:method_missing)

      # end # respond_to?(:method_missing)
      
    end # def_class_rule
    
    meta_def(:def_rule) do |what_to_capture, &class_block|

      (@rulebook ||= Rulebook.new).add(what_to_capture, &class_block)

      # unless respond_to?(:method_missing)
        define_method(:method_missing) do |meth, *args, &block|

          matching_rules = self.class.instance_variable_get(:@rulebook)[meth] 

          unless matching_rules.empty?
            rule = matching_rules.first
            rule_block = rule.block
            rule_captures = rule[meth].captures || []
            rule_arity = rule_block.arity == -1 ? 0 : rule_block.arity
            # The above removes the possibility of optional arguments

            # Define the method
            unless meta_class.respond_to?(meth)
              meta_def(meth) do |*rule_args|
                rule_args = (rule_captures + rule_args).take(rule_arity)
                instance_exec(*rule_args, &rule_block)
              end
            end

            send(meth, *args, &block)
          else
            super(meth, *args, &block)
          end # matching_rules.empty?

        end # meta_def(:method_missing)

      # end # respond_to?(:method_missing)

    end # def_rule
    
  end # follows_the_rules!
  
end # Module