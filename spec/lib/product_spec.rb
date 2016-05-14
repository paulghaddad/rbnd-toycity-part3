require "spec_helper"

describe Product do
  before do
    Product.products = []
  end

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

  describe ".all" do
    it "returns all the products that have been created" do
      product_1 = create_product(title: "Product 1")
      product_2 = create_product(title: "Product 2")

      all_products = Product.all

      expect(all_products).to contain_exactly(product_1, product_2)
    end
  end

  private

  def create_product(title: "Product", price: 10.00, stock: 0)
    Product.new(title: title, price: price, stock: stock)
  end
end

