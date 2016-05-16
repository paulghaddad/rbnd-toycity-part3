class Product
  attr_reader :title, :price
  attr_accessor :stock

  @@products = []

  def initialize(options = {})
    @title = options[:title]
    @price = options[:price]
    @stock = options[:stock]

    add_to_products
  end

  def self.all
    @@products
  end

  def self.products=(products)
    @@products = products
  end

  def self.find_by_title(title)
    @@products.find do |product|
      product.title == title
    end
  end

  def self.in_stock
    @@products.select(&:in_stock?)
  end

  def in_stock?
    stock > 0
  end

  private

  def add_to_products
    if duplicate_title?
      raise DuplicateProductError, "#{title} already exists."
    end

    @@products << self
  end

  def duplicate_title?
    @@products.any? do |product|
      product.title == title
    end
  end
end
