# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([ name: "Star Wars" ,  name: "Lord of the Rings" ])
#   Character.create(name: "Luke", movie: movies.first)
#NetballEducator.destroy_all
#NetballEducator.create(first_name: 'Jenna',last_name: 'Jones',email: 'jennajones88@gmail.com',phone: '1314555676',school_name: 'Hillview High School',city: 'Houston',state: 'TX', educator_notes: 'Callback for equipment', mgmt_notes: 'Spoke at meeting', );
#NetballEducator.create(first_name: 'Katlin',last_name: 'Smith',email: 'katlin99@gmail.com',phone: '1314888876',school_name: 'Valleyview High School',city: 'Dallas',state: 'TX', educator_notes: 'Callback for equipment', mgmt_notes: 'Spoke at meeting', );
#NetballEducator.create(first_name: 'Robin',last_name: 'Hall',email: 'robinhall@gmail.com',phone: '162345676',school_name: 'Jackson High School',city: 'Austin',state: 'TX', educator_notes: 'Callback for equipment', mgmt_notes: 'Spoke at session', );
Reference.destroy_all
Reference.create(group:	'sponsor_category',	value:	'--',	active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	"Women's Products", active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	'Oz companies', active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	'UK companies', active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	'NZ companies', active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	'Sth Africa companies', active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	'Caribbean companies', active:	'TRUE');
Reference.create(group:	'sponsor_category',	value:	'Pacific Islander companies', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'--', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Beverage', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Food', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Retail - Clothing', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Retail - Care Products', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Entertainment', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Financial Services', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Media', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Software', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Sports', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Telecommunications', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Tourism', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Transport', active:	'TRUE');
Reference.create(group:	'sponsor_industry',	value:	'Trade & Investment', active:	'TRUE');
Reference.create(group:	'sponsor_status',	value:	'Not Allocated', active:	'TRUE');
Reference.create(group:	'sponsor_status',	value:	'Not Started', active:	'TRUE');
Reference.create(group:	'sponsor_status',	value:	'In Progress', active:	'TRUE');
Reference.create(group:	'sponsor_status',	value:	'Completed', active:	'TRUE');
Reference.create(group:	'sponsor_opportunity_area',	value:	'--', active:	'TRUE');
Reference.create(group:	'sponsor_opportunity_area',	value:	'Corporate', active:	'TRUE');
Reference.create(group:	'sponsor_opportunity_area',	value:	'BAI', active:	'TRUE');
Reference.create(group:	'sponsor_opportunity_area',	value:	'U.S. Open', active:	'TRUE');
Reference.create(group:	'sponsor_opportunity_area',	value:	'NNL', active:	'TRUE');
Reference.create(group:	'sponsor_opportunity_area',	value:	'Member', active:	'TRUE');
Reference.create(group:	'educator_level',	value:	'--', active:	'TRUE');
Reference.create(group:	'educator_level',	value:	'Elementary', active:	'TRUE');
Reference.create(group:	'educator_level',	value:	'Middle', active:	'TRUE');
Reference.create(group:	'educator_level',	value:	'High', active:	'TRUE');
Reference.create(group:	'educator_level',	value:	'University', active:	'TRUE');
Reference.create(group:	'educator_level',	value:	'School/District Lead', active:	'TRUE');
Reference.create(group:	'grant_status',	value:	'Not Started', active:	'TRUE');
Reference.create(group:	'grant_status',	value:	'In Progress', active:	'TRUE');
Reference.create(group:	'grant_status',	value:	'Completed', active:	'TRUE');
Reference.create(group:	'grant_status',	value:	'Submitted', active:	'TRUE');
Reference.create(group:	'grant_status',	value:	'Won', active:	'TRUE');
Reference.create(group:	'grant_status',	value:	'Lost', active:	'TRUE');
Reference.create(group:	'people_role',	value:	'Umpire', active:	'TRUE');
Reference.create(group:	'people_role',	value:	'Scorer', active:	'TRUE');
Reference.create(group:	'people_role',	value:	'Trainer', active:	'TRUE');
Reference.create(group:	'people_role',	value:	'Ambassador', active:	'TRUE');
Reference.create(group:	'people_region',	value:	'US & Canada', active:	'TRUE');
Reference.create(group:	'people_region',	value:	'International', active:	'TRUE');
Reference.create(group:	'people_level',	value:	'Beginner', active:	'TRUE');
Reference.create(group:	'people_level',	value:	'Intermediate', active:	'TRUE');
Reference.create(group:	'people_level',	value:	'Advanced', active:	'TRUE');
Reference.create(group:	'gender',	value:	'Female', active:	'TRUE');
Reference.create(group:	'gender',	value:	'Male', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'XS', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'Small', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'Medium', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'Large', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'XL', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'XXL', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'XXXL', active:	'TRUE');
Reference.create(group:	'tshirt_size',	value:	'XXXXL', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Please select ...', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Assessor/Mentor', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Int Umpire', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'US Umpire', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Scorer', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Operations', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Media', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'NA President', active:	'TRUE');
Reference.create(group:	'us_open_role',	value:	'Medic', active:	'TRUE');
Reference.create(group:	'transfer_room_type',	value:	'King', active:	'TRUE');
Reference.create(group:	'transfer_room_type',	value:	'Double Queen', active:	'TRUE');
Reference.create(group:	'event_type',	value:	'--', active:	'TRUE');
Reference.create(group:	'event_type',	value:	'Booth', active:	'TRUE');
Reference.create(group:	'event_type',	value:	'Virtual Workshop', active:	'TRUE');
Reference.create(group:	'event_type',	value:	'In Person Workshop', active:	'TRUE');
Reference.create(group:	'event_type',	value:	'PE Class', active:	'TRUE');
Reference.create(group:	'event_status',	value:	'Plan', active:	'TRUE');
Reference.create(group:	'event_status',	value:	'Prep', active:	'TRUE');
Reference.create(group:	'event_status',	value:	'Complete', active:	'TRUE');
Reference.create(group:	'follow_up_lead_type',	value:	'--', active:	'TRUE');
Reference.create(group:	'follow_up_lead_type',	value:	'Equipment', active:	'TRUE');
Reference.create(group:	'follow_up_lead_type',	value:	'Workshop', active:	'TRUE');
Reference.create(group:	'follow_up_lead_type',	value:	'Curriculum', active:	'TRUE');
Reference.create(group:	'follow_up_lead_type',	value:	'All', active:	'TRUE');
Reference.create(group:	'follow_up_status',	value:	'Not Allocated', active:	'TRUE');
Reference.create(group:	'follow_up_status',	value:	'Not Started', active:	'TRUE');
Reference.create(group:	'follow_up_status',	value:	'In Progress', active:	'TRUE');
Reference.create(group:	'follow_up_status',	value:	'Complete', active:	'TRUE');

