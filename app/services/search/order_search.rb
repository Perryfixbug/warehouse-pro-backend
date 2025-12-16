module Search
  class OrderSearch
    def initialize(params, scope)
      @params = params
      @scope = scope
    end

    def call
      ransack.result
    end

    def ransack
      @ransack ||= @scope.ransack(ransack_params)
    end

    def ransack_params
      @params.fetch(:q, {}).permit(
        :id_or_agency_name_cont,
        :type_eq,
        :created_at_gteq
      )
    end
  end
end
