FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-11-26 14:31:32" }
  end
end
