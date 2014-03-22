require 'pg'
require './lib/expense'
require './lib/category'

DB = PG.connect({:dbname => 'expenses_test'})
