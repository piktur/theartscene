# The Art Scene - on Spree

# Contents

- [The Art Scene - on Spree](#)
	- [Comparison of Opensource eCommerce Platforms](#)
	- [Why Ruby](#)
		- [Commentaries](#)
	- [Support](#)
	- [Running Costs](#)
		- [Transactional and Marketing Messsaging Service](#)
		- [Hosting](#)
		- [Content Delivery Network(CDN)](#)
	- [Development Costs](#)
- [Development Goals](#)
	- [Understanding Spree](#)
	- [Extending Spree](#)
	- [Managing Multiple Stores](#)
	- [Building and managing Product Inventory](#)
			- [Understanding the Spree::Product model](#)
		- [Data Restructure: Matching the Spree Schema](#)
			- [How?](#)
				- [Using Datashift](#)
				- [Alternatives to Datashift](#)
	- [Customer Interaction and Relations](#)
		- [Authorisation and Authentication](#)
		- [Transaction Messaging and Marketing](#)
		- [Exporting the Customer database](#)
	- [Stock management](#)
	- [Order Fullfillment](#)
		- [Checkout](#)
		- [Shipping](#)
		- [Picking Slips, Mailing Slips and Invoices](#)
		- [Taxation](#)
		- [Promotions](#)
	- [Reports](#)
	- [User Interface](#)
		- [View templates](#)
		- [CSS & JS](#)
		- [Search](#)
			- [Elasticsearch](#)
			- [Solr](#)
	- [Content](#)
		- [Images](#)
		- [Static Pages](#)
	- [Performance](#)
		- [Query Caching](#)
		- [Page Caching](#)
	- [Setup](#)
		- [Requires Ruby 2.2.2](#)
		- [System dependencies](#)
			- [Database](#)
			- [Quality Control](#)
				- [Ruby Style Guide](#)
				- [Documentation: TomDoc](#)
				- [Testing: RSpec](#)
				- [Monitoring](#)
		- [Configuration](#)
		- [Database creation](#)
		- [Database initialization](#)
		- [How to run the test suite](#)
		- [Services (job queues, cache servers, search engines, etc.)](#)
		- [Deployment instructions](#)
		
## Comparison of Opensource eCommerce Platforms
- **Spree**
    - language: Ruby
    - framework: Ruby on Rails (MVC)
- **Magento** 
    - language: PHP 
    - framework: Zend
- **OpenCart** 
    - language: PHP
    - framework: MVC
- **Zen Cart**
    - language: PHP
- **PrestaShop**
    - language: PHP
    - framework: MVC
- **~~bespoke~~**
    - language: Probably PHP
    - framework: could be anything

## What is Spree
Spree is a **full featured** e-commerce platform written for the [**Ruby on Rails**](http://rubyonrails.org/) framework. It is designed to make programming commerce applications easier by making several assumptions about what most developers need to get started. **Spree is a production ready store that can be used “out of the box”, but more importantly, it is also a developer tool that can be used as a solid foundation for a more sophisticated application than what is generally possible with traditional open source offerings**.

**Spree is 100% open source**. It is licensed under the very permissive New BSD License. **You are free to use the software as you see fit, at no charge**. Perhaps more important than the cost, Spree is a true open source community. Spree has hundreds of contributors who have used and improved it while building their own e-commerce solutions.

-- [Source](https://guides.spreecommerce.com/developer/about.html#what-is-spree)


> ### [Spree takes the floor](https://spreecommerce.com/storefront) | [About](https://guides.spreecommerce.com/developer/about.html) | [Demo](https://happy-showroom-9275.spree.mx/admin/orders)

> ### Summary
- Open Source, [license](http://spreecommerce.com/license)
- Highly active development, with over [600 contributors](https://github.com/spree/spree/graphs/contributors)
- Fully extensible
- Lightweight codebase; compare Spree's **~80,000** < Magento's **~8,000,000** lines of code
- No vendor lock-in
- Legacy support; backed by the Ruby on Rails developer community, any Ruby developer can modify the software to meet future requirements.

### Commentaries
- [Reddit: Shopify vs. Magento vs. Spree](https://www.reddit.com/r/ecommerce/comments/2rw8lh/shopify_vs_magento_vs_spree/)

- [The Ultimate eCommerce Platform Guide 2015](https://www.sweettoothrewards.com/blog/ultimate-guide-ecommerce-platforms/)
    *!Note* *Despite claims made [here](https://www.sweettoothrewards.com/wp-content/uploads/Shopping-and-Marketing-tools-chartgrey-divide-updated-12-29-14.png), Spree does support 'Multi Language Storefronts', see [Spree - Internationalization](https://guides.spreecommerce.com/developer/i18n.html) and [Rails Internationalization (I18n) API](http://guides.rubyonrails.org/i18n.html)* 
    
    *And counter to [misinformed claims](https://www.sweettoothrewards.com/wp-content/uploads/Backoffice-and-security-chartgrey-divide-updated-12-29-14.png)* 
    
    *Spree incorporated Bootstrap and is fully responsive as of v3* 
    
    [*Spree incorporates upwards of 50 payment gateways by default, and more via free extensions*](https://spreecommerce.com/blog/spree-payment-gateways) 
    
    [*Writing Custom Reports is easy with Spree*](http://blog.crowdint.com/2015/02/04/creating-a-custom-report-with-spree.html)
    
- [Madtech: Spree vs Magento](https://www.madetech.com/news/spree-vs-magento)


## Why Ruby
Concerned about Ruby, you might have seen [this](http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html). In their own words,

> the TIOBE Programming Community index is an indicator of the popularity of **programming languages**[*ed. emphasis mine*]... The ratings are based on the number of skilled engineers world-wide, courses and third party vendors. *Popular search engines such as Google, Bing, Yahoo!, Wikipedia, Amazon, YouTube and Baidu are used to calculate the ratings*[*ed. emphasis mine*]. **It is important to note that the TIOBE index is not about the best programming language or the language in which most lines of code have been written.** 

But [**Ruby's not going away**](http://githut.info/)

### Who's using Ruby
A selection of companies actively developing with and contributing to Ruby and Ruby on Rails.

- [Shopify](https://www.shopify.com/)
- [Groupon](http://www.groupon.com.au/)
- [Airbnb](https://www.airbnb.com.au/)
- [Basecamp](https://basecamp.com/)
- [Soundcloud](https://soundcloud.com/)
- [Twitter](https://twitter.com/)
- [Bloomberg](http://www.bloomberg.com/)
- [Indiegogo](https://www.indiegogo.com/)
- [Heroku](https://www.heroku.com/)
- [Github](https://github.com/)

____

## Support
> ##### Administrator Resources
- [Official Administrator Documentation](https://guides.spreecommerce.com/user/) 
Note: documentation has not been updated to match new user interface


> ##### Development Resources
- [Official Developer Documentation](https://guides.spreecommerce.com/)
- [Getting Help](https://guides.spreecommerce.com/developer/getting_help.html)
- [Google Group](https://groups.google.com/forum/#!forum/spree-user)
- [Paid Support](https://spreecommerce.com/training_and_support)
- [Affiliates](https://spreecommerce.com/solution_partners)

_# Roadmap
 ## Stages
 ### Now
 1. Prepare basic store for internal testing ~ **six to eight weeks**
     - Required Spree Configuration
         - Store separation 
             - Zones
             - Price Adjustments
                 - WSale, School and Retail
                 - Taxation
                 - Promos
         - Product Properties
         - Product Option Types
     - Prepare majority of current **data** for Spree ingest
     - **Restyle** front and backend views
     - Configure **customer registration**
         - Registration Form
         - ~~Login via social network~~
     - Implement **Payment Gateway** and **Single Page Checkout**
     - Configure **flat Shipping Rates**, **Carriers** and **Options**
     - Configure **User Roles**, priveleges and authorisation etc.
     - Format **order documents**
         - invoices
         - pick slips
         - ~~shipping labels~~
         - ~~shipping manifest~~
     - Format **transactional emails**
 2. Revisions and further testing ~ **two weeks**
 3. Training ~ **one to two weeks**
     - Write documentation 
         - Procedural
             - Admin
             - Clerical
     - Instruct users
 3. Prepare for launch ~ **one to two weeks**
     - Prepare hosting and staging server
     - Prepare static assets, images
     - Prime CDN with prepared static assets
     - Basic Google Analytics configuration
     - Configure transactional email service
 4. Launch
 
 ** Max time to launch: 3.5 months **
 Launch leading into Annual Sale
 Allow adequate time for;
 - real world testing and debugging, 
 - staff development 
 - development of curated marketing material/campaign
 
 ### Post Launch - priority to be determined
 - Write Development Docs
 - Refinement and additional functionality
    - Server and Performance Optimisation
 - Per order **Freight Calculation** and per zone **Carriers**
 - **Marketing**
     - Sponsorship Advertising
     - Social Media
     - Blogging
         - Staff Reccomendations
         - Guest posts
     - User 
         - Comments/Feedback
         - Reviews 
     - **Targeted Email Campaigns**
 - Abandoned Cart followup 
     - Promo code offer
 - Rewrite copy
 - Assess staff and customer feedback
 - Write cutom reports
     ### Report Focus
     - Analytics
     - Sales by time period
     - Profit/Loss: Profit/Loss report ie. = gross - (cost_price + postage + promotions)
         - revenue last n days
         - % change revenue since n days
     - GST
     - Abandoned shopping carts
     - Stock
         - Inventory Levels
         - Popular products
     - User Activity: Identify frequent buyers and visitors. To assist targeted email campaigns
         - visitors last n days
         - % change visitors last n days
 - Data export and schema linkup for accounting

---

## Running Costs

|                                           | Shopify Basic |      | Shopify Professional |      | Shopify Unlimited |       | Spree     |      | Magento |   |   |
|-------------------------------------------|---------------|------|----------------------|------|-------------------|-------|-----------|------|---------|---|---|
| Features                                  | Possible      | Cost | Possible             | Cost | Possible          | Cost  | Possible  | Cost |         |   |   |
| POS                                       | Yes           |      | Yes                  |      | Yes               |       | No        |      |         |   |   |
| 1 GB file storage                         | Yes           |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| Unlimited products                        | Yes           |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| 24/7 Support                              | Yes           |      | Yes                  |      | Yes               |       | No        |      |         |   |   |
| Discount code engine                      | Yes           |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| 2.0% Transaction fee                      | Yes           |      | Yes                  |      | Yes               |       | No        |      |         |   |   |
| Fraud analysis tools                      | No            |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| Gift cards                                | No            |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| Professional reports                      | No            |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| Abandoned cart recovery                   | No            |      | Yes                  |      | Yes               |       | Yes       |      |         |   |   |
| Advanced report builder                   | No            |      | No                   |      | Yes               |       | Yes       |      |         |   |   |
| Real-time carrier shipping                | No            |      | No                   |      | Yes               |       | No        |      |         |   |   |
| Host                                      | Yes           |      | Yes                  |      | Yes               |       | Ninefold  | 50   |         |   |   |
| Content Delivery Network                  | Yes           |      | Yes                  |      | Yes               |       | AWS       |      |         |   |   |
| Transactional and Marketing Email Service | Yes           |      | Yes                  |      | Yes               |       | Mailchimp | 33   |         |   |   |
| Custom Code Modification                  | No            |      | No                   |      | No                |       | Yes       |      |         |   |   |
| Vendor Lockin                             | Yes           |      | Yes                  |      | Yes               |       | No        |      |         |   |   |
| **Minimum Expense per Month**             |               |**29**|                      |**79**|                   |**179**|           |**83**|         |   |   |

[Source](/home/user/Documents/webdev/future_projects/theartscene/demonstrations/expenses/MonthlyCost.csv)

### Transactional and Marketing Messsaging Service
- [**MailChimp**](http://mailchimp.com/) & [**Mandrill**](https://www.mandrill.com/)
- Integration with [Spree Chimpy - Extension](https://github.com/DynamoMTL/spree_chimpy)

#### Campaign Tracking
Track campaign success with [MailChimp eCommerce360](http://kb.mailchimp.com/integrations/other-integrations/about-ecommerce360)

#### Alternatives?

### Hosting
- [**Ninefold**](https://ninefold.com/pricing/)

Commentary and Dev resources.

- [1](http://www.besthosting.org/5-best-hosting-for-spree-commerce-2/)
- [2](https://ninefold.com/pricing/)
- [3](https://ninefold.com/blog/categories/spree/)
- [4](https://ninefold.com/blog/2014/05/28/the-right-e-commerce-tools-for-the-job/)
- [5](https://ninefold.com/blog/2014/07/29/art-to-aid-shopify-to-spree-vps-to-ninefold-its-all-about-satisfaction/)
- [6](https://ninefold.com/blog/2014/03/21/talking_spree_testing_and_performance_on_ninefold/)
- [7](https://ninefold.com/blog/2014/05/15/spree-commerce-and-ninefold-meetup-recap/)
- [8](http://blog.benmorgan.io/post/95144946546/getting-started-with-spree-wombat-and-ninefold)

Alternatives?

### Content Delivery Network(CDN)
- [**Amazon S3**](http://aws.amazon.com/s3/)

Alternatives?

## Development Costs
TODO

---

# Development Goals

## Understanding Spree

### Data Structure
![Spree Schema Visualisation](https://github.com/noname00000123/theartscene/blob/master/spree_schema_visualisation.jpg)
-- Visualisation generated with [Rails ERD](http://voormedia.github.io/rails-erd/)

#### Orders

#### Taxation
Applicable taxes are determined by Shipping Address, an instance of Spree::Address which belongs to an instance of Spree::State and/or Spree::Country. GST is applied automatically when shipping within Australia, and excluded from Orders shipped internationally.

Order has_one Tax Zone

## Extending Spree
Extensions https://spreecommerce.com/blog/category/developer_resources

## Managing Multiple Stores
https://github.com/spree-contrib/spree-multi-domain

## Building and managing Product Inventory
> **Will Spree adequately describe and merchandise the Art Scene inventory?** 

There is a wide variance of products within the Art Scene inventory. A frame may be described as having a mold, glazing, matting and dimensions appropriate to each of these variant properties. A tube of paint is relatively simple, having colour, volume, branding etc. How does the Spree accommodate these *variants*?

#### Understanding the Spree::Product model
Products represent an entity for sale in a Store, [described here](https://github.com/spree/spree/blob/master/core/app/models/spree/product.rb)
Products variations are defined as **Spree::Variants**

[Spree::Product](./db/schema.rb:437) properties include. These properties are applicable to all Variants of a Product.

```ruby

    t.string   "name",                 default: "",   null: false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "slug"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "promotionable",        default: true
    t.string   "meta_title"

```
    
[Spree::Variant](./db/schema.rb:1047) properties include.

```ruby

    t.string   "sku",                                        default: "",    null: false
    t.decimal  "weight",            precision: 8,  scale: 2, default: 0.0
    t.decimal  "height",            precision: 8,  scale: 2
    t.decimal  "width",             precision: 8,  scale: 2
    t.decimal  "depth",             precision: 8,  scale: 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                  default: false
    t.integer  "product_id"
    t.decimal  "cost_price",        precision: 10, scale: 2
    t.integer  "position"
    t.string   "cost_currency"
    t.boolean  "track_inventory",                            default: true
    t.integer  "tax_category_id"
    t.datetime "updated_at"
    t.integer  "stock_items_count",                          default: 0,     null: false
    
``` 

- Every product has one **master variant**, price, SKU, and size and dimensions are all delegated to the master variant.
- The master variant does not have option values associated with it.
- Contains on_hand inventory levels only when there are no variants for the product.
- All variants can access the product properties directly (via reverse delegation).
- Inventory units are tied to Variant.
- The master variant can have inventory units, but not option values.
- All other variants have option values and may have inventory units.
- Sum of on_hand each variant's inventory level determine "on_hand" level for the product.

____

### Data Restructure: Matching the Spree Schema
> How do we populate the Spree database with the Art Scene's existing inventory data

#### How? 
> Out of the box **administrators** are able to *create*, *edit* and *delete* single products via the admin interface. Great... for the first 10 SKUs... the remaining 29,990 be damned. **Give me a batch job please!**

At present, the dataset is maintained and stored in a Spreadsheet and made portable via CSV. 

> How to transform the current data structure so that it gels with the Spree schema?

- **Manually edit column headers** 

    **Issue:** Admin may want to preserve current format. Why? Perhaps other database rely on the current schema.
    
    **Solutions:**
    - splinter a second spreadsheet to match the Spree schema
    - transform column headers on import
    
> Queue [**Datashift**](https://github.com/autotelik/datashift). Datashift provides **import/export** facilities to shift data between [ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html) databases/applications and Spreadsheets/CSV

##### Using Datashift
Ensure *.thor file exists in root directory.

~~~ruby
require 'datashift'
require 'datashift_spree'

DataShift::load_commands
# 6/7/15 As per [commit 3885e370092c3ef5c11f1740da69233820b2d3d9](https://github.com/autotelik/datashift_spree/blob/master/README.markdown) 
# Class is now SpreeEcom, not SpreeHelper
DataShift::SpreeEcom::load_commands
~~~

The datashift extension includes a number of spreadsheets to match the Spree schema. To generate a template execute this command from the terminal ~~~ bundle exec thor datashift:generate:excel -m <model> -r <file>.xls --remove-rails ~~~

For combined Spree::Product and Spree::Variant schemas
~~~
bundle exec thor datashift:generate:excel -m Spree::Product -r spree_product_template.xls -a --remove-rails
~~~

> Ensure CSV data is properly delimited for import
**Field delimiter:**    ',' 
**Text delimiter:**     '"'

> NOTE: bundler install didn't get the latest version from git. Brought down 0.5.0 rather than 0.6.0. Dependency mismatched. Breaking change. [See git issue](https://github.com/bundler/bundler/issues/2204) 6/7/15 3AM Successful migration

```

    CODE
    LONG DESCRIPTION
    Product Tags
    BRAND
    GROUP NAME
    PRODUCT CATEGORY
    PRODUCT TITLE
    DETAILS
    DELETED ITEM ICON
    AUTHOR
    N
    TYPE
    COLOUR
    SERIES
    TEXTURE
    VOLUME
    VOLUME 1
    WEIGHT
    WEIGHT 1
    SIZE
    DIMENSION
    THICKNESS
    DIMENSION 1
    THICKNESS 1
    MAIN IMAGE
    ADDITIONAL IMAGES
    COLOUR CHART
    CMYK COLOUR
    INDIVIDUAL COLOUR RGB
    LOGO
    MERGED DESCRIPTION
    SLIDE DESCRIPTION
    ISBN
    UNIT
    SINGLE WSALE
    PACK WSALE
    SINGLE WS$
    UNIT PRICE
    IN A PACK W$
    DISCOUNT CODE
    WSALE
    SINGLE SCHOOL
    PACK SCHOOL
    SINGLE S$
    UNIT PRICE IN A PACK S$
    DISCOUNT CODE SCH
    SINGLE RETAIL 
    PACK RETAIL
    SINGLE AS $
    UNIT PRICE IN A PACK AS$
    DISCOUNT CODE AS
    RRP$
    SAVE % OFF RECOMMENDED RETAIL
    MSDS ICON
    PRODUCT INFORMATION/FLYERS ICON
    SHIPPING INFORMATION ICON
    ACID FREE
    AUSTRALIAN MADE ICON
    "Catalogue Page Number"
    Group Code
    Swatch font colour
    ENABLED
    bulky freight
    COLOURCHART NAME FOR SWATCHES
    ENABLED FOR WHICH SITE
    Prices are for a single item but must buy in packs
    
    
    Unique properties per product type
    Adjustments per store
    
    Store Codes
    Australian Art Supplies = AAS = Spree::Store[:id]
    Art Scene               = AS  = Spree::Store[:id] 
    Art Basics Wholesale    = WS  = Spree::Store[:id]
    Art Basics School       = SC  = Spree::Store[:id]
    
    Normalised **Product Properties** 
    
        t.string    "manufacturer"
        t.string    "brand"
        
        # Replaces 
        # BD AUSTRALIAN MADE ICON
        # :country_of_origin == AU ? span.icon.icon-country-au : nil
        # Display flag for each country of origin
        t.string    "country_of_origin"
        # Replaces
        # BK ENABLED FOR WHICH SITE
        # configure belongs_to relationship
        t.integer   "store"             default: "AS"
        t.integer   "rrp"
        t.integer   "cost_price"
        r.integer   "pack_qty"          
        r.integer   "pack_discount"     default: 0.1
        # Replaces
        # E GROUP NAME
        r.string    "group_code"
    
    
    acrylic_ink
    
    # Acrylic Mediums
    acrlic_medium
    
    # Acrylic Paint Sets
    
    # Acrylic Painting
    
    # Acrylic Paints
    acrylic_paint
    
    
    # Archival And Conservation Tapes
    
    # Block Printing
        
    book
        - title
        - isbn
        - author
        - publisher
        - editor
        - pages
        - edition
        - in_print
        
    # Carry Cases And Accessories
    
    container
    
    # Charcoal Pencils
    
    # Coloured Pencils
    
    # Compressors
    
    # Design And Illustration Markers
    
    # Drawing And Pastel Paper
    
    # Fabric Markers
    
    # Face & Body Paints
    
    # Fixative Sprays
    
    # General Purpose Scissors
    
    # Gouache Paints
    
    # Hog Bristle Brushes
    
    # Inks
    
    # Masking Film
    
    # Matboards
    
    # Modelling Clay
    
    # Multi Purpose
    
    paint
        - colour
        - binder
        - volume
        - series
        - pigments
    
    # Oil Paints
    
    # Palette Knives
    palette_knife
    
    paper
        - width
        - height
        - weight
        - texture
        - acid_free
        - fibre
        
    # Pigments
    pigment
    
    # Presentation Portfolios And Display Folders
    folder
    
    container
    
    # Soft Pastels
    
    soft_pastel
    
    oil_pastel
        - shade
        - colour
    
    # Spray Adhesives
    
    spray_adhesive
    
    # Stretched Canvas
    
    stretched_canvas
        t.string     "fabric"    
        t.integer    "width"     scale: 2, default: 0.0
        t.integer    "height"    scale: 2, default: 0.0
        t.integer    "depth"     scale: 2, default: 0.0
        t.integer    "weight"    scale: 2, default: 0.0
        t.boolean    "primed"      
    
    # Tape Dispensers
    
    # Tracing And Detail Paper
    
    video
        - discs
        - duration
        - format
        - region
        
    # Watercolour Mediums
    
    # Watercolour Mediums - Schmincke
    # WTF
    
    # Watercolour Pads
    watercolour_pad
    
    # Watercolour Paint Sets
    
    
    # Watercolour Paints
    
    sets
        - includes
```

##### Using Spree's REST API

###### Making an API call
Spree Administrators are granted an API Key, it is stored [here](/admin/users/[Spree::User[:id]]/edit)
Calls to the API are formed as per below example. Replace "ADMINISTRATOR_API_KEY" with your key.

~~~curl
$ curl --header "X-Spree-Token: ADMINSTRATOR_API_KEY" http://example.com/api/products.json
~~~

Or, pass token to URI query parameter

~~~curl
$ curl http://example.com/api/products.json?token=YOUR_KEY_HERE
~~~

May prove be a more elegant solution than 'datashift_spree' extension.

[Darwin](https://github.com/darwin/csv2json) converts csv to json. With appropriately formed spreadsheet, generate JSON and upload via API.
or Node.js [csvtojson](https://github.com/Keyang/node-csvtojson)

> Issue: We risk invalid data uploads without datashift_spree's inbuilt data validation.

##### Alternatives to Datashift
Write CLI to communicate with Spree's [**REST API**](https://guides.spreecommerce.com/api/)

- [API Documentation: Products (official)](https://guides.spreecommerce.com/api/products.html)
- [Usage examples](https://github.com/radar/spree_api_examples/blob/b962e0bf4eda71bc0dde50b0328b04af6feceb66/examples/images/product_image_creation.rb)
- [More examples](https://gist.github.com/jcowhigjr/4021246)

____

**Alternate extensions** seem inactive, last Git commits go back years, presuming they're redundant or restricted to earlier versions of Spree. **Have not tested**.

- [Spree Importer](https://github.com/ginlane/spree_importer)
- [Spree Editor](https://github.com/spree-contrib/spree_editor)
    

## Customer Interaction and Relations

### Authorisation and Authentication
[Login with Social account](https://github.com/spree-contrib/spree_social)

### Transaction Messaging and Marketing
[Communicate with MailChimp](https://github.com/DynamoMTL/spree_chimpy)

### Exporting the Customer database
TODO: Write **export as CSV** task. For transport to Retail POS, Attache etc

## Stock management

____

## Order Fullfillment

### Checkout
https://github.com/spree-contrib/spree_volume_pricing
https://github.com/spree-contrib/spree_comments
https://github.com/spree-contrib/spree_wishlist
https://github.com/spree-contrib/better_spree_paypal_express
https://github.com/mespina/spree_one_page_checkout_bootstrap_frontend

> #### Security
[Official Security Documentation](https://guides.spreecommerce.com/developer/security.html)

Either of these to minimise PCI DSS Compliance requirements
[Braintree on PCI DSS Compliance](https://articles.braintreepayments.com/reference/security/pci-compliance)
[Braintree](https://www.braintreepayments.com/) 
[Stripe](https://stripe.com/au)

### Shipping

### Picking Slips, Mailing Slips and Invoices
https://github.com/spree-contrib/spree_print_invoice

### Taxation

### Promotions
https://github.com/huoxito/spree-line_item_discount

## Reports
- Analytics [Guide](https://spreecommerce.com/blog/ecommerce-tracking-in-spree)
- Should this be done within Spree, or externally extracting data via API and styling it for consumption at a seperate domain. There are performance concerns here.
- Sales by time period
- Stock
- Popular products
- Abandoned baskets
- User Activity: Identify frequent buyers and visitors. For target email campaigns
    - visitors last n days
    - % change visitors last n days
- Popular Products
- Profit/Loss: Profit/Loss report ie. = gross - (cost_price + postage + promotions)
    - revenue last n days
    - % change revenue since n days
- GST
[Example ActiveRecord query](https://groups.google.com/forum/#!topic/spree-user/55nMqUJDchU)
```ruby
Adjustment.tax.where(
    “created_at => :start_date AND created_at <= :end_date, start_date: start_date, end_date: end_date)
    .includes(:order)
    .where(spree_orders: {state: 'complete'}
)
.sum(:amount)
```
    
_____

## User Interface
### View templates
Slim for interpolated HTML templates
Have converted existing view files to slim

### CSS & JS
TODO restructure and style front/backend views with
- Angular + Bootstrap: [Sprangular](https://github.com/sprangular/sprangular/wiki/setup-guide)
- Turbolinks + Bootstrap

### Search
####  Elasticsearch
https://github.com/javereec/spree_elasticsearch

#### Solr
https://github.com/jbrien/spree_sunspot_search
http://jacopretorius.net/2013/10/integrating-solr-search-with-spree.html

____

## Content
### Images
Spree uses Paperclip and ImageMagick by default. [libvips](https://github.com/jcupitt/libvips), raw or via [lovell/sharp](https://github.com/lovell/sharp) and Node.js is way faster.
[Example custom Paperclip Processor](http://stackoverflow.com/questions/28293289/how-to-create-custom-paperclip-processor-to-retrive-image-dimensions-rails-4)

### Static Pages
- About Page
- Contact Page
- Legal 
    Terms
    Privacy
    Generate with [iubenda](http://www.iubenda.com/en)
- FAQ

Solution: Middleman? or Markdown or [Extension](https://github.com/spree-contrib/spree_static_content)

______

## Performance
Basecamp as a benchmark for speed in the Rails world, see [How Basecamp got to be so damn fast...](https://signalvnoise.com/posts/3112-how-basecamp-next-got-to-be-so-damn-fast-without-using-much-client-side-ui)

### Query Caching

### Page Caching

Varnish

____

## Setup

### Requires Ruby 2.2.2

### System dependencies
#### Database
Currently SQLite, will move to MySQL closer to launch

- MySQL
- Postgres
- SQLite

#### Quality Control
#####[Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
##### Documentation: [TomDoc](http://tomdoc.org/)

- Attach quality checks to Git Commits with [Overcommit](https://github.com/brigade/overcommit)
- [Rubocop](https://github.com/bbatsov/rubocop)
- [Slim Lint](https://github.com/sds/slim-lint)

##### Testing: [RSpec]()

##### Monitoring
NewRelic 

> ##### Example
  ~~~ruby
  # Public: Duplicate some text an arbitrary number of times.
  #
  # text  - The String to be duplicated.
  # count - The Integer number of times to duplicate the text.
  #
  # Examples
  #
  #   multiplex('Tom', 4)
  #   # => 'TomTomTomTom'
  #
  # Returns the duplicated String.
  def multiplex(text, count)
    text * count
  end
  ~~~

### Configuration

### Database creation

### Database initialization

### How to run the test suite

### Services (job queues, cache servers, search engines, etc.)

### Deployment instructions

#### Seed Demo Data
https://guides.spreecommerce.com/developer/navigating.html#layout-and-structure
```

    # If data irrelevant or comprimised in any way, clear it
    rake db:drop:migrate:seed
    
    # Load sample data
    bundle exec rake spree_sample:load
```
#### Integrating Extensions
1. Fork the required repo
2. Clone to your dev computer ```git clone -b 3-0-stable https://github.com/noname00000123/spree-extension.git```
3. ```cd``` into clone root
3. Add upstream remote ```git remote upstream https://github.com/source/spree-extension-source.git```
4. https://help.github.com/articles/syncing-a-fork/
#### Setup a testing environment

##### Integration and Unit testing project

```rspec --init``` to set up RSpec


require 'spree_price_books/factories'

##### Spree Unit testing

```

    # Clone latest stable branch from forked spree repos
    $ git clone -b 3-0-stable git://github.com/noname00000123/spree.git
    $ git clone -b 3-0-stable https://github.com/noname00000123/spree_i18n.git
    $ git clone -b 3-0-stable https://github.com/noname00000123/spree_auth_devise.git
    $ git clone -b 3-0-stable https://github.com/noname00000123/spree_gateway.git
    $ git clone -b 3-0-stable https://github.com/noname00000123/spree_price_books.git
    $ git clone -b 3-0-stable https://github.com/noname00000123/spree_multi_currency.git
    $ git clone -b 3-0-stable https://github.com/noname00000123/spree-multi-domain.git
    $ git clone -b 3-stable https://github.com/noname00000123/spree_chimpy.git

    # Descend into repo dir
    $ cd spree
    $ bundle install
    
    # To build test suite for spree components
    # Run the following command from within the component
    $ cd core
    $ bundle exec rake test_app
    
    $ cd frontend
    $ bundle install
    $ bundle exec rake test_app
    
    $ cd backend
    $ bundle install
    $ bundle exec rake test_app
    
    # Build a sandbox app
    $ bundle exec rake sandbox
    
```

#### Create a new app

``` 

    # Install postgres
    sudo apt-get install postgresql postgresql-contrib libpq-dev 
    # Create postgres user
    sudo -u postgres createuser -s theartscene
    # Initialize postgres
    sudo -u postgres psql
    # Enter su password
    # [server password]
    # Define password for user
    \password theartscene
    # enter password
    # verify password
    \quit
    
    # gem install rails -v 4.2.2
    # or use official rails Dockerfile
    gem install spree
    rails _4.2.2_ new theartscene
    spree install theartscene --branch '3-0-stable'
    # enter admin username
    admin@artscene.com.au
    # enter admin password
    [password]
    
    # To add to existing rails application
    bundle install
    rails g spree:install --migrate=false --sample=false --seed=false
    # bundle exec rake railties:install:migrations
    # bundle exec rake db:migrate
    # bundle exec rake db:seed
    # Load sample data 
    # bundle exec rake spree_sample:load
    
    # Run dependency tasks
    bundle exec rake spree_auth:install:migrations
    bundle exec rake db:migrate
    bundle exec rails g spree:auth:install
    bundle exec rake spree_auth:admin:create
    bundle exec rails g spree_i18n:install
    bundle exec rails g spree_multi_domain:install
    bundle exec rails g spree_multi_currency:install
    bundle exec rails g spree_price_books:install
    bundle exec rake price_books:currency_rates
    
    # Generate a test app
    DB=theartscene_development bundle exec rake test_app

```

```

    # Dockerfile
    # https://registry.hub.docker.com/_/rails/
    
    # Select ubuntu as the base image
    FROM ubuntu
    
    # Install nginx, nodejs and curl
    RUN apt-get update -q
    RUN apt-get install -qy nginx
    RUN apt-get install -qy curl
    RUN apt-get install -qy nodejs
    RUN echo "daemon off;" >> /etc/nginx/nginx.conf
    
    # Install rvm, ruby, bundler
    RUN curl -sSL https://get.rvm.io | bash -s stable
    RUN /bin/bash -l -c "rvm requirements"
    RUN /bin/bash -l -c "rvm install 2.1.0"
    RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
    
    # Add configuration files in repository to filesystem
    ADD config/container/nginx-sites.conf /etc/nginx/sites-enabled/default
    ADD config/container/start-server.sh /usr/bin/start-server
    RUN chmod +x /usr/bin/start-server
    
    # Add rails project to project directory
    ADD ./ /rails
    
    # set WORKDIR
    WORKDIR /rails
    
    # bundle install
    RUN /bin/bash -l -c "bundle install"
    
    # Publish port 80
    EXPOSE 80
    
    # Startup commands
    ENTRYPOINT /usr/bin/start-server

```



# Running Changes
Overriden stylesheets
componentised stylesheets in vendor/stylesheets/spree/frontend/components
included in all.css
Activated turbolinks js by inclusion in vendor/javascripts/spree/frontend/all.js
included footer
overode home controller
overode store controller and added instance variables from home controller
adding static pages via spree_static_content is as easy as hahaha
http://blog.crowdint.com/2014/12/02/the-minimalist-guide-to-spree-static-content.html?utm_source=blogpost&utm_medium=twitter&utm_campaign=spreestatic-1202
setting route
create controller
create view

Docker for portability
Hav purchased  dev server at ninefold
would like to create a docker container for portability between servers
http://docs.docker.com/linux/step_one/
sudo start docker 
to test docker active sudo docker run hello-world

javascript manifest - have removed line // require_tree .
in
vendor/assets/javascripts/spree/backend/all.js
vendor/assets/javascripts/spree/backend.js

----
> 24 July 2015

Have created a new base app, and corrected versions for spree_core, dependency and extensions 
Have forked extensions of interest
Created an environment for **unit testing**
Will need to develop integration tests

Aiming to create reliable seed data for demonstration

Demonstration to feature typical flow from user registration to order fulfillment. 
Still TODO 
Configure key extensions
- Authentication: Devise
- Transactional Mail: Mandrill & Mailchimp
Demonstrate multi domain capability
- Order segregation
- Unique Styling per domain
- Pricebook
- Promotions

# Deployment Guide 
See the official Ubuntu deployment guide [here](https://guides.spreecommerce.com/developer/manual-ubuntu.html)

# Multi-Domain
Spree is allows multi-store management from a single backend via the [spree-multi-domain](https://github.com/spree-contrib/spree-multi-domain) extension. 

Add gem to Gemfile

```
gem 'spree_multi_domain',
    git: 'git://github.com/spree/spree-multi-domain.git'
```

then

``` $ bundle exec rails g spree_multi_domain:install ```

Each storefront is accessible at its own unique domain.

## DNS configuration
[Prax](https://github.com/ysbaddaden/prax) is a pure ruby alternative to Pow!! that runs on GNU/Linux. Rack proxy server for development Local Development.

### Install

```
$ sudo git clone git://github.com/ysbaddaden/prax.git /opt/prax
$ cd /opt/prax/
$ ./bin/prax install
```

```
$ cd ~/.prax
$ ln -s ~/Work/myapp .
$ firefox http://myapp.dev
```

We're then able to define separate domains per unique storefront. 
In our case, when we've started the local app server with ```foreman start``` we can visit each of these storefronts with domain names defined in our Spree *Store & Domains* configuration.
- [The Art Scene: as.dev:3000](as.dev:3000)
- [Art Basics: ab.dev:3000](ab.dev:3000)
- [Australian Art Supplies: aas.dev:3000](aas.dev:3000)

Each of the store fronts is namespaced and maintained separately in app/views/spree/[namespace]

Global or shared view files are available at app/views/spree/global

# Authorisation, Permissions and User Roles
https://github.com/spree/spree_auth_devise

# Pricing
google_currency throws NoMethod error ```synchronize``` when version other than 3.2.0. This dependency sets spree_core money dependency back to 6.5.0. But doing so permits database seed
```
    # https://github.com/spree-contrib/spree_multi_currency/tree/3-0-stable
    # bundle && bundle exec rails g spree_multi_currency:install
    gem 'spree_multi_currency',
        github: 'spree-contrib/spree_multi_currency',
        branch: '3-0-stable'
        
    gem 'google_currency', '3.2.0'
    
    # Requires: spree_multi_currency
    # Price book functionality for running sales, role based, country based pricing etc...
    # bundle exec rails g spree_price_books:install
    gem 'spree_price_books',
        # github: 'noname00000123/spree_price_books'
        github: 'dickies-co-uk/spree_price_books',
        branch: '3-0-stable'
```

# Payments
https://github.com/railsdog/spree_braintree_cse
```gem 'spree_braintree-cse'```
https://www.braintreepayments.com/blog/client-side-encryption/

https://github.com/deseretbook/spree_sale_pricing

# Documents: Invoices, Picking Slips and Shipping Labels
```
# https://github.com/spree-contrib/spree_print_invoice
# bundle && exec rails g spree_print_invoice:install
# Forked version lifts spree_core version dependency
gem 'spree_print_invoice',
    github: 'noname00000123/spree_print_invoice',
    branch: 'master'
```    
## Configuration
```
config/initializers/spree.rb
# Readme outdated, proper configuration below
Spree::PrintInvoice::Config.set(
    page_layout: :portrait,
    page_size: 'A4',
)
Spree::PrintInvoice::Config.set(logo_path: '/path/to/public/images/company-logo.png')
Spree::PrintInvoice::Config.set(store_pdf: true)
Spree::PrintInvoice::Config.set(storage_path: 'documents/invoices')
# Spree::PrintInvoice::Config.set(next_number: [1|'your current next invoice number'])
```

# Shipping
https://github.com/railsdog/spree_shipping_labels

### Integrating with Mandrill Transactional and MailChimp Campaign Services
Spree 3 extracted spree_mail_settings in fav our of default Rails ActionMailer.
TODO confirgure ActionMailer for Devise transactional emails Mandrill SMTP and MailChimp Campaigns. 

- [**MailChimp**](http://mailchimp.com/) & [**Mandrill**](https://www.mandrill.com/)
- Integration with [Spree Chimpy - Extension](https://github.com/DynamoMTL/spree_chimpy)

Track campaign success with [MailChimp eCommerce360](http://kb.mailchimp.com/integrations/other-integrations/about-ecommerce360)

  