require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/static_assets'
require 'sinatra/url_for'
require 'data_kitten'

class HatTipApp < Sinatra::Base

    helpers do
        include Sinatra::ContentFor
        register Sinatra::StaticAssets
        register Sinatra::Partial
    end

    configure do |app|
        set :static, true
        set :views, File.dirname(__FILE__) + "/../site/views"
        set :public_dir, File.dirname(__FILE__) + "/../site/public"
        set :partial_template_engine, :erb
        def can_build_attribution?(data)
            return true if data[:attribution_text] || data[:publisher_name] || data[:title]
            return false
        end
        def found_metadata?(data)
            puts data.inspect
            return data != nil && data["_source"] != nil
        end
        def attribution_url(data)
            return data[:attribution_url] if data[:attribution_url]
            return data[:publisher_home] if data[:publisher_home]
            return data[:dataset_home] if data[:dataset_home]
            return data[:access_url]
        end
    end

    get "/" do
        begin
            if params[:url]
                @attribution_data = lookup(params[:url])
            end
        rescue => e
            @error = e
        end
        erb :index
    end

    #Attempt to find metadata for the dataset
    #Start with DataKitten and then fallback to some custom code
    #Possible to remove this once PRs are added to Data Kitten
    def lookup(access_url)
        attribution_data = {
            :access_url => access_url
        }

        dataset = DataKitten::Dataset.new(:access_url => access_url)
        if dataset.supported?
            attribution_data["_source" ] = :data_kitten
            attribution_data[ :dataset_home ] = access_url
            attribution_data[ :title ] = dataset.data_title
            attribution_data[ :issued ] = dataset.issued
            attribution_data[ :modified ] = dataset.modified
            if dataset.rights
                attribution_data[ :attribution_url ] = dataset.rights.attribution_url
                attribution_data[ :attribution_text ] = dataset.rights.attribution_text
            end
            if dataset.publishers && dataset.publishers.length > 0
                attribution_data[ :publisher_name ] = dataset.publishers.first.name
                attribution_data[ :publisher_url ] = dataset.publishers.first.homepage
            end
        else
            return fallback_lookup(attribution_data)
        end

        return attribution_data
    end

    def fallback_lookup(attribution_data)
        if attribution_data[ :access_url ] =~ /dx.doi.org/
            dataset = DOIDataset.new(attribution_data[:access_url])
            attribution_data[ "_source" ] = :doi if dataset.supported?

        else
            dataset = Datasetnew(attribution_data[ :access_url ])
            attribution_data[ "_source" ] = :built_in if dataset.supported?
        end

        attribution_data[ :dataset_home ] = dataset.dataset_home
        attribution_data[ :title ] = dataset.title
        attribution_data[ :publisher_name ] = dataset.publisher_name
        attribution_data[ :publisher_url ] = dataset.publisher_home
        attribution_data[ :attribution_url ] = dataset.attribution_url
        attribution_data[ :attribution_text ] = dataset.attribution_text
        attribution_data[ :issued ] = dataset.issued
        attribution_data[ :modified ] = dataset.modified

        attribution_data
    end

    #Debugging tool, dump metadata as JSON
    get "/data" do
        attribution_data = lookup( params[:url] )
        content_type :json
        attribution_data.to_json
    end

end