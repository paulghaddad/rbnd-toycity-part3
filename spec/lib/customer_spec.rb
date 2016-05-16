require "spec_helper"

describe Customer do

  before do
    Customer.customers = []
  end

  describe "#new" do
    context "not a duplicate name" do
      it "creates a new customer with a name" do
        customer = Customer.new(name: "Paul")

        expect(customer).to have_attributes(name: "Paul")
      end

      context "duplicate name" do
        it "raises an error" do
          Customer.new(name: "Paul")

          expect { Customer.new(name: "Paul") }.to raise_error(DuplicateCustomerError)
        end
      end
    end

    describe ".all" do
      it "returns all the customers" do
        customer_1 = Customer.new(name: "Customer 1")
        customer_2 = Customer.new(name: "Customer 2")

        customers = Customer.all

        expect(customers).to contain_exactly(customer_1, customer_2)
      end
    end

    describe ".find_by_name" do
      it "returns the customer of the provided name" do
        Customer.new(name: "Paul Haddad")

        customer = Customer.find_by_name("Paul Haddad")

        expect(customer.name).to eq("Paul Haddad")
      end
    end
  end
end
