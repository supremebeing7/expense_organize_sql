require 'spec_helper'

describe Company do
	it 'initializes with a name' do
		test_company = Company.new({'name' => 'Burger King'})
		test_company.should be_an_instance_of Company
	end

	it 'gives us the name' do
		test_company = Company.new({'name' => 'Burger King'})
		test_company.name.should eq 'Burger King'
	end

	describe '.all' do
		it 'starts empty' do
			Company.all.should eq []
		end

		it 'includes all company objects' do
			test_company = Company.new({'name' => 'Burger King'})
			test_company.save
			Company.all.should eq [test_company]
		end
	end

	describe '#==' do
		it 'is equal if name is the same' do
			test_company1 = Company.new({'name' => 'Burger King'})
			test_company2 = Company.new({'name' => 'Burger King'})
			test_company1.should eq test_company2
		end
	end

	describe '#save' do
		it 'saves a company to the database' do
			test_company = Company.new({'name' => 'Burger King'})
			test_company.save
			Company.all.should eq [test_company]
		end

		it 'returns the id' do
			test_company = Company.new({'name' => 'Burger King'})
			test_company.save
			test_company.id.should be_an_instance_of Fixnum
		end

		it 'only saves the company if it is not already present in the DB' do
			test_company1 = Company.new({'name' => 'Cheesecake Factory'})
			test_company2 = Company.new({'name' => 'Cheesecake Factory'})
			test_company1.save
			test_company2.save
			test_company2.id.should eq test_company1.id
		end
	end

	describe '.create' do
		it 'creates and saves a company to the database' do
			test_company1 = Company.create({'name' => 'Burger King'})
			test_company3 = Company.create({'name' => 'Taco Bell'})
			Company.all.should eq [test_company1, test_company3]
		end
	end
end
