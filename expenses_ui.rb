require 'pg'
require './lib/expense'
require './lib/category'

DB = PG.connect({:dbname => 'expenses'})

def ascii_art
	system "clear"
	print "\e[1;32m
	$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	$                                       $
	$          __       _____               $
	$         |__         |                 $
	$         |__ XPENSE  | RACKER          $
	$                                       $
	$                                       $
	$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	"
end

def main_menu
	ascii_art
	puts "\n'A' - Add expense"
	puts "'C' - Add category"
	puts "'D' - Delete all data"
	choice = gets.chomp.upcase
	case choice
	when 'A'
		add_expense
	when 'C'
		add_category
	when 'D'
		puts "Are you sure?"
		if gets.chomp.upcase == 'Y' || gets.chomp.upcase == 'YES'
			DB.exec("DELETE FROM expenses *;")
		    DB.exec("DELETE FROM categories *;")
		    DB.exec("DELETE FROM companies *;")
		    DB.exec("DELETE FROM expenses_categories_companies *;")
		else
			main_menu
		end
	else
		puts "Invalid entry"
		main_menu
	end
end

def add_expense
	puts "\nWhat did you purchase?"
	description = gets.chomp
	puts "\nHow much did it cost?"
	amount = gets.chomp.gsub(',','').to_f
	puts "How would you categorize this purchase?"
	category_name = gets.chomp.capitalize
	puts "From what company did you purchase?"
	company_name = gets.chomp.capitalize
	new_category = Category.create({'name' => category_name})
	new_company = Company.create({'name' => company_name})
	new_expense = Expense.create({'description' => description, 'amount' => amount, 'category_id' => new_category.id})  #ADD TO END --- , 'company_id' => new_company.id
	puts "Expense added!"
	puts "#{new_expense.description} - $#{'%.2f' % new_expense.amount} - Category: #{new_category.name}" #ADD TO END ---  - Company: #{new_company.name}
	puts "\nAdd another expense?"
	choice = gets.chomp.upcase
	case choice
	when 'Y', 'YES'
		add_expense
	else
		main_menu
	end
end

main_menu
