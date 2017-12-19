require "sqlite3"
require "pry"

DB_NAME = "poem_data.db".freeze

class SQLActions
  @@db = SQLite3::Database.new(DB_NAME)

  def create_authors
    action = @@db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS AUTHORS(
    ID INTEGER PRIMARY KEY   AUTOINCREMENT,
    NAME TEXT,
    URL TEXT);
    SQL
  end

  def create_poems
    action = @@db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS POEMS(
    ID INTEGER PRIMARY KEY   AUTOINCREMENT,
    NAME TEXT,
    URL TEXT,
    AUTHOR_ID INTEGER);
    SQL
  end

  def create_authors_poems
    action = @@db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS AUTHORS_POEMS(
    ID INTEGER PRIMARY KEY   AUTOINCREMENT,
    AUTHOR_ID INTEGER,
    POEM_ID INTEGER);
    SQL
  end

  def init_actions
    create_actions = self.methods.select{ |x| x.to_s.start_with?("create") }
    create_actions.each { |func| self.send(func) }
  end

  def enter
    binding.pry
  end

end

actions = SQLActions.new()
actions.init_actions


