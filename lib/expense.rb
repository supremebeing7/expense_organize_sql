class Expense
	attr_reader :description, :amount, :company_id, :id, :date

	def initialize(attributes)
		@description = attributes['description']
		@amount = attributes['amount'].to_f
		@company_id = attributes['company_id'].to_i
		@date = attributes['date']
	end

	def ==(another_expense)
		self.description == another_expense.description && self.amount == another_expense.amount && self.company_id == another_expense.company_id && self.date == another_expense.date
	end

	def save
		result = DB.exec("INSERT INTO expenses (description, amount, company_id, date) VALUES ('#{description}', #{amount}, #{company_id}, '#{date}') RETURNING id")
		@id = result.first['id'].to_i
	end

	def self.all
		all_expenses = []
		results = DB.exec('SELECT * FROM expenses;')
		all_expenses = results.collect { |result| Expense.create(result) }
		all_expenses
	end

	def self.create(attributes)
		new_expense = Expense.new(attributes)
		new_expense.save
		new_expense
	end
end
