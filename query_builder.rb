require 'pry'
require 'sqlite3'
require 'yaml'

yaml = YAML.load_file('schema.yaml')

# Don't worry about unique or other attrs for now

module QueryBuilder
  def create_single_insert(insert_obj)
    name, type = insert_obj['name'], insert_obj['type']
    "#{name} #{type} #{'unique' if insert_obj.key?('unique')}"
  end

  def create_single_foreign(foreign_obj)
    name, table, key = ['name', 'table', 'key'].map{ |x| foreign_obj[x] }
    "foreign key (#{name}) references #{table}(#{key})"
  end

  def create_single_index(index_obj)
    name, table, key = ['name', 'table', 'key'].map{ |x| index_obj[x] }
    "create index #{name} on #{table + '(' + key + ');'}"
  end

  def create_insert_str(columns_obj, foreign_obj, indexes_obj)
    insert_statements = ['id integer primary key autoincrement']
    insert_statements +=  columns_obj.map{ |x| create_single_insert(x) }
    insert_statements += foreign_obj.map{ |x| create_single_foreign(x) } if foreign_obj

    insert_statements = "(#{insert_statements.join(',')});"

    insert_statements +=  indexes_obj.map { |x| create_single_index(x) }.join(" ") if indexes_obj

    insert_statements
  end

  def build_create_query(obj)
    name = obj['name']
    create = "create table if not exists #{name}"
    insert = create_insert_str(obj['columns'], obj['foreign'], obj['indexes'])
    create + insert
  end
end

class Foo
  extend QueryBuilder
end

binding.pry
'a'
#Foo.build_create_query

res = QueryBuilder.build_create_query(yaml["tables"][0])
puts res
