module ApplicationHelper
  
  def formated_date(date)
    date.to_datetime.strftime('%b %d, %Y')
  end

  def format_float_value(val)
    if !(val.is_a? Fixnum)
      sprintf( "%0.01f", val)
    else
      return val.to_s
    end
  end
  
end
