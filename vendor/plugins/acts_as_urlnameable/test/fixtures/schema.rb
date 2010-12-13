ActiveRecord::Schema.define do
  create_table 'articles', :force => true do |t|
    t.column 'title',             :string
    t.column 'body',              :text
    t.column 'person_id',         :integer
    t.column 'comments_enabled',  :boolean, :default => true
    t.column 'type',              :string
  end

  create_table 'pages', :force => true do |t|
    t.column 'title',             :string
    t.column 'body',              :text
    t.column 'section_id',        :integer
  end
  
  create_table 'sections', :force => true do |t|
    t.column 'name',              :string
  end
  
  create_table 'people', :force => true do |t|
    t.column 'full_name',         :string
    t.column 'password',          :string
  end
end