require_relative "questions_db.rb"

class Replies

  def self.find_by_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM replies
      WHERE id = q_id
    SQL
    return nil unless data.length > 0
    Replies.new(data)
  end

  attr_accessor :id, :body, :question_id, :parent_id, :author_user_id

  def initialize(data)

    @id = data["id"]
    @body = data["body"]
    @question_id = data["question_id"]
    @parent_id = data["parent_id"]
    @author_user_id = data["author_user_id"]

  end

end
