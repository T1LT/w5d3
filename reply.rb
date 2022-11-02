require_relative "questions_db.rb"
require_relative "user.rb"
require_relative "question.rb"

class Reply

  def self.find_by_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL
    return nil unless data.length > 0
    Reply.new(data.first)
  end

  def self.find_by_user_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM replies
      WHERE author_user_id = ?
    SQL
    return nil unless data.length > 0
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_question_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
    SQL
    return nil unless data.length > 0
    data.map { |datum| Reply.new(datum) }
  end

  attr_accessor :id, :body, :question_id, :parent_id, :author_user_id

  def initialize(data)
    @id = data["id"]
    @body = data["body"]
    @question_id = data["question_id"]
    @parent_id = data["parent_id"]
    @author_user_id = data["author_user_id"]
  end

  def author
    User.find_by_id(author_user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    data = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE parent_id = ?
    SQL
    !data.nil? ? data.map { |datum| Reply.new(datum) } : nil
  end

end


