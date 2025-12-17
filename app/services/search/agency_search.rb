module Search
  class AgencySearch < BaseSearch
    private
    def ransack_params
      @params.fetch(:q, {}).permit(
        :name_or_phone_or_email_cont,  
      )
    end
  end
end
