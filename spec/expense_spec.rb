require 'spec_helper'

describe Expense do
	it 'initializes with a description, amount, category_id, and company_id' do
		test_expense = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
		test_expense.should be_an_instance_of Expense
	end

	it 'gives us the description, amount, category_id, and company_id' do
		test_expense = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
		test_expense.description.should eq 'burger'
		test_expense.amount.should eq 9.50
		test_expense.company_id.should eq 5
	end

	describe '.all' do
		it 'starts empty' do
			Expense.all.should eq []
		end

		it 'includes all expense objects' do
			test_expense = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
			test_expense.save
			Expense.all.should eq [test_expense]
		end
	end

	describe '#==' do
		it 'is equal if description, amount, category_id, and company_id are the same' do
			test_expense1 = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
			test_expense2 = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
			test_expense1.should eq test_expense2
		end
	end

	describe '#save' do
		it 'saves an expense to the database' do
			test_expense = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
			test_expense.save
			Expense.all.should eq [test_expense]
		end

		it 'returns the id' do
			test_expense = Expense.new({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
			test_expense.save
			test_expense.id.should be_an_instance_of Fixnum
		end
	end

	describe '.create' do
		it 'creates and saves an expense to the database' do
			test_expense1 = Expense.create({'description' => 'burger', 'amount' => 9.50, 'company_id' => 5})
			test_expense3 = Expense.create({'description' => 'taco', 'amount' => 2.99, 'company_id' => 4})
			Expense.all.should eq [test_expense1, test_expense3]
		end
	end
end
