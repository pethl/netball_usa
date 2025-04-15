FactoryBot.define do
  factory :sponsor do
    company_name          { "NetballGear Inc." }
    sponsor_category      { "Clothing" }
    industry              { "Sports Apparel" }

    location              { "This is now sociual media" } #change of field use
    city                  { "Los Angeles" }
    state                 { "CA" }
    expat_co              { "Australia" }

    about                 { "Leading supplier of netball gear and apparel." }
    other_locations       { "UK, Australia" }
    website               { "https://www.netballgear.com" }
    other_link            { "https://linkedin.com/netballgear" }

    notes                 { "Very interested after initial conversation." }

    user
    
    ## IMPORTANT NO OTHER FIELDS ARE NEEDED
  end
end
