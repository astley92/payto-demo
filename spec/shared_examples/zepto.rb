shared_examples "a zepto adapter" do
  it "implements all the interface's methods" do
    implemented_methods = described_class.instance_methods(false)
    Zepto::AdapterInterface.instance_methods.each do |method_name|
      expect(implemented_methods).to include(method_name)

      expected_params = Zepto::AdapterInterface.instance_method(method_name).parameters
      expect(described_class.instance_method(method_name).parameters).to eq(expected_params)
    end
  end
end
