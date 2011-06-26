class Rulebook
  module ClassMethods
    def rulebook
      @rulebook ||= Rulebook.new
    end
  end
end