require "spec_helper"

describe Customer do
  describe "#new" do
    it "creates a new customer with a name" do
      customer = Customer.new(name: "Paul Haddad")

      expect(customer).to have_attributes(name: "Paul Haddad")
    end
  end
end
