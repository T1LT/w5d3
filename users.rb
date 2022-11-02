require_relative "questions_db.rb"

class User

  def self.find_by_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM users
      WHERE id = ?
    SQL
    return nil unless data.length > 0
    User.new(data.first)
  end

  attr_accessor :id, :fname, :lname

  def initialize(data)

    @id = data["id"]
    @fname = data["fname"]
    @lname = data["lname"]

  end

end
