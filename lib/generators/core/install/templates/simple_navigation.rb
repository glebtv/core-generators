SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.dom_class = 'wat-cf'
    primary.item(:overview, 'Overview', admin_root_path, :highlights_on => /\/admin$/)
  end
end