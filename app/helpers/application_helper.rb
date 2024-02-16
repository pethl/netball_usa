module ApplicationHelper
  def label_class
     "block text-sm font-medium text-gray-700"
   end

   def input_class
     "block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
   end

   def form_button_class
     "flex w-full justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
   end
   
   def block_link_class
     "block text-md font-medium text-cyan-800 italic"
   end
   
   def link_class
     "text-md font-medium text-cyan-800 italic"
   end
   
   def us_states
       [
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
end
