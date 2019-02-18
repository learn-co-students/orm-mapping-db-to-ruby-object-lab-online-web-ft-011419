class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id, student.name, student.grade = row[0], row[1], row[2]
    student
  end

  def self.all
    DB[:conn].execute(
      "SELECT * FROM students").collect {|rows| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name=?",name).first
    student = self.new_from_db(row)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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
  
  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade=9")
  end
  
  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").collect {|row| self.new_from_db(row)}
  end
  
  def self.first_X_students_in_grade_10(integer)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", integer).collect {|row| self.new_from_db(row)}
  end
  
  def self.first_student_in_grade_10
    row = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1").first 
    self.new_from_db(row)
  end
  
  def self.all
    DB[:conn].execute("SELECT * FROM students").collect {|row| self.new_from_db(row)}
  end
  
  def self.all_students_in_grade_X(integer)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", integer).collect {|row| self.new_from_db(row)}
  end
end


