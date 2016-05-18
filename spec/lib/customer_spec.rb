require "spec_helper"

describe Customer do

  before do
    Customer.customers = []
    Product.products = []
    Transaction.transaction_registry = []
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
        customer_1 = create_customer(name: "Customer 1")
        customer_2 = create_customer(name: "Customer 2")

        customers = Customer.all

        expect(customers).to contain_exactly(customer_1, customer_2)
      end
    end

    describe ".find_by_name" do
      it "returns the customer of the provided name" do
        create_customer

        customer = Customer.find_by_name("Paul Haddad")

        expect(customer.name).to eq("Paul Haddad")
      end
    end

    describe "#purchase" do
      it "creates a transaction" do
        customer = create_customer
        product = Product.new(title: "My New Product", price: 10.00, stock: 1)

        customer.purchase(product)

        expect(Transaction.all.count).to eq(1)
      end
    end

    describe "#return" do
      it "returns the product" do
        customer = create_customer
        product = Product.new(title: "My New Product", price: 10.00, stock: 1)
        customer.purchase(product)

        customer.return(product)

        expect(product.stock).to eq(1)
      end
    end
  end

  private

  def create_customer(name: "Paul Haddad")
    Customer.new(name: name)
  end
end
