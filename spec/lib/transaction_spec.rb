require "spec_helper"

describe Transaction do
  before do
    Customer.customers = []
    Product.products = []
    Transaction.id_to_assign = 1
  end

  describe "#new" do
    it "creates a new transaction" do
      customer = Customer.new(name: "Paul Haddad")
      product = create_product(title: "Product 1")

      transaction = Transaction.new(customer, product)

      expect(transaction).to have_attributes(customer: customer,
                                             product: product)
    end

    it "creates a unique id for the transaction" do
      customer = Customer.new(name: "Paul Haddad")
      product = create_product(title: "Product 1")

      transaction = Transaction.new(customer, product)

      expect(transaction.id).to eq(1)
    end

    it "reduces the product's stock by 1" do
      customer = Customer.new(name: "Paul Haddad")
      product = create_product(title: "Product 1", stock: 10)

      Transaction.new(customer, product)

      expect(product.stock).to eq(9)
    end
  end

  private

  def create_product(title: "Product", price: 10.00, stock: 0)
    Product.new(title: title, price: price, stock: stock)
  end
end
