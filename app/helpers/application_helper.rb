module ApplicationHelper
  def label_class
     "block text-sm font-medium text-gray-700"
   end

   def input_class
     "block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 hover:bg-gray-100 sm:text-sm"
   end
   
   def small_input_class
     "block w-sm appearance-none text-right rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-blue-900 focus:outline-none focus:ring-blue-900 sm:text-sm"
   end

   def form_button_class
     "flex w-full justify-center rounded-md border border-transparent bg-blue-900 py-2 px-4 text-sm font-light text-white shadow-sm hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-blue-900 focus:ring-offset-2"
   end

   def small_button_class
    "justify-center rounded-md border border-transparent bg-blue-900 py-2 px-4 text-sm font-light text-white shadow-sm hover:bg-blue-900 focus:outline-none focus:ring-2 focus:ring-blue-900 focus:ring-offset-2"
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
     "text-md font-medium text-blue-900 italic"
   end
   
   def list_class_other
     "block px-4 py-2 text-sm text-gray-700"
   end
   
   def routing_link_class
     "text-sm text-blue-900"
   end
   
   
   def reference_group
     reference_group = Reference.all
     reference_group = reference_group.pluck(:group) 
     reference_group = reference_group.uniq() 
   end
   def us_states
       [
         [""],
         ['Alabama', 'AL'],
         ['Alaska', 'AK'],
         ['Arizona', 'AZ'],
         ['Arkansas', 'AR'],
         ['California', 'CA'],
         ['Colorado', 'CO'],
         ['Connecticut', 'CT'],
         ['Delaware', 'DE'],
         ['District of Columbia', 'DC'],
         ['Florida', 'FL'],
         ['Georgia', 'GA'],
         ['Hawaii', 'HI'],
         ['Idaho', 'ID'],
         ['Illinois', 'IL'],
         ['Indiana', 'IN'],
         ['Iowa', 'IA'],
         ['Kansas', 'KS'],
         ['Kentucky', 'KY'],
         ['Louisiana', 'LA'],
         ['Maine', 'ME'],
         ['Maryland', 'MD'],
         ['Massachusetts', 'MA'],
         ['Michigan', 'MI'],
         ['Minnesota', 'MN'],
         ['Mississippi', 'MS'],
         ['Missouri', 'MO'],
         ['Montana', 'MT'],
         ['Nebraska', 'NE'],
         ['Nevada', 'NV'],
         ['New Hampshire', 'NH'],
         ['New Jersey', 'NJ'],
         ['New Mexico', 'NM'],
         ['New York', 'NY'],
         ['North Carolina', 'NC'],
         ['North Dakota', 'ND'],
         ['Ohio', 'OH'],
         ['Oklahoma', 'OK'],
         ['Oregon', 'OR'],
         ['Pennsylvania', 'PA'],
         ['Puerto Rico', 'PR'],
         ['Rhode Island', 'RI'],
         ['South Carolina', 'SC'],
         ['South Dakota', 'SD'],
         ['Tennessee', 'TN'],
         ['Texas', 'TX'],
         ['Utah', 'UT'],
         ['Vermont', 'VT'],
         ['Virginia', 'VA'],
         ['Washington', 'WA'],
         ['West Virginia', 'WV'],
         ['Wisconsin', 'WI'],
         ['Wyoming', 'WY']
       ]
   end
   
   def sponsor_category
     sponsor_category = Reference.where(active: "TRUE", group: 'sponsor_category')
     sponsor_category = sponsor_category.pluck(:value)  
   end
   
   def sponsor_industry
     sponsor_industry = Reference.where(active: "TRUE", group: 'sponsor_industry')
     sponsor_industry = sponsor_industry.pluck(:value)  
   end
   
   def sponsor_status
     sponsor_status = Reference.where(active: "TRUE", group: 'sponsor_status')
     sponsor_status = sponsor_status.pluck(:value)  
   end
   
   def sponsor_opportunity_area
     sponsor_opportunity_area = Reference.where(active: "TRUE", group: 'sponsor_opportunity_area')
     sponsor_opportunity_area = sponsor_opportunity_area.pluck(:value)       
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
end
