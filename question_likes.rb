require_relative "questions_db.rb"
require_relative "user.rb"

class QuestionLikes

  def self.find_by_id(q_id)
    data = QuestionsDB.instance.execute(<<-SQL, q_id)
      SELECT users.fname, users.lname
      FROM question_likes
      JOIN users
      ON question_likes.participant_user_id = users.id
      WHERE question_id = ?
    SQL
    return nil unless data.length > 0
    QuestionLikes.new(data)
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.fname, users.lname
      FROM question_likes
      JOIN users
      ON question_likes.participant_user_id = users.id
      WHERE question_likes.question_id = ?
    SQL
    data.length > 0 ? data.map { |datum| User.new(datum) } : nil
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDB.instance.execute( <<-SQL, question_id )
      SELECT COUNT(*) AS count FROM question_likes WHERE question_id = ? GROUP BY question_id ;
    SQL
    data[0]["count"]
  end

  attr_accessor :names

  def initialize(data)
    @names = data.map do |datum|
        "#{datum["fname"]} #{datum["lname"]}"
    end
  end

end
