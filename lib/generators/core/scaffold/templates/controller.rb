class <%= controller_class_name %>Controller < ApplicationController
  
  include Core::InheritedResourceController
<%- if actions.include?('index') -%>
  include Core::PaginatedController
<% end %>
<%- unless default_actions? -%>
  actions <%= actions.map {|a| ":#{a}" }.join(", ") %>
<%- end -%>
end