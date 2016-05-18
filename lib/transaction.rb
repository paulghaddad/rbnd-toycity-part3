class Transaction
  attr_reader :customer, :product, :id, :amount_of_product

  @id_to_assign = 1
  @transaction_registry = []

  class << self
    attr_accessor :id_to_assign
    attr_accessor :transaction_registry
  end

  def initialize(customer, product, amount_of_product = 1)
    @customer = customer
    @product = product
    @amount_of_product = amount_of_product

    process_transaction
  end

  def self.all
    Transaction.transaction_registry
  end

  def self.find(id)
    transaction_registry.find do |transaction|
      transaction.id == id
    end
  end

  def self.return(customer, product, amount_of_product = -1)
    if valid_return?(customer, product, amount_of_product)
      create_transaction(customer, product, amount_of_product)
    else
      raise InvalidReturnError, "#{customer.name} did not purchase this amount of the product"
    end
  end

  private

  def process_transaction
    confirm_product_in_stock if purchase?
    assign_transaction_id
    add_to_transaction_registry
    adjust_product_stock
  end

  def confirm_product_in_stock
    if product.stock < 1
      raise OutOfStockError, "'#{product.title}' is out of stock."
    end
  end

  def assign_transaction_id
    @id = Transaction.id_to_assign
    increment_transaction_id
  end

  def increment_transaction_id
    Transaction.id_to_assign += 1
  end

  def adjust_product_stock
    product.stock -= amount_of_product
  end

  def add_to_transaction_registry
    Transaction.transaction_registry << self
  end

  def purchase?
    amount_of_product > 0
  end

  def self.create_transaction(customer, product, amount_of_product)
    Transaction.new(customer, product, amount_of_product)
  end

  def self.valid_return?(customer, product, amount_of_product_to_return)
    Transaction.total_purchases(customer, product) + amount_of_product_to_return >= 0
  end

  def self.total_purchases(customer, product)
    Transaction.all.inject(0) do |total_purchases, transaction|
      if by_customer?(customer, transaction) && for_product?(product, transaction)
        total_purchases += transaction.amount_of_product
      end

      total_purchases
    end
  end

  def self.transactions_by_customer(customer)
    Transaction.all.select do |transaction|
      transaction.customer.name == customer.name
    end
  end

  def self.transactions_by_product(product)
    Transaction.all.select do |transaction|
      transaction.product.title == product.title
    end
  end

  def self.by_customer?(customer, transaction)
    Transaction.transactions_by_customer(customer).include?(transaction)
  end

  def self.for_product?(product, transaction)
    Transaction.transactions_by_product(product).include?(transaction)
  end
end
