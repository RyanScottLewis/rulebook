class Rulebook
  module ClassMethods
    # Finds or creates an instrance of Rulebook
    def rulebook; @rulebook ||= Rulebook.new; end
  end
end