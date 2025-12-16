module Search
  class UserSearch
    private
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
