# http://ryanbigg.com/2013/06/finding-sql-queries-in-rails/
# ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
#   if details[:sql] =~ /SELECT  "spree_products"/
#     puts caller.join("\n")
#     puts "*" * 50
#   end
# end
#
# ActiveSupport::Notifications.subscribe('render') do |name, start, finish, id, payload|
#   puts name    # => String, name of the event (such as 'render' from above)
#   puts start   # => Time, when the instrumented block started execution
#   puts finish  # => Time, when the instrumented block ended execution
#   puts id      # => String, unique ID for this notification
#   puts payload # => Hash, the payload
# end