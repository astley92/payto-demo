class Zepto::Responses::Agreement
  attr_reader :state
  def initialize(state:)
    @state = state
  end

  def ok?
    true
  end
end
