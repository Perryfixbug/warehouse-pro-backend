module Search
  class BaseSearch
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
      @params.fetch(:q, {}).permit!
    end
  end
end