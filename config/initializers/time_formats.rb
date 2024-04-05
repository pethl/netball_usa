Time::DATE_FORMATS[:month_and_year] = '%B %Y'
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
Time::DATE_FORMATS[:time_24] = lambda { |time| time.strftime("%H:%M ") }
Time::DATE_FORMATS[:default] = '%Y-%m-%d %H:%M'
Time::DATE_FORMATS[:usa] = '%m.%d.%Y'
Time::DATE_FORMATS[:usa_dt] = '%m.%d.%Y %H:%M'
Time::DATE_FORMATS[:hour_clock_12] = '%I:%M %p'