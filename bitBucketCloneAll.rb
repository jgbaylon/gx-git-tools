require 'open-uri'
require 'rubygems'
require 'oauth'
require 'json'

=begin
A. SHORT ROUTE (Recommended)
1. Open and follow instructions on generateAccessTokenAndSecret.rb
2. Modify BITBUCKET_* environment variables from setEnv.sh; then run
   source setEnv.sh
   ./setEnv.sh
3. To run
   ruby bitBucketCloneAll.rb

B. LONG ROUTE
1. Manage account > Integrated applications > Add consumer. Take note of Key and Secret.
2. Request token using the OAuth Test Client: http://term.ie/oauth/example/client.php
   a. endpoint: https://bitbucket.org/api/1.0/oauth/request_token?oauth_callback=http%3A%2F%2Flocalhost
   b. consumer key: <Key>
   c. consumer secret: <Secret>
   d. hit request_token button and open the downloaded request_token file and make sure to have these parameters
      oauth_token_secret=<oauth token secret>&oauth_token=<oauth token>&oauth_callback_confirmed=true
3. Redirect user to Bitbucket to authorize application:
   a. open new window: https://bitbucket.org/api/1.0/oauth/authenticate?oauth_token=<oauth token>
   b. hit Grant Access button
   c. from the address bar: take note of oauth_verifier=<oauth verifier>
4. Request an Access Token:
   a. go back to OAuth Test Client window
      i. token: <oauth token>
      ii. token secret: <oauth token secret>
      iii. update endpoint: https://bitbucket.org/api/1.0/oauth/access_token?oauth_version=1.0&oauth_verifier=<oauth verifier>
      iv. hit access_token button and open the downloaded access_token file and make sure to have these parameters
          oauth_token_secret=<oauth token secret>&oauth_token=<oauth token>      
5. Modify BITBUCKET_* environment variables from setEnv.sh; then run
   source setEnv.sh
   ./setEnv.sh
6. sudo gem install oauth
7. To run
   ruby bitBucketCloneAll.rb
=end

system("rm clone_script.sh")

consumerKey = ENV['BITBUCKET_CONSUMER_KEY']
consumerSecret = ENV['BITBUCKET_CONSUMER_SECRET']
oauthToken = ENV['BITBUCKET_OAUTH_TOKEN']
oauthTokenSecret = ENV['BITBUCKET_OAUTH_TOKEN_SECRET']
organization = ENV['BITBUCKET_ORGANIZATION']
path = ENV['BITBUCKET_LOCAL_PATH']

@consumer = OAuth::Consumer.new consumerKey,
                                consumerSecret,
                                {:site=>"https://bitbucket.org"}

@accessToken = OAuth::AccessToken.new(@consumer, oauthToken, oauthTokenSecret)

File.open("clone_script.sh", 'a') do |f|
  f.puts("cd " + path)

  content = @accessToken.get("/api/1.0/user/repositories").body
  json = JSON.parse(content)

  json.each do |repo|
    name = p repo["name"]
    f.puts("git clone git@bitbucket.org:" + organization + "/" + name + ".git")
  end
end

system("bash clone_script.sh")
