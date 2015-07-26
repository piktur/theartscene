Spree::Chimpy.config do |config|
  # MailChimp API key
  config.key                   = ENV['MAILCHIMP_API_KEY']

  # Set MailChimp API options
  config.api_options           = {
      throws_exceptions: false,
      timeout: 3600
  }

  # @default 'Members'
  config.list_id               = ENV['MAILCHIMP_LIST_ID']
  config.list_name             = ENV['MAILCHIMP_LIST_NAME']
  # config.customer_segment_name = 'loyal'

  config.subscribe_to_list     = false
  # Auto opt-in
  # NOTE: double_opt_in should = true when auto opt-in enabled.
  # @default false
  config.subscribed_by_default = false
  # Send 'subscription confirmation' email
  # @default false
  config.double_opt_in         = false
  # Send 'welcome' email on subscription
  # NOTE: Recommended when double_opt_in = false
  config.send_welcome_email    = true

  # Store ID. Max 10 characters
  # @default 'spree'
  config.store_id             = Spree::Store.current.code

  # Define merge vars:
  # - key: Name the MailChimp variable. Max 10 characters
  # - value: A Spree::User method.
  # NOTE: Avoid these reserved field names:
  # http://kb.mailchimp.com/article/i-got-a-message-saying-that-my-list-field-name-is-reserved-and-cant-be-used
  # @default {'EMAIL' => :email}
  config.merge_vars = {
    'EMAIL' => :email
  }
end