module Search
  class OrderSearch < BaseSearch
    private
    def ransack_params
      @params.fetch(:q, {}).permit(
        :id_or_agency_name_cont,
        :type_eq,
        :created_at_gteq
      )
    end
  end
end
