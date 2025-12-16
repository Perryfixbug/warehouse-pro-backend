module Search
  class BaseSearch
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
      rails NoMethodError, "Subclasses must implement ransack_params method"
    end
  end
end
