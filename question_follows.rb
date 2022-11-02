require_relative "questions_db.rb"

class QuestionFollows

  def self.find_by_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT users.fname, users.lname
      FROM question_follows
      JOIN users
      ON question_follows.user_id = users.id
      WHERE question_id = ?
    SQL
    return nil unless data.length > 0
    QuestionFollows.new(data)
  end

  attr_accessor :names

  def initialize(data)

    @names = data.map do |datum|
        "#{datum["fname"]} #{datum["lname"]}"
    end

  end

end
