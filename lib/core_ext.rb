require 'meta_tools'

class Module
  # This declares that the current class has a rulebook 
  # with rules that it wants it's instances to follow.
  #
  # I picked this name because the probability of someone needing the method 
  # 'follows_the_rules!' (with a bang) is slim... hopefully.
  def follows_the_rules!
    extend(MetaTools)
    meta_def(:rulebook) do
      @rulebook ||= Rulebook.new
    end
    include(Rulebook::InstanceMethods)
  end
end