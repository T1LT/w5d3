require_relative "questions_db.rb"
require_relative "user.rb"

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

  def self.followers_for_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.fname, users.lname
      FROM question_follows
      JOIN users
      ON question_follows.user_id = users.id
      WHERE question_id = ?
    SQL
    return nil unless data.length > 0
    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDB.instance.execute(<<-SQL, user_id)
      SELECT questions.id, questions.title, questions.body, questions.author_user_id
      FROM question_follows
      JOIN questions
      ON question_follows.question_id = questions.id
      WHERE user_id = ?
    SQL
    return nil unless data.length > 0
    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    #select (stuff to make question objects)
    #join questions + question_follows
    #group by question_id
    #order by COUNT(question_id)
    #limit n

    data = QuestionsDB.instance.execute(<<-SQL, n)
      SELECT questions.id, questions.title, questions.body, questions.author_user_id
      FROM questions
      JOIN question_follows
      ON questions.id = question_follows.question_id
      GROUP BY question_id
      ORDER BY COUNT(question_id) DESC
      limit ?
    SQL
    data.length > 0 ? data.map { |datum| Question.new(datum) } : nil
  end

  attr_accessor :names

  def initialize(data)
    @names = data.map do |datum|
        "#{datum["fname"]} #{datum["lname"]}"
    end
  end

end

