require "spec_helper"

describe Transaction do
  before do
    Customer.customers = []
    Product.products = []
    Transaction.id_to_assign = 1
    Transaction.transaction_registry = []
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

    it "adds the transaction to the transaction registry" do
      customer = Customer.new(name: "Paul Haddad")
      product = create_product(title: "Product 1")
      transaction = Transaction.new(customer, product)

      registry = Transaction.transaction_registry

      expect(registry).to contain_exactly(transaction)
    end
  end

  describe ".all" do
    it "returns all the transactions" do
      customer = Customer.new(name: "Paul Haddad")
      product_1 = create_product(title: "Product 1", stock: 10)
      product_2 = create_product(title: "Product 2", stock: 10)

      transaction_1 = Transaction.new(customer, product_1)
      transaction_2 = Transaction.new(customer, product_2)

      expect(Transaction.all).to contain_exactly(transaction_1, transaction_2)
    end
  end

  describe ".find" do
    it "returns the transaction that matches the id" do
      customer = Customer.new(name: "Paul Haddad")
      product = create_product(title: "Product 1")
      transaction = Transaction.new(customer, product)

      found_transaction = Transaction.find(1)

      expect(found_transaction).to eq(transaction)
    end
  end

  private

  def create_product(title: "Product", price: 10.00, stock: 0)
    Product.new(title: title, price: price, stock: stock)
  end
end
