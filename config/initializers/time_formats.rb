# === DATE FORMATS ===

Date::DATE_FORMATS[:default] = "%m/%d/%Y"
# => "08/09/2024" — US-style numeric date

Date::DATE_FORMATS[:d_usa] = "%b %d, %Y"
# => "Aug 09, 2024" — Abbreviated month, full year

Date::DATE_FORMATS[:short_usa_year] = "%b %d, %y"
# => "Aug 09, 24" — Abbreviated month, 2-digit year (new!)

Date::DATE_FORMATS[:default_date] = "%m/%d/%y"
# => "08/09/2024" — Alternate default style


# === TIME FORMATS ===

Time::DATE_FORMATS[:month_and_year] = "%B %Y"
# => "August 2024" — Full month name + year

Time::DATE_FORMATS[:month_and_year_short] = "%m/%y"
# => "08/24" — Numeric month/year, 2-digit

Time::DATE_FORMATS[:short_ordinal] = ->(time) { time.strftime("%B #{time.day.ordinalize}") }
# => "August 9th" — Ordinal day with full month

Time::DATE_FORMATS[:time_24] = ->(time) { time.strftime("%H:%M") }
# => "14:45" — 24-hour time

Time::DATE_FORMATS[:global_date_time] = "%Y-%m-%d %H:%M"
# => "2024-08-09 14:45" — ISO-style datetime

Time::DATE_FORMATS[:usa] = "%b %d, %Y"
# => "Aug 09, 2024" — Abbreviated month, full year

Time::DATE_FORMATS[:short_usa_year] = "%b %d, %y"
# => "Aug 09, 25"

Time::DATE_FORMATS[:usa_dt] = "%b %d, %Y %H:%M"
# => "Aug 09, 2024 14:45" — With time

Time::DATE_FORMATS[:usa_dt_no_time] = "%b %d, %Y"
# => "Aug 09, 2024" — Without time

Time::DATE_FORMATS[:usa_day_dt] = "%A %b %d, %Y  %H:%M"
# => "Monday Aug 09, 2024  14:45  " — With time

# === COMPACT / TABLE DATES ===
Time::DATE_FORMATS[:mdy_short] = "%m/%d/%y"
# => "08/09/24"
