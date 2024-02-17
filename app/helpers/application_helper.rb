module ApplicationHelper
  def label_class
     "block text-sm font-medium text-gray-700"
   end

   def input_class
     "block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-sky-800 focus:outline-none focus:ring-sky-800 sm:text-sm"
   end

   def form_button_class
     "flex w-full justify-center rounded-md border border-transparent bg-indigo-800 py-2 px-4 text-sm font-medium text-black shadow-sm hover:bg-sky-800 focus:outline-none focus:ring-2 focus:ring-sky-800 focus:ring-offset-2"
   end
   
   def table_header_class
     "font-bold p-2 border-b text-left bg-sky-800 text-white"
   end
   
   def block_link_class
     "block text-md font-medium text-sky-800 italic"
   end
   
   def link_class
     "text-md font-medium text-sky-800 italic"
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
   
   def sponsor_category
       [
         ["--"],
         ["Women's Products"],
         ['Oz companies'],
         ['UK companies'],
         ['NZ companies'],
         ['Sth Africa companies'],
         ['Caribbean companies'],
         ['Pacific Islander companies']
       ]       
   end
   
   def sponsor_industry
     [
       ['--'],['Beverage'], ['Food'], ['Retail - Clothing'], ['Retail - Care Products'], ['Entertainment'], ['Financial Services'], ['Media'], ['Software'], ['Sports'], ['Telecommunications'], ['Tourism'], ['Transport'], ['Trade & Investment']
     ]
   end
   
   def sponsor_status
       [
         ['Not Allocated'],
         ['Not Started'],
         ['In Progress'],
         ['Completed'],
       ]       
   end
   
   def sponsor_opportunity_area
       [
         ["--"],
         ['Corporate'],
         ['BAI'],
         ['U.S. Open'],
         ['NNL'],
         ['Member']
       ]       
   end
end
