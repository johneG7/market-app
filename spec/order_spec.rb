require "order"

describe Order do
    describe "get_basket_total" do
        context "given 1 item" do
            it "returns the total of the basket" do
                o = Order.new
                o.scan("CF1")
                expect(o.get_basket_total).to eq(11.23)
            end
        end
        context "given 2 items" do
            it "returns the total of the basket" do
                o = Order.new
                o.scan("CF1")
                o.scan("CH1")
                expect(o.get_basket_total).to eq(14.34)
            end
        end
    end

    describe "scan" do
        context "given available item" do
            it "puts the item in the basket" do
                o = Order.new
                o.scan("CF1")
                expect(o.basket.length).to eq(1)
            end
        end
        context "given incorrect / unavailable items" do
            it "does not place the item into the basket" do
                o = Order.new
                o.scan("CB1")
                o.scan("CX1")
                expect(o.basket.length).to eq(0)
            end
        end
    end

    describe "get_receipt" do
        context "0 items in the basket" do
            it "indicates that there are 0 items in the basket" do
                o = Order.new
                text = o.get_receipt
                expect(text).to eq("No Items in basket")
            end
        end
    end

    describe "line_item_builder" do
        context "given 3 AP1 items" do
            it "builds the string properly including discount" do
                o = Order.new
                
                o.scan("AP1")
                o.scan("AP1")
                o.scan("AP1")

                items = o.line_item_builder(:AP1)
                
                list =  "AP1                            6.0\n"
                list += "        APPL                  -1.5\n"
                list += "AP1                            6.0\n"
                list += "        APPL                  -1.5\n"
                list += "AP1                            6.0\n"
                list += "        APPL                  -1.5\n"
                expect(items).to eq(list)
            end
        end
        context "given 2 or more CF1 items" do
            it "builds the string properly including discount" do
                o = Order.new
                o.scan("CF1")
                o.scan("CF1")
                o.scan("CF1")
                o.scan("CF1")

                list1 =  "CF1                            11.23\n"
                list1 += "        BOGO                  -11.23\n"
                list1 += "CF1                            11.23\n"
                list1 += "        BOGO                  -11.23\n"
                list1 += "CF1                            11.23\n"
                list1 += "CF1                            11.23\n"

                items = o.line_item_builder(:CF1)
                expect(items).to eq(list1)

                o = Order.new
                o.scan("CF1")
                o.scan("CF1")

                list2 =  "CF1                            11.23\n"
                list2 += "        BOGO                  -11.23\n"
                list2 += "CF1                            11.23\n"

                items = o.line_item_builder(:CF1)
                expect(items).to eq(list2)
            end
        end

        context "given at least one order of CH1 and MK1" do
            it "builds the string properly including discount" do
                o = Order.new
                o.scan("CH1")
                o.scan("MK1")
                o.scan("MK1")
                o.scan("MK1")

                list1 =  "MK1                            4.75\n"
                list1 += "        CHMK                  -4.75\n"
                list1 += "MK1                            4.75\n"
                list1 += "MK1                            4.75\n"

                items = o.line_item_builder(:MK1)
                expect(items).to eq(list1)
            end
        end
    end #line_item_builder 

    describe "get_basket_total" do
        context "given items that aren't applicable for discount" do
            it "calculates the total properly" do
                o = Order.new
                o.scan("CH1")
                expect(o.get_basket_total).to eq(3.11)
                
                o.scan("CH1")
                expect(o.get_basket_total).to eq(6.22)
            end
        end

        context "given items that ARE applicable for discount" do
            it "calculates the total properly" do
                o = Order.new
                o.scan("CH1")
                expect(o.get_basket_total).to eq(3.11)
                
                o.scan("MK1")
                expect(o.get_basket_total).to eq(3.11)

                o = Order.new 
                o.scan("AP1")
                o.scan("AP1")
                o.scan("AP1")
                expect(o.get_basket_total).to eq(13.50)
            end
        end
    end #get_basket_total

    describe "receipt_builder" do
        context "given order without discounts" do
            it "builds the receipt text properly" do
                o = Order.new
                o.scan("CH1")

                receipt = "Item                          Price\n"
                receipt += "----                          -----\n"
                receipt += "CH1                            3.11\n"
                receipt += "-----------------------------------\n"
                receipt += "                               3.11\n"
                
                expect(o.get_receipt).to eq(receipt)
            end
        end
        context "given order WITH discounts" do
            it "builds the receipt text properly" do
                o = Order.new
                o.scan("CH1")
                o.scan("MK1")

                receipt = "Item                          Price\n"
                receipt += "----                          -----\n"
                receipt += "CH1                            3.11\n"
                receipt += "MK1                            4.75\n"
                receipt += "        CHMK                  -4.75\n"
                receipt += "-----------------------------------\n"
                receipt += "                               3.11\n"
                
                expect(o.get_receipt).to eq(receipt)
            end
            it "builds the receipt text properly" do
                o = Order.new
                o.scan("AP1")
                o.scan("AP1")
                o.scan("AP1")

                receipt = "Item                          Price\n"
                receipt += "----                          -----\n"
                receipt += "AP1                            6.0\n"
                receipt += "        APPL                  -1.5\n"
                receipt += "AP1                            6.0\n"
                receipt += "        APPL                  -1.5\n"
                receipt += "AP1                            6.0\n"
                receipt += "        APPL                  -1.5\n"
                receipt += "-----------------------------------\n"
                receipt += "                               13.5\n"
                
                expect(o.get_receipt).to eq(receipt)
            end
        end
    end
end