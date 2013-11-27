require 'open-uri'
require 'rubygems'
require 'json'

=begin
1. Follow instructions to generate oauth_token_secret and oauth_token from https://confluence.atlassian.com/display/BITBUCKET/OAuth+on+Bitbucket
2. Modify BITBUCKET_* environment variables from setEnv.sh; then run
   ./setEnv.sh
5. To run
   ruby bitBucketCloneAll.rb
=end

system("rm clone_script.sh")

token = ENV['BITBUCKET_OAUTH_TOKEN']
secret = ENV['BITBUCKET_OAUTH_TOKEN_SECRET']
organization = ENV['BITBUCKET_ORGANIZATION']
path = ENV['BITBUCKET_LOCAL_PATH']

File.open("clone_script.sh", 'a') do |f|
  f.puts("cd " + path)

  content = open("https://bitbucket.org/api/1.0/user/repositories?oauth_token=" + oauth_token + "&oauth_token_secret=" + oauth_token_secret).read
  json = JSON.parse(content)

  json.each do |repo|
    name = p repo["name"]
    f.puts("git clone git@bitbucket.org:" + organization + "/" + name + ".git")
  end
end

system("bash clone_script.sh")
