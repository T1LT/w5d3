PRAGMA foreign_key = ON;
DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;

-- users
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255),
    lname VARCHAR(255)
);

-- questions
CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT,
    author_user_id INTEGER,
    FOREIGN KEY(author_user_id) REFERENCES users(id)
);

-- question_follows
CREATE TABLE question_follows (
    question_id INTEGER,
    user_id INTEGER,
    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

-- replies
CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT,
    question_id INTEGER,
    parent_id INTEGER,
    author_user_id INTEGER,
    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(parent_id) REFERENCES replies(id),
    FOREIGN KEY(author_user_id) REFERENCES users(id)
);

-- question_likes
CREATE TABLE question_likes (
    question_id INTEGER,
    participant_user_id INTEGER,
    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(participant_user_id) REFERENCES users(id)
);

INSERT INTO users (fname, lname)
VALUES
("Abby", "Argyle"),
("Bobby", "Big"),
("Charlie", "Cat");

INSERT INTO questions (title, body, author_user_id)
VALUES
("who?", "body1", 1),
("what?", "body2", 2),
("when?", "body3", 3);

INSERT INTO replies (body, question_id, parent_id, author_user_id)
VALUES
("reply1", 1, null, 1),
("reply2", 1, null, 2),
("reply3", 1, null, 3),
("reply4", 1, 2, 1);

INSERT INTO question_follows (question_id, user_id)
VALUES
(1,1),
(2,2),
(3,3),
(2,1),
(3,2);

INSERT INTO question_likes (question_id, participant_user_id)
VALUES
(1,1),
(2,2),
(3,3),
(2,1),
(3,2);