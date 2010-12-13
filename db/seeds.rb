# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

  #
  # Initial Default Data
  #

  Language.create   :description => "Português",
                    :iso => 'pt',
                    :default_language => true

  Language.create   :description => "English",
                    :iso => 'en'

  Group.create      :description => "Administrators"
  Group.create      :description => "Support Team"
  Group.create      :description => "Support Manager"
  Group.create      :description => "Customers"

  TicketType.create :description => "Installation"
  TicketType.create :description => "Usability"
  TicketType.create :description => "Improvement"

  Enterprise.create :name => "Admin Company",
                    :is_your_company => true,
                    :country_id => 28

  Enterprise.create :name => "Default Customer Company",
                    :country_id => 28

  User.create :name => "admin",
              :email => "admin@admin.com",
              :password => "admin",
              :display_name => "Administrator",
              :group_id => 1,
              :enterprise_id => 1,
              :language_id => 1

  User.create :name => "customer",
              :email => "customer@customer.com",
              :display_name => "Default Customer",
              :password => "customer",
              :group_id => 4,
              :enterprise_id => 2,
              :language_id => 1

  User.create :name => "support",
              :email => "support@support.com.br",
              :display_name => "Technical Support",
              :password => "support",
              :group_id => 2,
              :enterprise_id => 1,
              :language_id => 1

  User.create :name => "support_manager",
              :email => "support_manager@support.com.br",
              :display_name => "Support Manager",
              :password => "support_manager",
              :group_id => 3,
              :enterprise_id => 1,
              :language_id => 1

  Priority.create :description => "Low"
  Priority.create :description => "Normal"
  Priority.create :description => "High"
  Priority.create :description => "Block"

  TicketStatus.create :description => "Closed"
  TicketStatus.create :description => "Cancelled"
  TicketStatus.create :description => "Resolved"
  TicketStatus.create :description => "Reopened"
  TicketStatus.create :description => "Forwarded"

  Resource.create    :value => "text_field_name"
  Resource.create    :value => "select_field_name"
  Resource.create    :value => "rich_text_field_name"
  Resource.create    :value => "search_field"

  Resource.create    :value => "Dflt_option_01"
  Resource.create    :value => "Dflt_option_02"
  Resource.create    :value => "Dflt_option_03"
  Resource.create    :value => "Dflt_option_04"

  Translation.create :resource_id => 1,
                     :language_id => 1,
                     :value => "Campo de texto"

  Translation.create :resource_id => 1,
                     :language_id => 2,
                     :value => "Text field"

  Translation.create :resource_id => 2,
                     :language_id => 1,
                     :value => "Campo de seleção"

  Translation.create :resource_id => 2,
                     :language_id => 2,
                     :value => "Select field"

  Translation.create :resource_id => 2,
                     :language_id => 1,
                     :value => "Editor de texto rico"

  Translation.create :resource_id => 2,
                     :language_id => 2,
                     :value => "Rich text editor"

  Translation.create :resource_id => 4,
                     :language_id => 1,
                     :value => "Campo de busca"

  Translation.create :resource_id => 4,
                     :language_id => 2,
                     :value => "Search Field"

  Field.create       :field_type => "text", 
                     :resource_id => 1

  Field.create       :field_type => "select",
                     :resource_id => 2

  Field.create       :field_type => "rich_text",
                     :resource_id => 3

  Field.create       :field_type => "search",
                     :resource_id => 4

  Translation.create :resource_id => 5,
                     :language_id => 1,
                     :value => "Casa"

  Translation.create :resource_id => 5,
                     :language_id => 2,
                     :value => "House"

  Translation.create :resource_id => 6,
                     :language_id => 1,
                     :value => "Copo"

  Translation.create :resource_id => 6,
                     :language_id => 2,
                     :value => "Glass"

  Translation.create :resource_id => 7,
                     :language_id => 1,
                     :value => "Carne"

  Translation.create :resource_id => 7,
                     :language_id => 2,
                     :value => "Meat"

  Translation.create :resource_id => 8,
                     :language_id => 1,
                     :value => "Ovos"

  Translation.create :resource_id => 8,
                     :language_id => 2,
                     :value => "Eggs"

  FieldOption.create :field_id => 2, :resource_id => 5
  FieldOption.create :field_id => 2, :resource_id => 6
  FieldOption.create :field_id => 2, :resource_id => 7
  FieldOption.create :field_id => 2, :resource_id => 8

  Template.create    :name => "Default",
                     :enabled => true

  TemplateField.create :template_id => 1,
                       :field_id => 1,
                       :resource_id => 1,
                       :width => "300px"

  TemplateField.create :template_id => 1,
                       :field_id => 2,
                       :resource_id => 2,
                       :width => "300px"

  #FieldOption.create

  #
  # Security Things
  #

    ["Allow to maintain users", "Allow to maintain languages", "Allow to admin enterprises", "Allow to maintain user groups", "Allow to admin tickets", "Allow to get tickets", "Allow to configure system"].each do |role|

      Role.create :name => role

    end
  

    ["Allow to get tickets"].each do |role|

        r = Role.find_by_name(role)

        GroupsRole.create(:group_id => Group.find_by_description("Customers").id,
                          :role_id => r.id)

        GroupsRole.create(:group_id => Group.find_by_description("Support Team").id,
                          :role_id => r.id)

    end

    ["Allow to get tickets", "Allow to admin tickets"].each do |role|

        r = Role.find_by_name(role)

        GroupsRole.create(:group_id => Group.find_by_description("Support Manager").id,
                          :role_id => r.id)

    end


    ["index", "show", "new", "edit", "create", "update", "destroy", "add_language", "destroy_language", "default_language", "edit_profile"].each do |action|
      
      Right.create :controller => "users", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to maintain users").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'users'").id

    end

    ["index", "update"].each do |action|

      Right.create :controller => "global_configurations", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to configure system").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'global_configurations'").id

    end

    ["Allow to maintain users", "Allow to maintain languages", "Allow to admin enterprises", "Allow to maintain user groups", "Allow to admin tickets", "Allow to get tickets"].each do |role|

        RightsRole.create :role_id => Role.find_by_name(role).id,
                          :right_id => Right.find_by_action("edit_profile", :conditions => "controller = 'users'").id

        RightsRole.create :role_id => Role.find_by_name(role).id,
                          :right_id => Right.find_by_action("update", :conditions => "controller = 'users'").id

    end

    ["index", "new", "show", "edit", "create", "update", "destroy"].each do |action|

      Right.create :controller => "languages", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to maintain languages").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'languages'").id

    end

    ["index", "new", "show", "edit", "create", "update", "destroy", "update_permission"].each do |action|

      Right.create :controller => "groups", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to maintain user groups").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'groups'").id

    end

    ["index", "new", "create", "edit", "update", "countries", "destroy", "ticket_defaults", "ticket_defaults_save", "clear_default_values", "auto_complete_for_di_server_version", "auto_complete_for_di_device_version", "populate_lists"].each do |action|

      Right.create :controller => "enterprises", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin enterprises").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'enterprises'").id

    end

    ["index", "new", "show", "edit", "create", "update", "destroy", "populate_lists", "language", "set_priorities", "set_users", "get_ticket", "auto_complete_for_di_server_version", "auto_complete_for_di_device_version", "get_emails", "new_log_work_home", "new_log_work", "clear_log_work", "auto_complete"].each do |action|

      Right.create :controller => "tickets", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'tickets'").id

    end

    ["index", "new", "show", "edit", "create", "update", "destroy", "populate_lists", "language", "set_priorities", "get_ticket", "auto_complete_for_di_server_version", "auto_complete_for_di_device_version", "get_emails", "new_log_work_home", "new_log_work", "clear_log_work"].each do |action|

      Right.create :controller => "tickets", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'tickets'").id

    end

    ["create", "destroy", "get_file"].each do |action|

      Right.create :controller => "ticket_files", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'ticket_files'").id

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'ticket_files'").id

    end

    ["create"].each do |action|

      Right.create :controller => "comments", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments'").id

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments'").id

    end

    ["show"].each do |action|

      Right.create :controller => "comments_files", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments_files'").id

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments_files'").id

    end
    ["index", "new", "show", "edit", "create", "update", "destroy", "populate_lists", "language", "set_priorities", "set_users", "get_ticket", "auto_complete_for_di_server_version", "auto_complete_for_di_device_version", "get_emails"].each do |action|

      Right.create :controller => "tickets", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'tickets'").id

    end

    ["index", "new", "show", "edit", "create", "update", "destroy", "populate_lists", "language", "set_priorities", "get_ticket", "auto_complete_for_di_server_version", "auto_complete_for_di_device_version", "get_emails"].each do |action|

      Right.create :controller => "tickets", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'tickets'").id

    end

    ["create", "destroy", "get_file"].each do |action|

      Right.create :controller => "ticket_files", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'ticket_files'").id

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'ticket_files'").id

    end

    ["create"].each do |action|

      Right.create :controller => "comments", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments'").id

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments'").id

    end

    ["show"].each do |action|

      Right.create :controller => "comments_files", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments_files'").id

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'comments_files'").id

    end

    ["new_comment", "clear_comment", "new_log_work", "clear_log_work"].each do |action|

      Right.create :controller => "tickets", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'tickets'").id

    end

    ["new_comment", "clear_comment"].each do |action|

      Right.create :controller => "tickets", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'tickets'").id

    end

    ["create"].each do |action|

      Right.create :controller => "log_works", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to get tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'log_works'").id

    end

    ["create"].each do |action|

      Right.create :controller => "log_works", :action => action

      RightsRole.create :role_id => Role.find_by_name("Allow to admin tickets").id,
                        :right_id => Right.find_by_action(action, :conditions => "controller = 'log_works'").id

    end

    ["Allow to maintain users", "Allow to maintain languages", "Allow to admin enterprises", "Allow to maintain user groups", "Allow to admin tickets", "Allow to get tickets", "Allow to configure system"].each do |role|

        r = Role.find_by_name(role)

        GroupsRole.create(:group_id => Group.find_by_description("Administrators").id,
                          :role_id => r.id)

    end  

  #
  # Create Countries
  #

    ["International Date Line West", "Midway Island", "Samoa"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -11:00')

    end

    ["Hawaii"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -10:00')

    end

    ["Alaska"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -09:00')

    end

    ["Pacific Time (US & Canada)", "Tijuana"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -08:00')

    end

    ["Arizona", "Chihuahua", "Mazatlan", "Mountain Time (US & Canada)"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -07:00')

    end

    ["Central America", "Central Time (US & Canada)", "Guadalajara", "Mexico City", "Monterrey", "Saskatchewan"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -06:00')

    end

    ["Bogota", "Eastern Time (US & Canada)", "Indiana (East)", "Lima", "Quito"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -05:00')

    end

    ["Caracas"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -04:30')

    end

    ["Atlantic Time (Canada)", "La Paz", "Santiago"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -04:00')

    end

    ["Newfoundland"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -03:30')

    end

    ["Brasilia", "Buenos Aires", "Georgetown", "Greenland"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -03:00')

    end

    ["Mid-Atlantic"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -02:00')

    end

    ["Azores", "Cape Verde Is."].each do |c|

      Country.create(:name => c, :time_zone => 'UTC -01:00')

    end

    ["Casablanca", "Dublin", "Edinburgh", "Lisbon", "London", "Monrovia", "UTC"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +00:00')

    end

    ["Amsterdam", "Belgrade", "Berlin", "Bern", "Bratislava", "Brussels", "Budapest", "Copenhagen", "Ljubljana", "Madrid", "Paris", "Prague", "Rome", "Sarajevo", "Skopje", "Stockholm", "Vienna", "Warsaw", "West Central Africa", "Zagreb"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +01:00')

    end

    ["Athens", "Bucharest", "Cairo", "Harare", "Helsinki", "Istanbul", "Jerusalem", "Kyev", "Minsk", "Pretoria", "Riga", "Sofia", "Tallinn", "Vilnius"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +02:00')

    end

    ["Baghdad", "Kuwait", "Moscow", "Nairobi", "Riyadh", "St. Petersburg", "Volgograd"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +03:00')

    end

    ["Tehran"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +03:30')

    end

    ["Abu Dhabi", "Baku", "Muscat", "Tbilisi", "Yerevan"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +04:00')

    end

    ["Kabul"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +04:30')

    end

    ["Ekaterinburg", "Islamabad", "Karachi", "Tashkent"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +05:00')

    end

    ["Chennai", "Kolkata", "Mumbai", "New Delhi", "Sri Jayawardenepura"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +05:30')

    end

    ["Kathmandu"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +05:45')

    end

    ["Almaty", "Astana", "Dhaka", "Novosibirsk"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +06:00')

    end

    ["Rangoon"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +06:30')

    end

    ["Bangkok", "Hanoi", "Jakarta", "Krasnoyarsk"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +07:00')

    end

    ["Beijing", "Chongqing", "Hong Kong", "Irkutsk", "Kuala Lumpur", "Perth", "Singapore", "Taipei", "Ulaan Bataar", "Urumqi"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +08:00')

    end

    ["Osaka", "Sapporo", "Seoul", "Tokyo", "Yakutsk"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +09:00')

    end

    ["Adelaide", "Darwin"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +09:30')

    end

    ["Brisbane", "Canberra", "Guam", "Hobart", "Melbourne", "Port Moresby", "Sydney", "Vladivostok"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +10:00')

    end

    ["Magadan", "New Caledonia", "Solomon Is."].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +11:00')

    end

    ["Auckland", "NFiji", "Kamchatka", "Marshall Is.", "Wellington"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +12:00')

    end

    ["Nuku'alofa"].each do |c|

      Country.create(:name => c, :time_zone => 'UTC +13:00')

    end

 #
 # Global Configurations
 #

  GlobalConfiguration.create :key => "system_title", 
                             :value => "Clever Monkeys"

  GlobalConfiguration.create :key => "system_footer", 
                             :value => "© 2010 Monkey Help. All rights reserved."

  GlobalConfiguration.create :key => "system_dev_host",
                             :value => "http://localhost:3000/"

  GlobalConfiguration.create :key => "system_pro_host",
                             :value => "http://portal.lumleytech.com/"

  GlobalConfiguration.create :key => "dev_host",
                             :value => "pop.gmail.com"

  GlobalConfiguration.create :key => "dev_port",
                             :value => "995"

  GlobalConfiguration.create :key => "dev_email",
                             :value => "dev_mail@email.com"

  GlobalConfiguration.create :key => "dev_pass",
                             :value => "thing"

  GlobalConfiguration.create :key => "pro_host",
                             :value => "pop.gmail.com"

  GlobalConfiguration.create :key => "pro_port",
                             :value => "995"

  GlobalConfiguration.create :key => "pro_email",
                             :value => "prod_email@email.com"

  GlobalConfiguration.create :key => "pro_pass",
                             :value => "super thing"