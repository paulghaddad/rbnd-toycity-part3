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

  describe ".find_by_title" do
    it "should return the product with the title" do
      product_1 = create_product(title: "Product 1")
      product_2 = create_product(title: "Product 2")

      found_product = Product.find_by_title("Product 1")

      expect(found_product.title).to eq("Product 1")
    end
  end

  describe ".in_stock" do
    it "returns all the products in stock" do
      product_1 = create_product(title: "Product 1", stock: 1)
      product_2 = create_product(title: "Product 2", stock: 0)
      product_3 = create_product(title: "Product 3", stock: 1)

      products_in_stock = Product.in_stock

      expect(products_in_stock).to contain_exactly(product_1, product_3)
    end
  end

  describe "#in_stock" do
    context "stock available" do
      it "returns true" do
        in_stock_product = create_product(stock: 1)

        expect(in_stock_product.in_stock?).to be true
      end
    end

    context "stock not available" do
      it "returns false" do
        out_of_stock_product = create_product(stock: 0)

        expect(out_of_stock_product.in_stock?).to be false
      end
    end
  end

  private

  def create_product(title: "Product", price: 10.00, stock: 0)
    Product.new(title: title, price: price, stock: stock)
  end
end

