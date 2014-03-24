class Category
	attr_reader :name, :id

	def initialize(attributes)
		@name = attributes['name']
	end

	def ==(another_category)
		self.name == another_category.name
	end

	def save
		category_results = DB.exec("SELECT * FROM categories WHERE name = '#{name}';")
		if category_results.first == nil
			result = DB.exec("INSERT INTO categories (name) VALUES ('#{name}') RETURNING id")
			@id = result.first['id'].to_i
		else
			@id = category_results.first['id'].to_i
		end
	end

	def add_to_expenses_categories(new_expense)
		result = DB.exec("INSERT INTO expenses_categories (expense_id, category_id) VALUES (#{new_expense.id}, #{self.id}) RETURNING id;")
	end

	def show_categorized_expenses
		categorized_expenses = []
		results = DB.exec("SELECT * FROM categories
		 					JOIN expenses_categories ON (categories.id = category_id)
		 					JOIN expenses ON (expenses.id = expense_id)
		 					WHERE category_id = #{self.id}")
		results.each do |result|
			hash = Hash.new
			hash['id'] = result['id'].to_i
			hash['description'] = result['description']
			hash['amount'] = result['amount'].to_f
			hash['date'] = result['date']
			categorized_expenses << hash
		end
		categorized_expenses
	end

	def show_percent_spent
		category_spent = 0
		results = DB.exec("SELECT * FROM categories
		 					JOIN expenses_categories ON (categories.id = category_id)
		 					JOIN expenses ON (expenses.id = expense_id)
		 					WHERE category_id = #{self.id}")
		results.each do |result|
			category_spent += result['amount'].to_f
		end
		total_spent = DB.exec("SELECT SUM(amount) FROM expenses;")
		percent_spent = category_spent / total_spent.first['sum'].to_f
	end

	def self.all
		all_categories = []
		results = DB.exec('SELECT * FROM categories;')
		all_categories = results.collect { |result| Category.create(result) }
		all_categories
	end

	def self.create(attributes)
		new_category = Category.new(attributes)
		new_category.save
		new_category
	end
end
