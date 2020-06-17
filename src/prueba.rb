
teacher =  [[1, 6], [1, 5], [1, 15], [1, 19]]

student = [[1, 5], [1, 6], [1, 9], [1, 17]]



def test(teacher_schudel,schudel )
  choises = []
  teacher_schudel.each do | teacher |

      # puts "teacher: #{teacher}"
      # puts "alumnos: #{schudel}"
     if schudel.include?(teacher)
      puts "teacher: #{teacher}"
      choises.push teacher
     end


  end
  return choises.sort!
end

resultado = test(teacher, student)
puts resultado.inspect

