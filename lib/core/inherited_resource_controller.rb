module Core
  module InheritedResourceController
    extend ActiveSupport::Concern

    included do
      inherit_resources
      respond_to :html, :xml, :json, :js
    end
  end
end