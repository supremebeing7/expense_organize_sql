class Company
	attr_reader :name, :id

	def initialize(attributes)
		@name = attributes['name']
	end

	def ==(another_company)
		self.name == another_company.name
	end

	def save
		company_results = DB.exec("SELECT * FROM companies WHERE name = '#{name}';")
		if company_results.first == nil
			result = DB.exec("INSERT INTO companies (name) VALUES ('#{name}') RETURNING id")
			@id = result.first['id'].to_i
		else
			@id = company_results.first['id'].to_i
		end
	end

	def self.all
		all_companies = []
		results = DB.exec('SELECT * FROM companies;')
		all_companies = results.collect { |result| Company.create(result) }
		all_companies
	end

	def self.create(attributes)
		new_company = Company.new(attributes)
		new_company.save
		new_company
	end
end
