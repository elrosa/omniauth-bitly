require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Bitly < OmniAuth::Strategies::OAuth2
      option :name, "bitly"
      option :client_options,{:site=>'https://api-ssl.bitly.com/',
                              :authorize_url => 'https://bitly.com/oauth/authorize',
                              :token_url => 'https://api-ssl.bitly.com/oauth/access_token'}

      option :token_params, {
        :parse => :query
      }

      uid{ raw_info['login'] }


      info do
        {
          'login' => raw_info['login'],
          'display_name' => raw_info['display_name'],
          'full_name' => raw_info['full_name'],
          'profile_image' => raw_info['profile_image'],
          'profile_url'=>raw_info['profile_url'],
          'api_key' => raw_info['apiKey']
        }
      end

      extra do
        {:raw_info => raw_info}
      end
      
      def raw_info
        # HACK HACK HACK
        access_token.options[:mode] = :query
        access_token.options[:param_name] = :access_token
        @raw_info ||= MultiJson.encode(access_token.get('/v3/user/info').body)['data']
      end

    end
  end
end
OmniAuth.config.add_camelization 'bitly', 'Bitly'