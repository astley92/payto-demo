class Zepto
  def self.method_missing(method_name, *args, **kwargs, &block)
    adapter.send(method_name, *args, **kwargs, &block)
  end

  def self.adapter
    @adapter ||= Figaro.env.ZEPTO_ADAPTER_CLASS.constantize.new
  end
end
