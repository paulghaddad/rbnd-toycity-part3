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
      customer = create_customer
      product = create_product

      transaction = Transaction.new(customer, product)

      expect(transaction).to have_attributes(customer: customer,
                                             product: product)
    end

    it "creates a unique id for the transaction" do
      customer = create_customer
      product = create_product

      transaction = Transaction.new(customer, product)

      expect(transaction.id).to eq(1)
    end

    it "reduces the product's stock by 1" do
      customer = create_customer
      product = create_product(stock: 10)

      Transaction.new(customer, product)

      expect(product.stock).to eq(9)
    end

    it "adds the transaction to the transaction registry" do
      customer = create_customer
      product = create_product
      transaction = Transaction.new(customer, product)

      registry = Transaction.transaction_registry

      expect(registry).to contain_exactly(transaction)
    end

    context "product out of stock" do
      it "raises an OutOfStock error" do
        customer = create_customer
        product = create_product(title: "Product 1", stock: 0)

        expect { Transaction.new(customer, product) }.to raise_error(
          OutOfStockError, /'Product 1' is out of stock/)
      end
    end
  end

  describe ".all" do
    it "returns all the transactions" do
      customer = create_customer
      product_1 = create_product(title: "Product 1")
      product_2 = create_product(title: "Product 2")

      transaction_1 = Transaction.new(customer, product_1)
      transaction_2 = Transaction.new(customer, product_2)

      expect(Transaction.all).to contain_exactly(transaction_1, transaction_2)
    end
  end

  describe ".find" do
    it "returns the transaction that matches the id" do
      customer = create_customer
      product = create_product
      transaction = Transaction.new(customer, product)

      found_transaction = Transaction.find(1)

      expect(found_transaction).to eq(transaction)
    end
  end

  describe "#return" do
    it "returns the product and adds back the stock" do
      customer = create_customer
      product = create_product(stock: 5)
      Transaction.new(customer, product)

      Transaction.return(customer, product)

      expect(product.stock).to eq(5)
    end

    it "raises an error if the product was not purchased by the customer" do
      customer = create_customer(name: "Paul Haddad")
      product = create_product(title: "Product", stock: 5)

      expect { Transaction.return(customer, product) }.to raise_error(
        InvalidReturnError, /Paul Haddad did not purchase this amount of the product/)
    end
  end

  private

  def create_customer(name: "Paul Haddad")
    Customer.new(name: "Paul Haddad")
  end

  def create_product(title: "Product", price: 10.00, stock: 5)
    Product.new(title: title, price: price, stock: stock)
  end
end
