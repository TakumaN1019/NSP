class ApplicationMailer < ActionMailer::Base
  default from: "TakumaN <nsp@takuman.me>" #SESの場合
  layout 'mailer'
end
