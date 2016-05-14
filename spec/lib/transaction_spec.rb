require "spec_helper"

describe Transaction do
  describe "#initialize" do
    it "adds the product if there is no duplicate title" do
      new_product = create_product(title: "My new product",
                                   price: 20.00,
                                   stock: 10)

      expect(new_product).to have_attributes(title: "My new product",
                                             price: 20.00,
                                             stock: 10)
    end
  end

  private

  def create_product(title: "Product Title", price: 10.00, stock: 0)
    Product.new(title: title, price: price, stock: stock)
  end
end
