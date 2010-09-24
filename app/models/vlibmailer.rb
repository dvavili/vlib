class Vlibmailer < ActionMailer::Base
  def registration_confirmation(user)
    recipients  user.email
    from        "vlib.kodexter@gmail.com"
    subject     "Thank you for Registering"
    body        :user => user
  end
end
