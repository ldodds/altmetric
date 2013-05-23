require 'json'
require 'httpclient'
require 'uri_template'

module Altmetric
  
  class Client
    
    DEFAULT_USER_AGENT = "altmetric-ruby-client/0.0.1"
    URI_TEMPLATE = URITemplate.new("http://{host}/{version}{/path*}")
    
    HOST = "api.altmetric.com"
    VERSION = "v1"
    KEY_PARAM="key"
    
    HOURLY_RATE_LIMIT="X-HourlyRateLimit-Limit"
    DAILY_RATE_LIMIT="X-DailyRateLimit-Limit"    
    HOURLY_RATE_LIMIT_REMAINING="X-HourlyRateLimit-Remaining"
    DAILY_RATE_LIMIT_REMAINING="X-DailyRateLimit-Remaining"
    
    RATE_HEADERS = [HOURLY_RATE_LIMIT, DAILY_RATE_LIMIT, HOURLY_RATE_LIMIT_REMAINING, DAILY_RATE_LIMIT_REMAINING]
    
    LIMITS = {}
    
    #Format a URL according to provided template
    #
    #Automatically injects the correct :host and :version params for
    #the API
    #
    #template:: a valid URI template
    #opts:: additional template params, should include :path 
    def self.make_url(template, opts)
      return template.expand( 
          { :host => HOST, 
            :version => VERSION
          }.merge(opts) 
          )
    end
    
    #Update class variable with latest rate limit data
    #
    #headers:: hash of response headers
    def self.update_limits(headers)
      RATE_HEADERS.each do |header|
        LIMITS[header] = headers[header].to_i if headers[header]
      end
    end
    
    #Create a new client object
    #
    #Supports several options in the provided hash, including:
    #
    #[apikey]:: specify altmetric API key, only required for +fetch+ method and increased rate limits
    #[client]:: specify a pre-created HTTPClient object (e.g. for mocking during testing)
    #[user_agent]]:: specify a user agent. Default is +DEFAULT_USER_AGENT+ 
    # 
    #Method params:
    #
    #opts:: options for configuring client
    def initialize(opts={})
      name = opts[:user_agent] || DEFAULT_USER_AGENT
      @client = opts[:client] || HTTPClient.new( :agent_name => name )
      @apikey = opts[:apikey] || nil                    
      @opts = opts
    end
        
    #Fetch altmetrics for a DOI
    def doi(id, &block)
      return get_metrics(["doi", id], &block)
    end

    #Fetch citations for a DOI    
    #    
    #Read the {API documentation}[http://api.altmetric.com/docs/call_citations.html] for explanation of parameters
    def citations(timeframe, params, &block)
      return get_metrics(["citations", timeframe], params, &block)
    end
    
    #Fetch altmetrics using (unstable) altmetrics ids    
    def id(id, &block)
      return get_metrics(["id", id], &block)
    end
    
    #Fetch altmetrics for a Pubmed identifier    
    def pmid(id, &block)
      return get_metrics(["pmid", id], &block)
    end
    
    #Fetch altmetrics for Arxiv id    
    def arxiv(id, &block)
      return get_metrics(["arxiv", id], &block)
    end
    
    #Fetch altmetrics for ADS bibcode    
    def ads(id, &block)
      return get_metrics(["ads", id], &block)
    end
    
    def fetch(type, id, params)
      return get_metrics(["fetch", type, id], params, &block)
    end

    #Get metrics, specifying path, query parameters, and headers
    #
    #Accepts a block for direct processing of the result, otherwise
    #response is validated to ensure its a success then parsed as JSON    
    def get_metrics(path, query={}, headers={})
      url = Client::make_url(URI_TEMPLATE, {:path=>path} )
      response = get( url, query, headers )
      if block_given?
        yield response
      end
      validate_response(response)      
      return JSON.parse( response.content )      
    end
    
    def get(uri, query={}, headers={})
      query[KEY_PARAM] = @apikey if @apikey
      headers["Accept"] = "application/json"
      response = @client.get(uri, query, headers)
      Client.update_limits(response.headers) 
      return response
    end
        
    def validate_response(response)
      if response.status != 200
        raise "Unable to perform request. Status: #{response.status}. Message: #{response.content}"
      end      
    end
    
  end
end