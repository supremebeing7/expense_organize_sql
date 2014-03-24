require 'spec_helper'

describe Category do
	it 'initializes with a name' do
		test_category = Category.new({'name' => 'restaurants'})
		test_category.should be_an_instance_of Category
	end

	it 'gives us the name' do
		test_category = Category.new({'name' => 'restaurants'})
		test_category.name.should eq 'restaurants'
	end

	describe '.all' do
		it 'starts empty' do
			Category.all.should eq []
		end

		it 'includes all category objects' do
			test_category = Category.new({'name' => 'restaurants'})
			test_category.save
			Category.all.should eq [test_category]
		end
	end

	describe '#==' do
		it 'is equal if name is the same' do
			test_category1 = Category.new({'name' => 'restaurants'})
			test_category2 = Category.new({'name' => 'restaurants'})
			test_category1.should eq test_category2
		end
	end

	describe '#save' do
		it 'saves a category to the database' do
			test_category = Category.new({'name' => 'restaurants'})
			test_category.save
			Category.all.should eq [test_category]
		end

		it 'returns the id' do
			test_category = Category.new({'name' => 'restaurants'})
			test_category.save
			test_category.id.should be_an_instance_of Fixnum
		end

		it 'only saves the category if it is not already present in the DB' do
			test_category1 = Category.new({'name' => 'restaurants'})
			test_category2 = Category.new({'name' => 'restaurants'})
			test_category1.save
			test_category2.save
			test_category2.id.should eq test_category1.id
		end
	end

	describe '#add_to_expenses_categories' do
		it 'adds a category to an existing expense' do
			test_expense = Expense.create({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5, 'date' => '2014-09-09'})
			test_category1 = Category.create({'name' => 'restaurants'})
			test_category1.add_to_expenses_categories(test_expense)
			results = DB.exec("SELECT * FROM categories
		 					JOIN expenses_categories ON (categories.id = category_id)
		 					JOIN expenses ON (expenses.id = expense_id)
		 					WHERE expenses.id = #{test_expense.id}")
			results.first['category_id'].to_i.should eq test_category1.id
			results.first['expense_id'].to_i.should eq test_expense.id
		end
	end

	describe '.create' do
		it 'creates and saves a category to the database' do
			test_category1 = Category.create({'name' => 'restaurants'})
			test_category2 = Category.create({'name' => 'clothes'})
			Category.all.should eq [test_category1, test_category2]
		end
	end

	describe '#show_categorized_expenses' do
		it 'gives a list of all categories with expenses' do
			test_expense1 = Expense.create({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5, 'date' => '2014-09-09'})
			test_expense2 = Expense.create({'description' => 'taco', 'amount' => 2.99, 'company_id' => 7, 'date' => '2014-08-07'})
			test_expense3 = Expense.create({'description' => 'shoes', 'amount' => 25.85, 'company_id' => 9, 'date' => '2014-02-19'})
			test_category1 = Category.create({'name' => 'restaurants'})
			test_category2 = Category.create({'name' => 'clothes'})
			test_category1.add_to_expenses_categories(test_expense1)
			test_category1.add_to_expenses_categories(test_expense2)
			test_category1.show_categorized_expenses.first['description'].should eq 'burger'
			test_category1.show_categorized_expenses.first['amount'].should eq 9.50
		end
	end

	describe '#show_percent_spent' do
		it 'gives the percent of money spent in a given category' do
			test_expense1 = Expense.create({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5, 'date' => '2014-09-09'})
			test_expense2 = Expense.create({'description' => 'taco', 'amount' => 2.99, 'company_id' => 7, 'date' => '2014-08-07'})
			test_expense3 = Expense.create({'description' => 'shoes', 'amount' => 25.85, 'company_id' => 9, 'date' => '2014-02-19'})
			test_category1 = Category.create({'name' => 'restaurants'})
			test_category2 = Category.create({'name' => 'clothes'})
			test_category1.add_to_expenses_categories(test_expense1)
			test_category1.add_to_expenses_categories(test_expense2)
			test_category2.add_to_expenses_categories(test_expense3)
			test_category1.show_percent_spent.should eq 0.3257694314032342
		end
	end
end

