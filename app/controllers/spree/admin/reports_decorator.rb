# TODO define endpoint per url as per chartkick.com guide
# Make your pages load super fast and stop worrying about timeouts. Give each chart its own endpoint.

module Spree
  module Admin
    ReportsController.class_eval do
      # Potential http://www.elasticsearch.org/2011/05/13/data-visualization-with-elasticsearch-and-protovis/
      # - Data export and schema linkup for accounting
      # - Analytics [Guide](https://spreecommerce.com/blog/ecommerce-tracking-in-spree)
      # - Should this be done within Spree, or externally extracting data via API and styling it for consumption at a seperate domain. There are performance concerns here.
      # - Sales by time period
      # - Stock
      # - Popular products
      # - Abandoned baskets
      # - User Activity: Identify frequent buyers and visitors. For target email campaigns
      # - visitors last n days
      # - % change visitors last n days
      # - Popular Products
      # - Profit/Loss: Profit/Loss report ie. = gross - (cost_price + postage + promotions)
      # - revenue last n days
      # - % change revenue since n days
      # - GST

      def new_users_by_date
        render json: Spree::User.all.group(:created_at).count
      end

      def products_by_category
        render json: Spree::Product.all.group(:price).count
      end
    end
  end
end


# def sales_total
#   params[:q] = {} unless params[:q]
#
#   if params[:q][:completed_at_gt].blank?
#     params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
#   else
#     params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
#   end
#
#   if params[:q] && !params[:q][:completed_at_lt].blank?
#     params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
#   end
#
#   params[:q][:s] ||= "completed_at desc"
#
#   @search = Order.complete.ransack(params[:q])
#   @orders = @search.result
#
#   @totals = {}
#   @orders.each do |order|
#     @totals[order.currency] = { :item_total => ::Money.new(0, order.currency), :adjustment_total => ::Money.new(0, order.currency), :sales_total => ::Money.new(0, order.currency) } unless @totals[order.currency]
#     @totals[order.currency][:item_total] += order.display_item_total.money
#     @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
#     @totals[order.currency][:sales_total] += order.display_total.money
#   end
# end