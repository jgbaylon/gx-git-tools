require 'open-uri'
require 'rubygems'
require 'json'

=begin
1. To generate access token that has scope repo (public and private)
   curl https://api.github.com/authorizations --user <username> --data '{"scopes":["repo"]}'
2. Copy the token field generated
3. Go to your Account Settings > Applications > Personal Access Tokens and modify description with the token
4. Modify GITHUB_* environment variables from setEnv.sh; then run
   source setEnv.sh
   ./setEnv.sh
5. Do a sudo gem install on all required gems if not available
6. To run
   ruby gitHubCloneAll.rb
=end

system("rm clone_script.sh")

username = ENV['GITHUB_USERNAME']
organization = ENV['GITHUB_ORGANIZATION']
path = ENV['GITHUB_LOCAL_PATH']
token = ENV['GITHUB_ACCESS_TOKEN']

File.open("clone_script.sh", 'a') do |f|
  f.puts("cd " + path)

  content = open("https://api.github.com/orgs/" + organization + "/repos?access_token=" + token).read
  json = JSON.parse(content)

  json.each do |repo|
    name = p repo["name"]
    f.puts("git clone git@github.com:" + organization + "/" + name + ".git")
  end
end

system("bash clone_script.sh")
