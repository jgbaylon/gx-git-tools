require 'rubygems'
require 'oauth'
require 'yaml'

=begin
1. Manage account > Integrated applications > Add consumer. Take note of Key and Secret.
2. Modify BITBUCKET_CONSUMER_KEY and BITBUCKET_CONSUMER_SECRET environment variables from setEnv.sh; then run
   source setEnv.sh
   ./setEnv.sh
3. Do a sudo gem install on all required gems if not available
4. To run
   a. ruby generateAccessTokenAndSecret.rb
   b. open auth.yaml and take note of oauth_token and oauth_token_secret
=end

consumerKey = ENV['BITBUCKET_CONSUMER_KEY']
consumerSecret = ENV['BITBUCKET_CONSUMER_SECRET']

@consumer=OAuth::Consumer.new consumerKey,
                              consumerSecret,
                              {:site               => "https://bitbucket.org",
                               :request_token_path => "/api/1.0/oauth/request_token",
                               :access_token_path  => "/api/1.0/oauth/access_token",
                               :authorize_path     => "/api/1.0/oauth/authenticate"}

@request_token = @consumer.get_request_token :oauth_callback => "http://localhost"

puts "Visit the following URL, log in if you need to, and authorize the app"
puts @request_token.authorize_url
puts "When you've authorized that token, enter the verifier code you are assigned:"
verifier = gets.strip                                                                                                                                                               
puts "Converting request token into access token..."                                                                                                                                
@access_token=@request_token.get_access_token(:oauth_verifier => verifier)                                                                                                          

auth = {} 
auth["oauth_token"] = @access_token.token
auth["oauth_token_secret"] = @access_token.secret
 
File.open('auth.yaml', 'w') {|f| YAML.dump(auth, f)}
 
puts "Done. Have a look at auth.yaml to see what's there."
