require 'pry'
require "sqlite3"

DB_NAME = "poem_data.db".freeze

class SQLActions

  @@db = SQLite3::Database.new(DB_NAME)
  def queries
    l = []
    l <<  %{
  create table if not exists authors(
    id integer primary key   autoincrement,
    name text unique,
    url text);
    create index author_name_index on authors(name);
      }
    l << %{
  create table if not exists poems(
    id integer primary key   autoincrement,
    name text,
    url text unique,
    byline text ,
    author_id integer,
    foreign key (author_id) references authors(id)
    );
    create index poem_name_index on poems(name);
    }
    l << %{
  create table if not exists authors_poems(
    id integer primary key   autoincrement,
    author_id integer,
    poem_id integer,
    foreign key (author_id) references authors(id),
    foreign key (author_id) references poems(id)
    );
    create index authors_poems_index on authors_poems(author_id, poem_id);}
    l
  end

  def create_tables()
    queries.each do |query|
      @@db.execute(query)
    end
  end

  def my_insert_dicts
    [
      {
        name: 'authors',
        values: 2,
        attr: 'name'
      },
      {
        name: 'poems',
        values: 5,
        attr: 'name'
      },
      {
        name: 'authors_poems',
        values: 4
      }
    ]
  end

  def self.question_marks(k)
    str  = ('?' * k).split('')
    "#{str.join(',')}"
  end

  def self.create_insert_statement(insert_dict)
    the_question_marks = self.question_marks(insert_dict[:value])
    "insert into #{insert_dict[:name]} values (#{the_question_marks})"
  end

  def self.create_select_statement_lambda(insert_dict)
    lambda do |value|
      "select id from #{insert_dict[:name]} where name = '#{value}'"
    end
  end

  def self.insert_statements_and_select_lambda(insert_dicts)
    binding.pry
    insert_dicts.map do |insert_dict|
      [
        self.class.create_insert_statement(insert_dict),
        self.class.create_select_statement_lambda(insert_dict)
      ]
    end
  end

  def main
    dicts = self.class.insert_statements_and_select_lambda(my_insert_dicts)
    binding.pry
  end


end

actions = SQLActions.new()
actions.create_tables


