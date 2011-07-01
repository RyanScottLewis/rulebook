class User
  follows_the_rules!
  
  attr :role
  
  def initialize
    @role = :user
  end
  
  def_class_rule(/new_(admin|moderator|user)/) do |role|
    new.instance_eval { @role = role.to_sym; self }
  end
  
  def_rule(/is_(admin|moderator|user)\?/) do |role|
    @role == role.to_sym
  end
  
end
