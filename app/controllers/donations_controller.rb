class DonationsController < ApplicationController
  def setup_authorize_hash    
  end
  
  def check_authorization(user)
    return true if params[:action] == "paypal_ipn" # For now, there's nothing non-public, but make sure we have to update it if we add an action
  end
  def paypal_ipn
    notify = Paypal::Notification.new(request.raw_post)

    if notify.acknowledge
      begin

        if notify.complete? and params['reciever_email'] == 'velvet@pele.cx'
          donation = Donation.new()
          donation.donation_date = notify.recieved_at()
          donation.txn_id = notify.transaction_id()
          donation.amount = notify.gross()
          donation.email = params['payer_email']
          donation.save
        else
          logger.error("Failed to verify Paypal's notification, please investigate")
        end

      rescue => e
      end
    end

    render :nothing
  end

end
