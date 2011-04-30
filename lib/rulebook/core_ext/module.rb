require 'meta_tools'

#++
# Should this be class Object?
#--
class Module
  # This declares that the current class has a rulebook 
  # with rules that it wants it's instances to follow.
  #
  # I picked this name because the probability of someone needing the method 
  # 'follows_the_rules!' (with a bang) is slim... hopefully.
  #
  # This adds the following method:
  #   User#rulebook
  #     Returns the RuleBook instance that contains the defined rules. 
  def follows_the_rules!
    extend(MetaTools)
    extend(Rulebook::ClassMethods)
    include(Rulebook::InstanceMethods)
  end
end