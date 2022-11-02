require 'sqlite3'
require 'singleton'

class QuestionsDB < SQLite3::Database
  include Singleton

  def initialize
    super(questions.db)
    type_translations = true
    results_as_hash = true
  end

end
