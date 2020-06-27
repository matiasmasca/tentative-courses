module Schedulable
  require 'date'

  def add_day(schedule = self.schedule, day, hour)
    day_number = self.parse_day(day)
    hour_parsed = self.parse_hour(hour)
    schedule << [day_number, hour_parsed]
    return schedule
  end

  def parse_schedule(schedule_arg)
    schedule_init = Array.new
    schedule_arg.each {|schedule| add_day(schedule_init, schedule[0],schedule[1])}
    schedule_init.sort!
  end

  def parse_hour(hour)
   # hour: a Integer that represent the clock hour. It has to be between 9 and 19
    raise 'Error: hour must be number between 9 and 19' if hour.class != Integer
    raise 'Error: hour must be number between 9 and 19' unless hour.between?(9, 19)
    hour
  end

  def parse_day(day)
    # day: represent a day of the week. it could be a word or a number.
    day = self.day_to_number(day)
    raise 'Error: day must be between Monday and Friday' unless day.between?(1, 5)
    day
  end

  def day_to_number(day)
    # day: represent a day of the week. it could be a word or a number.
    if day.class == Integer
      if day.between?(1,7)
        return day
      else
        return raise "Error: invalid number for day, it has to be a number between 1 and 7."
      end
    end

    days = %w{lunes martes miércoles jueves viernes sábado domingo}
    if days.include? day.downcase
      days.index(day.downcase) + 1
    else
      # handle the error when non-exist the day with that word
      begin
        Date.strptime(day.downcase, '%A').wday
      rescue
        raise "Error: invalid text for day, only supports English or Spanish."
      end
    end
  end
end
