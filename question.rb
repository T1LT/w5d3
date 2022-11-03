require_relative "questions_db.rb"
require_relative "reply.rb"
require_relative "user.rb"
require_relative "question_follows.rb"
require_relative "question_likes.rb"

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

  def self.find_by_author_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT *
      FROM questions
      WHERE author_user_id = ?
    SQL
    return nil unless data.length > 0
    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def self.most_liked(n)
    
  end

  attr_accessor :id, :title, :body, :author_user_id

  def initialize(data)
    @id = data["id"]
    @title = data["title"]
    @body = data["body"]
    @author_user_id = data["author_user_id"]
  end

  def author
    User.find_by_id(@author_user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollows.followers_for_question_id(id)
  end

  def likers
    QuestionLikes.likers_for_question_id(id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question_id(id)
  end

end
