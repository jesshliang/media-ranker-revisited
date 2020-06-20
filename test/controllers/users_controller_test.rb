require "test_helper"

describe UsersController do

	describe "login" do
		it "can login a existing user" do
			start_count = User.count

			perform_login(users(:kari))
			must_respond_with :redirect

			User.count.must_equal start_count
		end

		it "can login a new user" do 
			new_user = User.new(
				provider: "github",
				uid: 22,
				email: "kari@gmail.com",
				username: "bingus",
				name: "leroy"
			)

			expect {
				perform_login(new_user)
		}.must_change "User.count", 1

			must_respond_with :redirect
		end
	end

	describe "logout" do

	end

end
