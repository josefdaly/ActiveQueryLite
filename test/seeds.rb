List.new(name: 'House Chores').save

Todo.new(
  name: 'Clean Room',
  finished: 0,
  description: "This one's self explanatory.",
  list_id: 1
).save
Todo.new(
  name: 'Fix Sink',
  finished: 0,
  description: 'Tighten leaky pipes and unclog',
  list_id: 1
).save
Todo.new(
  name: 'Tidy Kitchen',
  finished: 0,
  description: 'Wash dishes and clean stove',
  list_id: 1
).save
Todo.new(
  name: 'Yard Work',
  finished: 0,
  description: 'Mow lawn',
  list_id: 1
).save

List.new(name: 'Homework').save

Todo.new(
  name: 'French',
  finished: 0,
  description: 'Book excercises',
  list_id: 2
).save
Todo.new(
  name: 'History',
  finished: 0,
  description: 'Study for AP test',
  list_id: 2
).save
Todo.new(
  name: 'Math',
  finished: 0,
  description: 'Finish proofs',
  list_id: 2
).save
Todo.new(
  name: 'Computer Science',
  finished: 0,
  description: 'Implement linked list',
  list_id: 2
).save
