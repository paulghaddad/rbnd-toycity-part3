class Transaction
  attr_reader :customer, :product, :id

  @id_to_assign = 1
  @transaction_registry = []

  class << self
    attr_accessor :id_to_assign
    attr_accessor :transaction_registry
  end

  def initialize(customer, product)
    @customer = customer
    @product = product
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

  private

  def process_transaction
    check_if_product_in_stock
    assign_transaction_id
    decrement_product_stock
    add_to_transaction_registry
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

  def decrement_product_stock
    product.stock -= 1
  end

  def add_to_transaction_registry
    Transaction.transaction_registry << self
  end
end
