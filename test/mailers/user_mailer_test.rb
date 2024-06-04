require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "invite" do
    email = UserMailer.create_invite("me@example.com",
                                     "friend@example.com", Time.now)

    assert_emails 1 do
      email.deliver_now
    end

    
    assert_equal ["me@example.com"], email.from
    
  end
end
