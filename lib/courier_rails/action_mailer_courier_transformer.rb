class ActionMailerCourierTransformer
  def tranform_email_body_for_override(mail, email_override = {channel: {email: {}}})
    email_override[:channel][:email][:html] = mail.html_part.decoded unless mail.html_part.nil?
    email_override[:channel][:email][:text] = mail.text_part.decoded unless mail.text_part.nil?
    email_override
  end
end
