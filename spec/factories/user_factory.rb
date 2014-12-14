FactoryGirl.define do
	factory :user do
  	name 'Michael Example'
  	email 'michael@example.com'
  	password 'password'
  	password_confirmation 'password'
  	admin true

  	factory :many_users do |user|
			user.sequence(:name)  { |n| 'Example#{n}' }
			user.sequence(:email) { |n| "example#{n}@example.com"}
			user.password "123456"
			user.password_confirmation "123456"
		end
	end
end