module Search
  class UserSearch
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
        :fullname_or_email_cont,
        :role_eq,
        :created_at_gteq,
        :created_at_lteq
      )
    end

  end
end
