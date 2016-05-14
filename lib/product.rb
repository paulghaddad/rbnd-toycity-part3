require "pry"
class Product
  attr_reader :title, :price, :stock

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
