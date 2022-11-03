require_relative "questions_db.rb"
require_relative "question.rb"
require_relative "reply.rb"
require_relative "question_follows.rb"
require_relative "question_likes.rb"

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

  def self.find_by_name(fname,lname)
    data = QuestionsDB.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
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

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(id)
  end

end
