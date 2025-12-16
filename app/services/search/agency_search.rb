module Search
  class AgencySearch
    def initialize(params, scope)
      @params = params
      @scope = scope
    end

    def call
      ransack.result
    end

    def ransack
      @scope.ransack(ransack_params)
    end

    def ransack_params
      @params.fetch(:q, {}).permit(
        :name_or_phone_or_email_cont,  
      )
    end
  end
end
