class Transaction
  attr_reader :customer, :product, :id

  @id_to_assign = 1

  class << self
    attr_accessor :id_to_assign
  end

  def initialize(customer, product)
    @customer = customer
    @product = product
    assign_transaction_id
    decrement_product_stock
  end

  private

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
end
