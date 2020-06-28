module Schedulable
  require 'date'

  def parse_schedule(schedule_array)
    # Take an array of pairs of day and hours an return a new array with all the pairs as schedule.
    #
    # schedule_array - an array with a list of schedules, represent by an array that have a pair [day, hour]
    #
    schedule_init = Array.new
    schedule_array.each {|schedule| add_day(schedule_init, schedule[0],schedule[1])}
    schedule_init.sort!
  end

  def parse_hour(hour)
    # Check if hour is an intenger between 9 and 19.
    #
    # hour - a Integer that represent the clock hour. It has to be between 9 and 19
    #
    raise 'Error: hour must be number between 9 and 19' if hour.class != Integer
    raise 'Error: hour must be number between 9 and 19' unless hour.between?(9, 19)
    hour
  end

  def parse_day(day)
    # Transforman and check if day params is a day between Monday and Friday. In Spanish and Engilsh.
    #
    # day - represent a day of the week. it could be a word or a number.
    #
    day = self.day_to_number(day)
    raise 'Error: day must be between Monday and Friday' unless day.between?(1, 5)
    day
  end

  def has_schedule?(schedule, schedule_to_check)
    # Check if schedule has another schedule inside
    #
    # schedule - an array of schedueles in order to add a new pair, and return it
    # schedule_to_check - a pair [day, hour] to find inside the schedule array.
    raise 'Error: param has to be an Array' if schedule.class != Array || schedule_to_check.class != Array

    return schedule.include?(schedule_to_check)
  end

  def add_day(schedule = self.schedule, day, hour)
    # Add a day to and schedule array by adding a pair of [day, hour]
    #
    # schedule - an array of schedueles in order to add a new pair, and return it
    # day - represent a day of the week. it could be a word or a number.
    # hour - a Integer that represent the clock hour. It has to be between 9 and 19
    #
    day_number = self.parse_day(day)
    hour_parsed = self.parse_hour(hour)
    schedule << [day_number, hour_parsed]
    return schedule
  end

  def day_to_number(day)
    # Transform name of the day in an Integer that represent that day. Week start at Sunday with 0.
    # Accept English and Spanish name of days.
    #
    # day - represent a day of the week. it could be a word or a number.
    #
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
