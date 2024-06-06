class UsersController < ApplicationController
  def invite
    sender_email = params[:sender_email]
    recipient_email = params[:recipient_email]

    if sender_email.blank? || recipient_email.blank?
      render json: { error: 'Sender and recipient emails are required' }, status: :unprocessable_entity
      return
    end

    email = UserMailer.create_invite(sender_email, recipient_email, Time.now)
    email.deliver_now

    render json: { message: 'Invite sent successfully' }, status: :ok
  end
end

