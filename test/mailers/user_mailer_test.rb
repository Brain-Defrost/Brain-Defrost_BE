require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "invite" do
    email = UserMailer.create_invite("me@example.com",
                                     "friend@example.com", Time.now)

    assert_emails 1 do
      email.deliver_now
    end

    
    assert_equal ["me@example.com"], email.from
    assert_equal ["friend@example.com"], email.to
    assert_equal "You have been invited by me@example.com", email.subject
    assert_equal read_fixture("invite").join, email.body.to_s
  end
end
