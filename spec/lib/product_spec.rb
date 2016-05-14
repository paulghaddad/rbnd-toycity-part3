require "spec_helper"

describe Product do
  describe "#initialize" do
    context "no duplicate title" do
      it "creates the product" do
        new_product = create_product(title: "My New Product",
                                     price: 20.00,
                                     stock: 10)

        expect(new_product).to have_attributes(title: "My New Product",
                                               price: 20.00,
                                               stock: 10)
      end
    end

    context "duplicate title" do
      it "raises an Duplicate Product Error" do
       create_product(title: "My New Product",
                                     price: 20.00,
                                     stock: 10)

        expect { create_product(title: "My New Product") }.to raise_error(DuplicateProductError)
      end
    end
  end

  private

  def create_product(title: "Product", price: 10.00, stock: 0)
    Product.new(title: title, price: price, stock: stock)
  end
end

