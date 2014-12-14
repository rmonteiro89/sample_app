require 'spec_helper'

describe SessionsHelper do
	let(:user) { FactoryGirl.build(:user) }

	before :each do
		helper.remember user
	end

  it "current_user returns right user when session is nil" do
    expect(user).to eql helper.current_user
  end

  it "current_user returns nil when remember digest is wrong" do
    user.update_attribute(:remember_digest, User.digest(User.new_token))
    expect(helper.current_user).to be nil
  end
end
