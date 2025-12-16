module Search
  class ProductSearch < BaseSearch
    def ransack_params
      @params.fetch(:q, {}).permit(
        :name_cont,
        :unit_eq,
        :price_per_unit_gteq,
        :price_per_unit_lteq,
        :created_at_gteq,
        :created_at_lteq
      )
    end
  end
end
