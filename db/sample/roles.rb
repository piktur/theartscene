Spree::Role.where(:name => "admin").first_or_create
Spree::Role.where(:name => "user").first_or_create

Spree::Role.where(:name => "customer_retail").first_or_create
Spree::Role.where(:name => "customer_retail_loyal").first_or_create

Spree::Role.where(:name => "customer_wholesale").first_or_create
Spree::Role.where(:name => "customer_wholesale_reseller").first_or_create
Spree::Role.where(:name => "customer_wholesale_school").first_or_create

Spree::Role.where(:name => "staff_sales_rep").first_or_create
Spree::Role.where(:name => "staff_administrator").first_or_create
Spree::Role.where(:name => "data_analyst").first_or_create
Spree::Role.where(:name => "guest_editor").first_or_create