class Product
  attr_reader :title

  @@products = []

  def initialize(options = {})
    @title = options[:title]
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
    @@products.each do |product|
      product.title == title
    end
  end
end
