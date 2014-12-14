require 'spec_helper'

describe "UsersLogins" do
  describe "GET /users_logins" do
    let(:user){ FactoryGirl.create(:user) }

    it 'login with invalid information' do
    	get login_path
    	expect(response).to render_template('sessions/new')
    	post login_path, session: { email: "", password: "" }
    	expect(flash.empty?).to be false
    	get root_path
    	expect(flash.empty?).to be true
    end

    it 'login with valid information followed by logout' do
      get login_path
      post login_path, session: { email: user.email, password: user.password }
      expect(response).to redirect_to(user)
      follow_redirect!
      expect(response).to render_template('users/show')
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(user)
      delete logout_path
      expect(response).to redirect_to root_url
      # Simulate a user clicking logout in a second window.
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,     count: 0
      assert_select "a[href=?]", user_path(user), count: 0
    end

    it "login with remembering" do
      post login_path, session: { email:       user.email,
                                  password:    user.password,
                                  remember_me: 1 }
      expect(cookies['remember_token']).to_not be nil
    end

    it "login without remembering" do
      post login_path, session: { email:       user.email,
                                  password:    user.password,
                                  remember_me: 0 }
      session[:user_id] = user.id
      expect(cookies['remember_token']).to be nil
    end
  end
end