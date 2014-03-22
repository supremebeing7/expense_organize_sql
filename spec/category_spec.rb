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
			test_expense = Expense.create({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
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
			test_category3 = Category.create({'name' => 'clothes'})
			Category.all.should eq [test_category1, test_category3]
		end
	end
end
