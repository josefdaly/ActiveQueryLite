require_relative '../lib/sql_object.rb'

class Todo < SQLObject
  belongs_to(
    :list,
    class_name: 'List',
    foreign_key: :list_id
  )
  self.finalize!
end

class List < SQLObject
  has_many(
    :todos,
    class_name: 'Todo',
    foreign_key: :list_id
  )
  self.finalize!
end
