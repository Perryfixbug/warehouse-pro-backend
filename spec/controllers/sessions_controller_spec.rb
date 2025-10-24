require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "POST #create" do
    let!(:user) { User.create!(fullname: "John", email: "john@example.com", password: "password", password_confirmation: "password") }

    context "with valid credentials" do
      it "logs in successfully and redirects" do
        post :create, params: { session: { email: "john@example.com", password: "password", "remember_me": "1" } }

        # expect(session[:user_id]).to eq(user.id)
        # expect(flash[:success]).to eq("Login success")
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid credentials" do
      it "renders login page with error" do
        post :create, params: { session: { email: "john@example.com", password: "password1" } }

        expect(session[:user_id]).to be_nil
        # expect(flash.now[:danger]).to eq("Invalid email or password")
        expect(response).to render_template(:new)
      end
    end
  end
end
