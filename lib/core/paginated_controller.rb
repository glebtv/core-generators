module Core
  module PaginatedController
    extend ActiveSupport::Concern

    included do
      def collection
        @search = end_of_association_chain.search(params[:search])
        get_collection_ivar || set_collection_ivar(@search.paginate(:page => params[:page], :per_page => 10))
      end
    end
  end
end