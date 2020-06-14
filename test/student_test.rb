require 'minitest/autorun'
require '../code/student'

# - tiene un nombre y apellido
# - tiene asignado una modalidad: grupal, individual
# - tiene un nivel: Beginner, Pre-Intermediate, Intermediate, Upper-Intermediate y Advanced
# - tiene un horario: de lunes a viernes
#   * Lunes 17:00
#   * Miércoles 9:00
#   * Jueves 15:00

describe 'Student' do
  it 'has a name and a surname' do
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    expect(object_student.full_name).must_equal "Milhouse Van Houten"
  end

  it 'has a class mode' do
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    expect(object_student.mode).must_equal "grupal"
  end

  it 'has a class level' do
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    expect(object_student.level).must_equal "Beginner"
  end

  it 'has a schedule of class' do
    schedule = Hash.new
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner", schedule)
    expect(object_student.schedule).must_be_empty
  end

  it 'has a schedule of class' do
    schedule = [["monday",17],["wednesday",9],["thursday",20]]
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner", schedule)
    expect(object_student.schedule[0][1]).must_equal 17
  end

  it 'can add his availability for a day' do
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    object_student.add_day("monday", 19)
    expect(object_student.schedule[0][1]).must_equal 19
  end

  it 'can add his availability for a day in two differents hours' do
    object_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    object_student.add_day("monday", 19)
    object_student.add_day("wednesday", 9)
    object_student.add_day("thursday", 15)
    expect(object_student.schedule[1][1]).must_equal 9
  end


end
