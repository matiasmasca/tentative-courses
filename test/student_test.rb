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
    obj_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    expect(obj_student.full_name).must_equal "Milhouse Van Houten"
  end

  it 'has a class mode' do
    obj_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    expect(obj_student.mode).must_equal "grupal"
  end

  it 'has a class level' do
    obj_student = Student.new("Milhouse Van Houten", "grupal", "Beginner")
    expect(obj_student.level).must_equal "Beginner"
  end

  it 'has a schedule of class' do
    schedule = Hash.new
    obj_student = Student.new("Milhouse Van Houten", "grupal", "Beginner", schedule)
    expect(obj_student.schedule).must_be_empty
  end

  it 'has a schedule of class' do
    schedule = { monday: {hours: [17]}, wednesday: {hours: [9]}, Thursday: {hours: [15]} }
    obj_student = Student.new("Milhouse Van Houten", "grupal", "Beginner", schedule)
    expect(obj_student.schedule[:monday][:hours].first).must_equal 17
  end


end


# Monday: Lunes /’mʌndeɪ/
# Tuesday: Martes /’tjʊ:zdeɪ/
# Wednesday: Miércoles /’wenzdeɪ/
# Thursday: Jueves /’ɵɜ:zdeɪ/
# Friday: Viernes /’fraɪdeɪ/
# Saturday: Sábado /’sætədeɪ/
# Sunday: Domingo /’sʌndeɪ/
