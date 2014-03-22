class Category
	attr_reader :name, :id

	def initialize(attributes)
		@name = attributes['name']
	end

	def ==(another_category)
		self.name == another_category.name
	end

	def save
		result = DB.exec("INSERT INTO categories (name) VALUES ('#{name}') RETURNING id")
		@id = result.first['id'].to_i
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
