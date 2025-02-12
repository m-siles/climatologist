require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :faraday
  config.configure_rspec_metadata!
  
  # Filter out sensitive keys
  config.before_record do |interaction|
    uri = URI(interaction.request.uri)
    
    if uri.query
      params = URI.decode_www_form(uri.query).to_h
      params.delete('api_key')
      uri.query = URI.encode_www_form(params)
      interaction.request.uri = uri.to_s
    end
  end

  # change VCR request matching to accommodate key erasure
  config.default_cassette_options = {
    match_requests_on: [:method, :host, lambda { |request1, request2|
      uri1 = URI(request1.uri)
      uri2 = URI(request2.uri)
      
      # Parse query parameters for both URIs
      params1 = URI.decode_www_form(uri1.query.to_s).to_h
      params2 = URI.decode_www_form(uri2.query.to_s).to_h
      
      params1.delete('api_key')
      params2.delete('api_key')
      
      # Compare the paths and remaining query parameters
      uri1.path == uri2.path && params1 == params2
    }]
  }
end