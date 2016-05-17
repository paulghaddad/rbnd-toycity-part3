class Customer
  attr_reader :name

  @customers = []

  class << self
    attr_accessor :customers
  end

  def initialize(name:)
    @name = name
    add_to_customers_registry
  end

  def self.all
    Customer.customers
  end

  def self.find_by_name(name)
    Customer.customers.find do |customer|
      customer.name == name
    end
  end

  def purchase(product)
    Transaction.new(self, product)
  end

  def return(product, amount = 1)
    amount = -amount
    Transaction.return(self, product, amount)
  end

  private

  def add_to_customers_registry
    check_for_duplicate_customer
    Customer.customers << self
  end

  def duplicate_customer?
    Customer.customers.any? do |customer|
      customer.name == name
    end
  end

  def check_for_duplicate_customer
    if duplicate_customer?
      raise DuplicateCustomerError, "#{self.name} already exists"
    end
  end
end
