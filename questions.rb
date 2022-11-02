require_relative "questions_db.rb"

class Question

  def self.find_by_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL
    return nil unless data.length > 0
    Question.new(data.first)
  end

  attr_accessor :id, :title, :body, :author_user_id

  def initialize(data)

    @id = data["id"]
    @title = data["title"]
    @body = data["body"]
    @author_user_id = data["author_user_id"]

  end

end
