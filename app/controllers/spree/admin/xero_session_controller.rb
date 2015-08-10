module Spree
  module Admin
    class XeroSessionController < Spree::Admin::BaseController
      before_filter :get_xero_client

      def contacts
        render json:  @client.Contact.all.to_json
      end

      def new
        # request_token = @client.request_token(:oauth_callback => 'https://api.xero.com/api.xro/2.0/xero_session/create')
        # session[:request_token] = request_token.token
        # session[:request_secret] = request_token.secret

        #redirect_to request_token.authorize_url

        # render json: @client.Contact.all
      end

      def create
        @client.authorize_from_request(
            session[:request_token],
            session[:request_secret],
            :oauth_verifier => params[:oauth_verifier] )

        session[:xero_auth] = {
            :access_token => @client.access_token.token,
            :access_key => @client.access_token.secret }

        session[:request_token] = nil
        session[:request_secret] = nil
      end

      def destroy
        session.data.delete(:xero_auth)
      end

      private

      def get_xero_client
        @client = Xeroizer::PrivateApplication.new(
            ENV['DEMO_XERO_CONSUMER_KEY'],
            ENV['DEMO_XERO_CONSUMER_SECRET'],
            "#{Rails.root}/xero/demo/privatekey.pem"
        )

        # Add AccessToken if authorised previously.
        if session[:xero_auth]
          @client.authorize_from_access(
              session[:xero_auth][:access_token],
              session[:xero_auth][:access_key] )
        end
      end
    end
  end
end

# # == API limits
# # A limit of 60 API calls in any 60 second period
# # A limit of 1000 API calls in any 24 hour period
#
# Xeroizer::PublicApplication.new(YOUR_OAUTH_CONSUMER_KEY,
#                                 YOUR_OAUTH_CONSUMER_SECRET,
#                                 :rate_limit_sleep => 2)
#
#
# contacts = xero.Contact.all(:order => 'Name')
#
# contact = xero.Contact.build(:name => 'Contact Name')
# contact.first_name = 'Joe'
# contact.last_name = 'Bloggs'
# # To add to a has_many association use the +add_{association}+ method
# contact.add_address(:type => 'STREET', :line1 => '12 Testing Lane', :city => 'Brisbane')
# contact.add_phone(:type => 'DEFAULT', :area_code => '07', :number => '3033 1234')
# contact.add_phone(:type => 'MOBILE', :number => '0412 123 456')
# contact.save
#
# Xero.Invoice.all(:where => {:type => 'ACCREC', :amount_due_is_not => 0})
#
# # To add to a belongs_to association use the +build_{association}+ method.
# invoices = xero.Invoice.all(:where => 'Contact.ContactID.ToString()=="cd09aa49-134d-40fb-a52b-b63c6a91d712"')
# invoice.build_contact(:name => 'ABC Company')
#
#
# # == Batch creates
# contact1 = xero.Contact.create(some_attributes)
# xero.Contact.batch_save do
#   contact1.email_address = "foo@bar.com"
#   contact2 = xero.Contact.build(some_other_attributes)
#   contact3 = xero.Contact.build(some_more_attributes)
# end