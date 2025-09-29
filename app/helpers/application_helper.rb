module ApplicationHelper
  require 'yaml'
    include Pagy::Frontend


    def form_errors_for(record)
      return unless record.errors.any?
    
      content_tag :div, class: "bg-red-100 border border-red-400 text-red-700 rounded p-4 mb-4" do
        concat content_tag(:h2, "#{pluralize(record.errors.count, 'error')} prohibited this record from being saved:", class: "font-semibold text-sm mb-2")
    
        concat content_tag(:ul, class: "list-disc pl-5 text-sm") {
          record.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
        }
      end
    end

    def field_error_for(record, field)
      return unless record.errors[field].any?
    
      content_tag(:p, record.errors[field].first, class: "text-sm text-red-600 mt-1")
    end

    def tab_class(path) #netball educators
      if path && request.path.start_with?(path.to_s)
        "inline-block py-2 px-4 text-blue-900 border-b-2 border-blue-900 hover:border-blue-700 hover:text-blue-700"
      else
        "inline-block py-2 px-4 text-gray-500 border-b-2 border-transparent hover:border-gray-300 hover:text-gray-700"
      end
    end
    # app/helpers/people_helper.rb (or wherever you want it)
    def people_tab_class(is_active)
      if is_active
        "inline-block py-2 px-4 text-blue-900 border-b-2 border-blue-900 hover:border-blue-700 hover:text-blue-700"
      else
        "inline-block py-2 px-4 text-gray-500 border-b-2 border-transparent hover:border-gray-300 hover:text-gray-700"
      end
    end

    #for educators_events_plus (and similar) - CanCan ability related
    def my_person_for(user)
      Person.find_by(email: user.email)
    end
  
    def my_transfer_for(user)
      Transfer.joins(:person).find_by(people: { email: user.email })
    end
    # ------------------------------------------------------------

    # app/helpers/application_helper.rb
    def events_tab_class(path)
      if URI.parse(request.path).path == URI.parse(path).path
        "inline-block py-2 px-4 text-blue-900 border-b-2 border-blue-900 hover:border-blue-700 hover:text-blue-700"
      else
        "inline-block py-2 px-4 text-gray-500 border-b-2 border-transparent hover:border-gray-300 hover:text-gray-700"
      end
    end

    def educators_tab_class(match_path)
      if request.path == URI(match_path).path
        "inline-block py-2 px-4 text-blue-900 border-b-2 border-blue-900 hover:border-blue-700 hover:text-blue-700"
      else
        "inline-block py-2 px-4 text-gray-500 border-b-2 border-transparent hover:border-gray-300 hover:text-gray-700"
      end
    end

    #for pagy
    def pagy_tailwind_nav(pagy)
      link_proc = pagy_link_proc(pagy)
      html = +%(<nav class="pagy-nav" role="navigation" aria-label="Pagination"><ul class="inline-flex items-center -space-x-px text-sm">)
  
      pagy.series.each do |item|
        case item
        when Integer
          html << %(<li><a href="#{link_proc.call(item)}" class="z-10 bg-white border border-gray-300 text-gray-900 hover:bg-gray-100 hover:text-blue-700 px-3 py-2 leading-tight">#{item}</a></li>)
        when String
          html << %(<li><span class="z-10 bg-blue-50 border border-blue-300 text-blue-600 px-3 py-2 leading-tight">#{item}</span></li>)
        when :gap
          html << %(<li><span class="z-10 bg-white border border-gray-300 text-gray-500 px-3 py-2 leading-tight">…</span></li>)
        end
      end
  
      html << %(</ul></nav>)   # ✅ Add to the html string first
      html.html_safe           # ✅ Then mark the full thing safe
    end
    
    
    #for paper trail
    def audit_user_label(whodunnit)
      user = User.find_by(id: whodunnit)
      user ? "#{user.first_name} #{user.last_name}" : "Unknown User"
    end

    #ALSO for paper trail 
    def display_changes_from_object(v)
      raw = v.object_changes
      return "No changes" if raw.blank?
    
      begin
        changes_hash = Psych.unsafe_load(raw)
      rescue => e
        return "Could not parse changes: #{e.class} - #{e.message}"
      end
    
      return "No changes" unless changes_hash.is_a?(Hash)
    
      skip_fields = %w[
        instagram other_sm facebook twitter phone address website updated_at notes
      ]
    
      rows = changes_hash.map do |attr, values|
        next if skip_fields.include?(attr.to_s.downcase)
    
        old_val, new_val = values
        old = normalize_blank(format_value(old_val))
        new = normalize_blank(format_value(new_val))
        
        # Skip if both are effectively empty
        next if old.blank? && new.blank?
        
        # Skip noise like nil → false or false → nil
        next if new == "false" && old.blank?
    
        "<tr><td class='px-2 py-1 font-medium'>#{attr.to_s.titleize}</td><td class='px-2 py-1'>#{old}</td><td class='px-2 py-1'>#{new}</td></tr>"
      end.compact.join
    
      return "No meaningful changes" if rows.blank?
    
      <<~HTML.html_safe
        <table class="text-xs ">
          #{rows}
        </table>
      HTML
    end

        #PAPERTRAIL
    def normalize_blank(value)
      value = value.to_s.strip
      value.downcase == "nil" ? "" : value
    end    
    

    #PAPERTRAIL
    def audit_event_badge(event)
      case event
      when "create"
        content_tag(:span, "➕ Create", class: "text-green-700 font-semibold")
      when "update"
        content_tag(:span, "🔄 Update", class: "text-blue-700 font-semibold")
      when "destroy"
        content_tag(:span, "❌ Delete", class: "text-red-700 font-semibold")
      else
        content_tag(:span, event.titleize, class: "text-gray-600")
      end
    end
    
    
    def format_value(value)
      case value
      when ActiveSupport::TimeWithZone, Time, DateTime
        value.strftime("%Y-%m-%d %H:%M")
      when TrueClass then "true"
      when FalseClass then "false"
      when NilClass then "nil"
      else
        value.to_s
      end
    end
    

    def current_membership_year
      today = Date.today
      feb_first = Date.new(today.year, 2, 1)

      if today < feb_first
        today.year - 1 # Still old year
      else
        today.year # New membership year
      end
    end

    
   def label_class
     "block text-sm font-medium text-gray-700"
   end

   def input_class
     "block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 hover:bg-gray-100 sm:text-sm"
   end
   
   def form_input_class
     "w-full appearance-none rounded-md border border-gray-300 p-4 px-3 py-2 placeholder-gray-400 shadow-sm hover:border-blue-900 focus:border-blue-900 focus:outline-none focus:ring-blue-900 bg-gray-100 sm:text-sm"
   end

   def tight_form_input_class
    "w-full appearance-none rounded-md border border-gray-300 placeholder-gray-400 shadow-sm hover:border-blue-900 focus:border-blue-900 focus:outline-none focus:ring-blue-900 bg-gray-100 sm:text-sm"
  end

  def tight_form_input_class_with_gap
    "w-11/12 appearance-none rounded-md border border-gray-300 placeholder-gray-400 shadow-sm hover:border-blue-900 focus:border-blue-900 focus:outline-none focus:ring-blue-900 bg-gray-100 sm:text-sm"
  end
   
   def required_input_class
     "required:border-red-500 block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 hover:bg-gray-100 sm:text-sm"
   end
   
   def small_input_class
     "block w-sm appearance-none text-right rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 sm:text-sm hover:bg-gray-100"
   end

   def xs_input_class
    "block w-xs appearance-none text-right rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 sm:text-sm hover:bg-gray-100"
  end

   def number_input_class
    "block w-xs appearance-none text-right rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 sm:text-sm"
  end

  def form_button_class
     "m-2 bg-blue-900 hover:bg-blue-700 text-white font-light py-2 px-3 rounded"
  end

  def clear_button_class
    "m-2 bg-white hover:bg-blue-100 text-blue-900 border border-blue-900 font-light py-2 px-3 rounded text-base leading-normal"
  end
  

  def small_button_class
    "justify-center rounded-md border border-transparent bg-blue-900 py-2 px-4 text-sm font-light text-white shadow-sm hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-blue-900 focus:ring-offset-2"
  end

  def teal_button_class
    "justify-center rounded-md border border-transparent bg-teal-600 py-1 px-4 text-sm font-light text-white shadow-sm hover:border-black hover:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-900 focus:ring-offset-2"
  end
  
  def clear_button_class
    "bg-transparent hover:bg-blue-300 text-blue-900 font-semibold hover:text-white py-2 px-4 border border-blue-900 hover:border-transparent rounded"
  end
  
   def ex_input_class
     "block w-full appearance-none rounded-md border border-gray-300 px-2 py-1 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 sm:text-sm invalid:border-red-500"
   end

   def ex_label_class
      "block text-sm font-medium text-gray-700 invalid:border-red-500"
    end
    
    def test_label
      "block mb-2 text-sm font-medium text-gray-900 dark:text-white"
    end
    
    def test_input
      "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
    end
   
   def table_header_class
     "font-bold p-2 border-b text-left bg-blue-900 text-white"
   end
   
   def block_link_class
     "block text-md font-medium text-blue-900 italic"
   end
   
   def link_class
     "text-md font-medium text-blue-800 italic hover:text-blue-600 hover:underline hover:underline-offset-4"
   end
   
   def red_link_class
     "text-md font-medium text-red-500 italic"
   end
   
   def green_link_class
     "text-md font-medium text-green-600 italic"
   end
   
   def list_class_other
     "block px-4 py-2 text-sm text-gray-700"
   end
   
   def routing_link_class
     "text-sm text-blue-900"
   end
   
   #TURBO USAGE ONLY
   def nested_dom_id(*args)
       args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
     end
   
   
    #REFERENECE DATA ONLY
   def reference_group
     reference_group = Reference.all.order(group: :asc)
     reference_group = reference_group.pluck(:group) 
     reference_group = reference_group.uniq() 
   end
   
    def us_states
      Reference
        .where(active: true, group: 'us_states')
        .order(Arel.sql('CAST("desc" AS INTEGER) ASC')) # ✅ quoting reserved word
        .pluck(:value, :key)
    end

    def my_netball_status
      Reference.where(active: true, group: 'my_netball_status').pluck(:value)   
    end

    def subscription_plan
      Reference.where(active: true, group: 'subscription_plan')
              .pluck(:value)
              .sort_by { |v| v.to_f }
    end
   
   def club_membership_category
    club_membership_category = Reference.where(active: "TRUE", group: 'club_membership_category').order(:id)
    club_membership_category = club_membership_category.pluck(:value)  
   end

   def sponsor_category
     sponsor_category = Reference.where(active: "TRUE", group: 'sponsor_category').order(:value)
     sponsor_category = sponsor_category.pluck(:value)  
   end
   
   def sponsor_industry
     sponsor_industry = Reference.where(active: "TRUE", group: 'sponsor_industry').order(:value)
     sponsor_industry = sponsor_industry.pluck(:value)  
   end
   
   def sponsor_status
     sponsor_status = Reference.where(active: "TRUE", group: 'sponsor_status')
     sponsor_status = sponsor_status.pluck(:value)  
   end
   
   def sponsor_opportunity_area
     sponsor_opportunity_area = Reference.where(active: "TRUE", group: 'sponsor_opportunity_area').order(:value)
     sponsor_opportunity_area = sponsor_opportunity_area.pluck(:value)       
   end

   def sponsor_type
    sponsor_type = Reference.where(active: "TRUE", group: 'sponsor_type')
    sponsor_type = sponsor_type.pluck(:value)  
   end

   def educator_level
     educator_level = Reference.where(active: "TRUE", group: 'educator_level')
     educator_level = educator_level.pluck(:value)       
   end

   def educator_roles
    Reference.where(active: true, group: 'educator_roles').pluck(:value)
  end

    def grant_status
      grant_status = Reference.where(active: "TRUE", group: 'grant_status')
      grant_status = grant_status.pluck(:value)       
    end
    
    def people_role
      people_role = Reference.where(active: "TRUE", group: 'people_role')
      people_role = people_role.pluck(:value)       
    end

    def partner_decision
      partner_decision = Reference.where(active: "TRUE", group: 'partner_decision')
      partner_decision = partner_decision.pluck(:value)       
    end
    
    def people_region
      people_region = Reference.where(active: "TRUE", group: 'people_region')
      people_region = people_region.pluck(:value)       
    end
    
    def people_level
      Reference.where(active: true, group: 'people_level').pluck(:value)   
    end

    def people_status
      Reference.where(active: true, group: 'people_status').pluck(:value)
    end

    def people_educator_role
      Reference.where(active: true, group: 'people_educator_role').pluck(:value)
    end

    def country_list
      Reference.where(active: true, group: 'country_list')
               .order(Arel.sql('CAST("desc" AS INTEGER) ASC'))
               .pluck(:value)
    end
    
    def gender
      gender = Reference.where(active: "TRUE", group: 'gender')
      gender = gender.order(value: :asc)    
      gender = gender.pluck(:value) 
    end
    
    def tshirt_size
      Reference.where(active: true, group: 'tshirt_size').pluck(:value)   
    end
    
    def us_open_role
      Reference.where(active: true, group: 'us_open_role').pluck(:value)        
    end

    def airport_transport_request_options
      Reference.where(active: true, group: 'airport_transport_request_options').pluck(:value)        
    end
    
    def transfer_room_type
      transfer_room_type = Reference.where(active: "TRUE", group: 'transfer_room_type')
      transfer_room_type = transfer_room_type.pluck(:value)       
    end
    
    def event_type
      event_type = Reference.where(active: "TRUE", group: 'event_type').ordered
      event_type = event_type.pluck(:value)       
    end
    
    def event_status
      event_status = Reference.where(active: "TRUE", group: 'event_status')
      event_status = event_status.pluck(:value)       
    end

    def attendance
      attendance = Reference.where(active: "TRUE", group: 'attendance')
      attendance = attendance.pluck(:value)       
    end
    
    def follow_up_lead_type
      follow_up_lead_type = Reference.where(active: "TRUE", group: 'follow_up_lead_type')
      follow_up_lead_type = follow_up_lead_type.pluck(:value)       
    end
    
    def follow_up_status
      follow_up_status = Reference.where(active: "TRUE", group: 'follow_up_status')
      follow_up_status = follow_up_status.pluck(:value)       
    end

    def club_note_status
      #use a duplicate of followup for ease
      follow_up_status = Reference.where(active: "TRUE", group: 'follow_up_status')
      follow_up_status = follow_up_status.pluck(:value) 
      club_note_status = follow_up_status.reject { |item| item == "Not Allocated" } 
    end
    
    def transfer_pickup_type
      transfer_pickup_type = Reference.where(active: "TRUE", group: 'transfer_pickup_type')
      transfer_pickup_type = transfer_pickup_type.pluck(:value)       
    end
    
    def transfer_departure_type
      transfer_departure_type = Reference.where(active: "TRUE", group: 'transfer_departure_type')
      transfer_departure_type = transfer_departure_type.pluck(:value)       
    end
    
    def us_open_hotel_name
      us_open_hotel_name = Reference.where(active: "TRUE", group: 'us_open_hotel_name')
      us_open_hotel_name = us_open_hotel_name.pluck(:value)       
    end
    
    def people_invite_back
      people_invite_back = Reference.where(active: "TRUE", group: 'people_invite_back')
      people_invite_back = people_invite_back.pluck(:value)       
    end

    def airline
      airline = Reference.where(active: "TRUE", group: 'airline')
      airline = airline.pluck(:value)       
    end
    
    def regions
      regions = Reference.where(active: "TRUE", group: 'regions')
      regions = regions.pluck(:value)       
    end

    def transfer_hotel_arrival
      Reference.where(active: true, group: 'transfer_hotel_arrival').order(:desc).pluck(:value)
    end

    def transfer_hotel_departure
      Reference.where(active: "TRUE", group: 'transfer_hotel_departure').order(:desc).pluck(:value)
     end
    
    def timezones
      timezones = Reference.where(active: "TRUE", group: 'timezones')
      timezones = timezones.pluck(:value)       
    end
    
    def member_age_status
      member_age_status = Reference.where(active: "TRUE", group: 'member_age_status')
      member_age_status = member_age_status.pluck(:value)     
    end
    
    def member_positions
      Reference.where(active: true, group: 'member_positions').pluck(:value).sort
    end

    def member_engagement_status
      member_engagement_status = Reference.where(active: "TRUE", group: 'member_engagement_status')
      member_engagement_status = member_engagement_status.pluck(:value)     
    end

    def member_membership_type
      member_membership_type = Reference.where(active: "TRUE", group: 'member_membership_type')
      member_membership_type = member_membership_type.pluck(:value)     
    end

    def opportunity_outcome
      opportunity_outcome = Reference.where(active: "TRUE", group: 'opportunity_outcome')
      opportunity_outcome = opportunity_outcome.pluck(:value)     
    end

    def payment_type
      payment_type = Reference.where(active: "TRUE", group: 'payment_type')
      payment_type = payment_type.pluck(:value)     
    end

    def facility_type
      facility_type = Reference.where(active: "TRUE", group: 'facility_type')
      facility_type = facility_type.pluck(:value)     
    end

    def program_stage
      program_stage = Reference.where(active: "TRUE", group: 'program_stage')
      program_stage = program_stage.pluck(:value)    
    end

    def generic_option
      generic_option = Reference.where(active: "TRUE", group: 'generic_option')
      generic_option = generic_option.pluck(:value)     
    end

    def expat_co
      expat_co = Reference.where(active: "TRUE", group: 'expat_co')
      expat_co = expat_co.pluck(:value)     
    end

    def media_type
      media_type = Reference.where(active: "TRUE", group: 'media_type')
      media_type = media_type.pluck(:value)     
    end
    
     def get_teams_per_state(state)
     state = params[:state]
     #logger.info "#{state}"
#       @list_of_states= Region.where(region: @region)
#        @list_of_states= @list_of_states.pluck(:state)
       @teams = Team.where(state: state.state)
#      @teams_group_by_state = @teams.group_by { |t| t.state }
     end
     
     def get_teams_per_region(region)
      @region = params[:region]
       #logger.info "#{region}"
       @list_of_states= Region.where(region: @region)
       @list_of_states= @list_of_states.pluck(:state)
       @teams = Team.where('state IN (?)', @list_of_states)
       @teams_group_by_state = @teams.group_by { |t| t.state }
     end

     

     def members_belonging_to_administrator
      teams_owned_by_user = NaTeam.where(user_id: @current_user.id)
      teams_owned_by_user = teams_owned_by_user.pluck(:id) 
      members_belonging_to_administrator = Member.where(na_team_id: teams_owned_by_user)
      members_belonging_to_administrator = members_belonging_to_administrator.pluck(:first_name)
     end

     #REPLICATED IN USER MODEL AS SCOPE 
     def active_admin_users # a method to get all active users  but not TeamLead role uers, typically used to assign work.
      User.where(account_active: true)
      .where.not(role: [2, 12])
      .where.not(last_name: "Pethick") # ⬅️ exclude that person
      .order(:first_name)
      end

      #REPLICATED IN USER MODEL AS SCOPE 
      def active_educator_users # a method to get all active users  but not TeamLead role uers, typically used to assign work.
        User.where(account_active: true)
        .where.(role: [4, 8, 10])# ⬅️ include educator roles
        .where.not(last_name: "Pethick") # ⬅️ exclude that person
        .where.(last_name: "Ottoway") # ⬅️ exclude that person
        .order(:first_name)
        end
      

     def us_open_events
      Event.where(event_type: "US Open").pluck(:name)
     end

     def us_open_invite_status
      Reference.where(active: true, group: 'us_open_invite_status').order(value: :desc).pluck(:value)    
     end

     def yes_no_badge(value)
      if value
        content_tag(:span, "Yes", class: "inline-block px-2 py-1 text-xs font-semibold text-green-800 bg-green-100 rounded-full")
      else
        content_tag(:span, "No", class: "inline-block px-2 py-0.5 text-xs font-medium text-gray-600 bg-gray-100 rounded-full")
      end
    end

    def current_us_open_event
      @current_us_open_event ||= Event
        .where(event_type: "US Open")
        .where("extract(year from date) = ?", Time.zone.now.year)
        .order(date: :desc)
        .first
    end

     # american states only used for filtering
     def american_states
      [
        ["Alabama", "AL"], ["Alaska", "AK"], ["Arizona", "AZ"], ["Arkansas", "AR"],
        ["California", "CA"], ["Colorado", "CO"], ["Connecticut", "CT"], ["Delaware", "DE"],
        ["Florida", "FL"], ["Georgia", "GA"], ["Hawaii", "HI"], ["Idaho", "ID"],
        ["Illinois", "IL"], ["Indiana", "IN"], ["Iowa", "IA"], ["Kansas", "KS"],
        ["Kentucky", "KY"], ["Louisiana", "LA"], ["Maine", "ME"], ["Maryland", "MD"],
        ["Massachusetts", "MA"], ["Michigan", "MI"], ["Minnesota", "MN"], ["Mississippi", "MS"],
        ["Missouri", "MO"], ["Montana", "MT"], ["Nebraska", "NE"], ["Nevada", "NV"],
        ["New Hampshire", "NH"], ["New Jersey", "NJ"], ["New Mexico", "NM"], ["New York", "NY"],
        ["North Carolina", "NC"], ["North Dakota", "ND"], ["Ohio", "OH"], ["Oklahoma", "OK"],
        ["Oregon", "OR"], ["Pennsylvania", "PA"], ["Rhode Island", "RI"], ["South Carolina", "SC"],
        ["South Dakota", "SD"], ["Tennessee", "TN"], ["Texas", "TX"], ["Utah", "UT"],
        ["Vermont", "VT"], ["Virginia", "VA"], ["Washington", "WA"], ["West Virginia", "WV"],
        ["Wisconsin", "WI"], ["Wyoming", "WY"]
      ]
    end

    

     
end
