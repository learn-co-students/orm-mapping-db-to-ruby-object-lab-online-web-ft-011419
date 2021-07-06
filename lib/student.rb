class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
   new_student = Student.new() 
   new_student.id = row[0]
   new_student.name = row[1]
   new_student.grade = row[2]
   return new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql_query = <<-ENDER 
      SELECT * FROM students
      ENDER
    rows =   DB[:conn].execute(sql_query)
    rows.map do |data|
      Student.new_from_db(data)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql_query= "SELECT * FROM students WHERE students.name = ? LIMIT 1"
   thing= DB[:conn].execute(sql_query, name)
  thing.map do |foo|
    self.new_from_db(foo)
  end.first
    
  end
  def self.all_students_in_grade_9
    sql = <<-STR_END_VAL
      SELECT * FROM students WHERE students.grade = 9
    STR_END_VAL
    rows = DB[:conn].execute(sql)
    final = []
    rows.map do |data|
      foo = Student.new_from_db(data)
      final << foo
    end
    return final 
  end
  def self.students_below_12th_grade
    sql = <<-STR_ENDER
      SELECT * FROM students WHERE students.grade < 12 
    STR_ENDER
    rows = DB[:conn].execute(sql)
    final = []
    rows.map do |data|
     foo =  Student.new_from_db(data)
      final << foo 
    end
    return final 
  end
  def self.first_X_students_in_grade_10(num)
    sql =  "SELECT * FROM students WHERE students.grade = 10 LIMIT ?"
    rows = DB[:conn].execute(sql,num)
    final = []
    rows.map do |data|
     foo =  Student.new_from_db(data)
      final << foo 
    end
    return final
  end
  def self.first_student_in_grade_10
    sql = <<-STR_ENDING
      SELECT * FROM students WHERE students.grade = 10 LIMIT 1
    STR_ENDING
    rows = DB[:conn].execute(sql)
    rows.map do |data|
      Student.new_from_db(data)
    end.first
  end
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE students.grade = ?"
    rows = DB[:conn].execute(sql,grade)
    rows.map do |data|
      Student.new_from_db(data)
    end
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
