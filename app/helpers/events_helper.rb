module EventsHelper
  def event_filter_path
    action_name == "index_past" ? past_events_path : events_path
  end  

  def current_tab_class
    action_name == "index" ? "underline underline-offset-4 text-blue-900" : "text-blue-900"
  end

  def past_tab_class
    action_name == "index_past" ? "underline underline-offset-4 text-blue-900" : "text-blue-900"
  end
end