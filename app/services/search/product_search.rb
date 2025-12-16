module Search
  class ProductSearch
    def initialize(params, scope)
      @params = params
      @scope = scope
    end

    def call
      ransack.result
    end

    private
    
    def ransack
      @ransack ||= @scope.ransack(ransack_params)
    end
    
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
