# encoding: utf-8

class CampaignsMailer < DbMailer
  default :from => CONFIG[:from_email]

  def campaign_send(campaign, email)
    @campaign = campaign
    attachments.inline['campaign_image'] = {
      :data => File.read(campaign.image.thumb.path),
      :mime_type => 'image/jpg',
      :encoding => 'base64'
    }
    mail(:to => email, :subject => "#{campaign.name} Наобзоре.РФ")
  end
end
