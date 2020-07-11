# require_relative 'products.rb'

class Order
    def initialize
        @basket = {}
        @basket_discounts = {}
        @products = {CH1: 3.11, AP1: 6.00, CF1: 11.23, MK1: 4.75}
        @product_discounts = {APPL: -1.50, CHMK: -@products[:MK1], BOGO: -@products[:CF1]}
    end

    def basket
        @basket
    end

    def scan(item)
        # Ensure that we only insert valid items into the basket 
        return unless @products[item.to_sym]      
        @basket[item.to_sym] ? @basket[item.to_sym] += 1 : @basket[item.to_sym] = 1

    end 

    def add_discount(item)
        return unless @product_discounts[item.to_sym]      
        @basket_discounts[item] ? @basket_discounts[item] += 1 : @basket_discounts[item] = 1
    end 

    def get_item_price(item)
        @products[item]
    end

    def get_discount_price(item)
        @product_discounts[item]
    end


    def get_basket_total
        total = 0
        @basket.keys.each do |item|
            total += get_item_price(item) * @basket[item]
            apply_discounts(item)
        end

        @basket_discounts.keys.each do |item|
            total += get_discount_price(item) * @basket_discounts[item]
        end

        # To get rid of some funky float precision
        total.round(2)
    end

    # This is to make the calculation of discounts independent when generating our basket total
    def apply_discounts(key)
        number_of_items = @basket[key] 
        case key
        when :CH1
        when :MK1
            for i in 1..number_of_items 
                if number_of_items > 0 && i == 1 && @basket[:CH1]
                    add_discount(:CHMK)
                end
            end
        when :CF1
            for i in 1..number_of_items 
                if number_of_items >= 2 &&  i <= number_of_items / 2 
                    add_discount(:BOGO)
                end
            end
        when :AP1
            for i in 1..number_of_items
                if number_of_items >= 3 
                    add_discount(:APPL)
                end
            end                            
        else
            puts "Invalid key"
        end
    end

    
    def get_receipt
        mid_string = "";

        return "No Items in basket" unless @basket.length > 0
        receipt = receipt_builder    
    end

    # To build out our reciept text
    def receipt_builder
        header = "Item                          Price\n"
        divider = "----                          -----\n"
        line_items = ""
        @basket.keys.each do |key|
            line_items += line_item_builder(key)
        end
        end_divider = "-----------------------------------\n"
        total = line_item_builder(:TOTAL)

        return header += divider += line_items += end_divider += total
    end

    # A helper to build the line items dynamically 
    def line_item_builder(key)
        line_items = ""
        number_of_items = @basket[key] unless key == :TOTAL

        case key
        when :CH1
            for i in 1..number_of_items 
                line_items += "#{key}                            #{get_item_price(key)}\n"
            end
        when :MK1
            for i in 1..number_of_items 
                line_items += "#{key}                            #{get_item_price(key)}\n"
                line_items += "        CHMK                  #{get_discount_price(:CHMK)}\n" if number_of_items > 0 && i == 1 && @basket[:CH1]
            end
        when :CF1
            for i in 1..number_of_items 
                line_items += "#{key}                            #{get_item_price(key)}\n"
                line_items += "        BOGO                  #{get_discount_price(:BOGO)}\n" if number_of_items >= 2 &&  i <= number_of_items / 2 
            end
        when :AP1
            for i in 1..number_of_items
                line_items += "#{key}                            #{get_item_price(key)}\n"
                line_items += "        APPL                  #{get_discount_price(:APPL)}\n" if number_of_items >= 3 
            end
        when :TOTAL
            line_items += "                               #{get_basket_total}\n"
        else
            line_items += "Invalid item"
        end

        line_items
    end
end
