source 'https://rubygems.org'

gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.2'

gem 'figaro'

# Use Slim from cleaner HTML templating
gem 'slim'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks',
    github: 'rails/turbolinks',
    branch: 'master'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# gem 'actionpack-page_caching'
# gem 'actionpack-action_caching'

group :development do
  # Model schema visualisation
  gem 'rails-erd'

  # For debugging view files in browser
  gem 'xray-rails'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
end

group :development, :test do
  # Code policing with rubocop, a Ruby static code analyzer, based on the community Ruby style guide.
  gem 'rubocop'
  gem 'slim_lint'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Bring in RSpec for testing.
  gem 'rspec'
end

# Spree
gem 'spree',
    github: 'noname00000123/spree',
    branch: '3-0-stable'

# Spree Extensions
# rails g spree_gateway:install
gem 'spree_gateway',
    github: 'noname00000123/spree_gateway',
    branch: '3-0-stable'

# bundle exec rake spree_auth:install:migrations
# bundle exec rake db:migrate
# bundle exec rails g spree:auth:install
# bundle exec rake spree_auth:admin:create
gem 'spree_auth_devise',
    github: 'noname00000123/spree_auth_devise',
    branch: '3-0-stable'

# gem 'spree_mail_settings',
#     github: 'noname00000123/spree_mail_settings',
#     branch: '3-0-stable'

# bundle exec rails g spree_chimpy:install
gem 'spree_chimpy',
    github: 'noname00000123/spree_chimpy',
    branch: '3-stable'

#https://spreecommerce.com/blog/category/developer_resources
# In development
# OAuth integration
# gem 'spree_social',
#     github: 'spree-contrib/spree_social',
#     branch: 'master'

# bundle exec rails g spree_i18n:install
gem 'spree_i18n',
    github: 'noname00000123/spree_i18n',
    branch: '3-0-stable'

# gem 'spree_static_content',
#     github: 'spree-contrib/spree_static_content',
#     branch: '3-0-stable'
#
# https://github.com/spree-contrib/spree-multi-domain
# bundle exec rails g spree_multi_domain:install
gem 'spree_multi_domain',
    # github: 'spree/spree-multi-domain'
    github: 'noname00000123/spree-multi-domain',
    branch: '3-0-stable'

# # https://github.com/sunny2601/spree_admin_roles_and_access/branches
# # bundle install &&
# # bundle exec rails g spree_admin_roles_and_access:install &&
# # bundle exec rake spree_roles:permissions:populate # To populate user and admin roles with their permissions
# # gem 'spree_admin_roles_and_access',
# #     github: 'sunny2601/spree_admin_roles_and_access',
# #     branch: 'reliable'

# https://github.com/spree-contrib/spree_multi_currency/tree/3-0-stable
# bundle && bundle exec rails g spree_multi_currency:install
gem 'spree_multi_currency',
    github: 'noname00000123/spree_multi_currency',
    branch: '3-0-stable'

gem 'google_currency', '3.2.0'

# https://github.com/dickies-co-uk/spree_price_books
# Requires: spree_multi_currency
# Price book functionality for running sales, role based, country based pricing etc...
# bundle exec rails g spree_price_books:install
# And to seed currency rates
# bundle exec rake price_books:currency_rates
gem 'spree_price_books',
    # github: 'spree-contrib/spree_price_books'
    # github: 'noname00000123/spree_price_books'
    github: 'noname00000123/spree_price_books',
    branch: 'integration'

# # https://github.com/spree-contrib/spree_volume_pricing
# # rails generate spree_volume_pricing:install
#
# # $ bundle install
# # $ bundle exec rails g spree_wishlist:install
# # gem 'spree_wishlist',
# #     github: 'spree-contrib/spree_wishlist',
# #     branch: 'master'
# #
# # gem 'spree_email_to_friend',
# #     github: 'spree-contrib/spree_email_to_friend',
# #     branch: 'master'
#
# # https://github.com/traels/spree-promotion-roles-rule
# # Create role specific promotions ie. big spenders rewards, school customers etc.
# # gem 'spree_promotion_roles_rule',
# #    github: 'traels/spree-promotion-roles-rule'
#
# # https://github.com/vinsol/spree-loyalty-points
# # gem 'spree_loyalty_points'
#
# # https://github.com/spree-contrib/spree_reviews
# # bundle
# # bundle exec rails g spree_reviews:install
# # bundle exec rake db:migrate
# # gem 'spree_reviews',
# #     github: 'spree-contrib/spree_reviews',
# #     branch: 'master'

# https://github.com/jdeen/spree_flexi_variants
# bundle exec rails g spree_flexi_variants:install
# gem 'spree_flexi_variants',
#     github: 'jsqu99/spree_flexi_variants'

# # https://github.com/railsdog/spree_braintree_cse
# # bundle
# # bundle exec rails g spree_braintree-cse:install
# # gem 'spree_braintree_cse',
# #     github: 'railsdog/spree_braintree_cse',
# #     branch: 'master'
#
# # https://github.com/spree-contrib/spree_print_invoice
# # bundle && exec rails g spree_print_invoice:install
# # Forked version lifts spree_core version dependency
# gem 'spree_print_invoice',
#     github: 'noname00000123/spree_print_invoice',
#     branch: 'master'
#
# # https://github.com/nebulab/spree-garbage-cleaner
# # Quite old, but may serve as an example to follow
# # gem 'spree_garbage_cleaner',
# #     github: 'nebulab/spree-garbage-cleaner',
# #     branch: '1-2-stable'
#
# # https://github.com/nebulab/spree_simple_reports/tree/master
# # bundle exec rails g spree_simple_reports:install
# # gem 'spree_simple_reports',
# #     github: 'nebulab/spree_simple_reports'
#
# # rails generate spree_pos:install
# # gem 'spree_pos',
# #     github: 'CodeCantor/spree-pos'
# # gem 'spree_html_invoice',
# #     github: 'CodeCantor/spree-html-invoice'
#
# # $ bundle
# # $ bundle exec rails g spree_contact_us:install
# # config/initializers/spree_contact_us.rb modify:
# # config.mailer_to = "contact@please-change-me.com"
# # config.mailer_from = "dontreply@yourdomain.com"
# # gem 'spree_contact_us',
# #     github: 'spree-contrib/spree_contact_us'
#
# # CLI for data import/export
# gem 'datashift', '= 0.16.0'
# gem 'datashift_spree', '= 0.6.0'
#
#