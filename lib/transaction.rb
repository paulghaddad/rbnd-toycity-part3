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
    if self.valid_return?(customer, product, amount_of_product)
      Transaction.new(customer, product, amount_of_product)
    else
      raise InvalidReturnError, "#{customer.name} did not purchase this amount of the product"
    end
  end

  private

  def process_transaction
    check_if_product_in_stock if purchase?
    assign_transaction_id
    add_to_transaction_registry
    adjust_product_stock
  end

  def check_if_product_in_stock
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

  def self.valid_return?(customer, product, amount_of_product)
    Transaction.total_purchases(customer, product) + amount_of_product >= 0
  end

  def self.total_purchases(customer, product)
    all_transactions = Transaction.all
    all_transactions.inject(0) do |total_purchases, transaction|
      if transaction.customer.name == customer.name && transaction.product.title == product.title
        total_purchases += transaction.amount_of_product
      end

      total_purchases
    end
  end
end
