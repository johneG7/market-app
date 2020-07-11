require_relative "order.rb"

class Market 
    puts "Welcome To My Market!"
    puts ""
    puts "Here's what's on the Menu:"
    puts '
    +--------------|--------------|---------+
    | Product Code |     Name     |  Price  |
    +--------------|--------------|---------+
    |     CH1      |   Chai       |  $3.11  |
    |     AP1      |   Apples     |  $6.00  |
    |     CF1      |   Coffee     | $11.23  |
    |     MK1      |   Milk       |  $4.75  |
    +--------------|--------------|---------+'
    puts 'These are our current specials:'
    puts 'Buy-One-Get-One-Free Special on Coffee. (Unlimited)'
    puts 'If you buy 3 or more bags of Apples, the price drops to $4.50.'
    puts 'Purchase a box of Chai and get milk free. (Limit 1)'
    puts ''
    puts "What would you like to order? Type 'done' at anytime to complete your order"

    order_string = gets.chomp.upcase
    order = Order.new
    order.scan(order_string) unless order_string == "DONE"

    while order_string != "DONE" do
        puts "Scan additional item below:"
        order_string = gets.chomp.upcase
        order.scan(order_string) unless order_string == "DONE"
    end

    # Drop the receipt after order is placed
    puts order.get_receipt
end