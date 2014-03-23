require 'pg'
require './lib/expense'
require './lib/category'
require './lib/company'

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
	puts "\n'Exp' - Add expense"
	puts "'Cat' - Add category"
	puts "'Com' - Add company"
	puts "'Show' - Show expenses by category"
	puts "'Del' - Delete all data"
	puts "'Q' - Quit"
	choice = gets.chomp.upcase
	case choice
	when 'EXP'
		add_expense
	when 'CAT'
		add_category
	when 'COM'
		add_company
	when 'SHOW'
		show_expenses_by_category
	when 'DEL'
		puts "Are you sure?"
		case gets.chomp.upcase
		when 'Y', 'YES'
			DB.exec("DELETE FROM expenses *;")
		    DB.exec("DELETE FROM categories *;")
		    DB.exec("DELETE FROM companies *;")
		    DB.exec("DELETE FROM expenses_categories_companies *;")
		else
			main_menu
		end
	when 'Q'
		system 'clear'
		puts "\n\tGoodbye\n\n"
	else
		puts "Invalid entry"
		main_menu
	end
end

def add_expense
	system "clear"
	puts "\nWhat did you purchase?"
	description = gets.chomp
	puts "\nHow much did it cost?"
	amount = gets.chomp.gsub(',','').to_f
	puts "\nFrom what company did you purchase?"
	company_name = gets.chomp.capitalize
	new_company = Company.create({'name' => company_name})
	new_expense = Expense.create({'description' => description, 'amount' => amount, 'company_id' => new_company.id})
	add_category_to_expense(new_expense)
	puts "Expense added!"
	puts "#{new_expense.description} - $#{'%.2f' % new_expense.amount} - Company: #{new_company.name}"
	puts "\nAdd another expense?"
	choice = gets.chomp.upcase
	case choice
	when 'Y', 'YES'
		add_expense
	else
		main_menu
	end
end

def add_category_to_expense(new_expense)
	puts "\nEnter a category:"
	category_name = gets.chomp.capitalize
	new_category = Category.create({'name' => category_name})
	new_category.add_to_expenses_categories(new_expense)
	puts "\nWould you like to add an additional category?"
	case gets.chomp.upcase
	when 'Y', 'YES'
		add_category_to_expense(new_expense)
	else
		main_menu
	end
end

def add_category
	main_menu
end

def add_company
	main_menu
end

def show_expenses_by_category
	system "clear"
	Category.all.each_with_index do |category, index|
		puts "#{index + 1}. #{category.name}"
		category.show_categorized_expenses.each do |expense|
			puts "\t$#{'%.2f' % expense['amount']} - #{expense['description']}"
		end
	end
	puts "\n\nPress 'enter' to continue"
	gets.chomp
	main_menu
end

main_menu
