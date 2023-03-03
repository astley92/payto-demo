module Zepto::UIDGenerator
  extend self

  def call
    SecureRandom.uuid
  end
end
