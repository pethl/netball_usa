module EventsHelper
  def event_filter_path
    action_name == "index_past" ? past_events_path : events_path
  end  


end