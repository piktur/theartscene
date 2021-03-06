require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Theartscene
  class Application < Rails::Application

    config.assets.precompile += %w( *.jpg spree/backend/jquery.dynatable.css spree/backend/jquery.dynatable.js )

    config.autoload_paths += [ File.join(Rails.root, 'lib', 'spree') ]

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # require 'spree/search/searchkick'

      # Override searcher_class set by spree-multi-domain extension
      #Spree::Search::Elasticsearch or
      Spree::Config.searcher_class = Spree::Core::Search::Searchkick

      # TODO going with searchkick, rely on background tasks instead
      # TODO configure elasticsearch index,
      # unless Elasticsearch::Model.client.indices.exists \
      #   index: Spree::ElasticsearchSettings.index
      #
      #   Elasticsearch::Model.client.indices.create \
      #     index: Spree::ElasticsearchSettings.index,
      #     body: {
      #       settings: {
      #         number_of_shards: 1,
      #         number_of_replicas: 0,
      #         analysis: {
      #           analyzer: {
      #             nGram_analyzer: {
      #               type: 'custom',
      #               filter: ['lowercase', 'asciifolding', 'nGram_filter'],
      #               tokenizer: 'whitespace'
      #             },
      #
      #             whitespace_analyzer: {
      #               type: 'custom',
      #               filter: ['lowercase', 'asciifolding'],
      #               tokenizer: 'whitespace'
      #             }
      #           },
      #           filter: {
      #             nGram_filter: {
      #               max_gram: '20',
      #               min_gram: '3',
      #               type: 'nGram',
      #               token_chars: ['letter', 'digit', 'punctuation', 'symbol']
      #             }
      #           }
      #         }
      #       },
      #       mappings: Spree::Product.mappings.to_hash
      #     }
      # end
    end
    
    # require 'elasticsearch/rails/lograge'
    


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Sydney'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end




