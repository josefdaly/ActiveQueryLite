require_relative 'db_connection'
require_relative '02_searchable.rb'
require 'active_support/inflector'
require '03_associatable'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  extend Searchable

  def self.columns
    everything = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{table_name}"
      LIMIT
        0
    SQL

    everything.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |column_name|
      define_method("#{column_name}") { attributes[column_name] }
      define_method("#{column_name}=") { |val| attributes[column_name] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    all_arr = []
    results.each do |attrs_hash|
      all_arr << self.new(attrs_hash)
    end

    all_arr
  end

  def self.find(id)
    row = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    self.new(row.first) unless row.empty?
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      attr_name = "#{attr_name}=".to_sym
      self.send(attr_name, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |column|
      self.send(column)
    end
  end

  def insert
    col_names = self.class.columns.join(',')
    question_marks = '(' + (['?'] * self.class.columns.length).join(',') + ')'

    attr_values = attribute_values
    attr_values[0] = self.id = DBConnection.last_insert_row_id

    DBConnection.execute(<<-SQL, *attr_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        #{question_marks}
    SQL
  end

  def update
    set_values = self.class.columns.drop(1).map { |column| "#{column} = ?" }
    set_values = set_values.join(',')

    DBConnection.execute(<<-SQL, *attribute_values.drop(1), attribute_values.first)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_values}
      WHERE
        id = ?
    SQL
  end

  def save
    id.nil? ? self.insert : self.update
  end
end
