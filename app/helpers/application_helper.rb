module ApplicationHelper
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
     "m-2 bg-blue-900 hover:bg-blue-700 text-white font-light py-2 px-4 rounded"
  end

  def clear_button_class
    "m-2 bg-white hover:bg-blue-300 text-blue-900 border border-blue-900 font-normal py-2 px-4 rounded"
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
     column_names = ['value','key']
     us_states = Reference.where(active: "TRUE", group: 'us_states')
     us_states = us_states.pluck(column_names.join(',')) 
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
      people_level = Reference.where(active: "TRUE", group: 'people_level')
      people_level = people_level.pluck(:value)       
    end
    
    def gender
      gender = Reference.where(active: "TRUE", group: 'gender')
      gender = gender.order(value: :asc)    
      gender = gender.pluck(:value) 
        
    end
    
    def tshirt_size
      tshirt_size = Reference.where(active: "TRUE", group: 'tshirt_size')
      tshirt_size = tshirt_size.pluck(:value)       
    end
    
    def us_open_role
      us_open_role = Reference.where(active: "TRUE", group: 'us_open_role')
      us_open_role = us_open_role.pluck(:value)       
    end
    
    def transfer_room_type
      transfer_room_type = Reference.where(active: "TRUE", group: 'transfer_room_type')
      transfer_room_type = transfer_room_type.pluck(:value)       
    end
    
    def event_type
      event_type = Reference.where(active: "TRUE", group: 'event_type')
      event_type = event_type.pluck(:value)       
    end
    
    def event_status
      event_status = Reference.where(active: "TRUE", group: 'event_status')
      event_status = event_status.pluck(:value)       
    end
    
    def follow_up_lead_type
      follow_up_lead_type = Reference.where(active: "TRUE", group: 'follow_up_lead_type')
      follow_up_lead_type = follow_up_lead_type.pluck(:value)       
    end
    
    def follow_up_status
      follow_up_status = Reference.where(active: "TRUE", group: 'follow_up_status')
      follow_up_status = follow_up_status.pluck(:value)       
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
      transfer_hotel_arrival = Reference.where(active: "TRUE", group: 'transfer_hotel_arrival')
      transfer_hotel_arrival = transfer_hotel_arrival.pluck(:value)       
    end

    def transfer_hotel_departure
      transfer_hotel_departure = Reference.where(active: "TRUE", group: 'transfer_hotel_departure')
      transfer_hotel_departure = transfer_hotel_departure.pluck(:value)       
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
      member_positions = Reference.where(active: "TRUE", group: 'member_positions')
      member_positions = member_positions.pluck(:value)     
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
     logger.info "#{state}"
#       @list_of_states= Region.where(region: @region)
#        @list_of_states= @list_of_states.pluck(:state)
       @teams = Team.where(state: state.state)
#      @teams_group_by_state = @teams.group_by { |t| t.state }
     end
     
     def get_teams_per_region(region)
      @region = params[:region]
       logger.info "#{region}"
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

     def active_admin_users # a method to get all active users  but not TeamLead role uers, typically used to assign work.
       User.where(account_active: true).where.not(role: 2) 
     end

     def us_open_events
      Event.where(event_type: "US Open").pluck(:name)
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
