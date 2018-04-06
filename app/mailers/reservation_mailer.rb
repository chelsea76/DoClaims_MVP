class ReservationMailer < ApplicationMailer
  def send_email_to_guest(guest, claim)
    @recipient = guest
    @claim = claim
    mail(to: @recipient.email, subject: "Enjoy You Trip! 😘 💋")
  end
end
