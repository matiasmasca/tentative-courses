require 'date'

class Schedule

  def add_day(schedule = self.schedule, day, hour)
    day_number = day_to_number(day)
    schedule << [day_number, hour]
    return schedule
  end

  def parse_schedule(schedule_arg)
    schedule_init = Array.new
    schedule_arg.each {|schedule| add_day(schedule_init, schedule[0],schedule[1])}
    schedule_init.sort!
  end

  private

  def day_to_number(day)
    days = %w{lunes martes miércoles jueves viernes sábado domingo}
    if days.include? day.downcase
      days.index(day.downcase) + 1
    else
      # handle the error when non-exist the day with that word
      begin
        Date.strptime(day.downcase, '%A').wday
      rescue
        raise "Error: invalid text for day, english or spanish only.."
      end
    end
  end
end
