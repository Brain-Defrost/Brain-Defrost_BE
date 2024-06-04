require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "invite" do
    email = UserMailer.create_invite("me@example.com",
                                     "friend@example.com", Time.now)

  
   
  end
end
