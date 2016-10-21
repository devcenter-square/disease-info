require "jbuilder"

class Jbuilder
   
  attr_accessor :prettify

  alias_method :_original_target, :target!


  def prettify!
    @prettify = true
  end

  def target!
    @prettify ? ::JSON.pretty_generate(@attributes) : _original_target
  end
  
end
