class CampBot < Sinatra::Base
  get '/' do
    "Nothing to see here."
  end
  
  post '/' do
    Basecamp.establish_connection!(ENV['BASECAMP_URL'], ENV['BASECAMP_LOGIN'], ENV['BASECAMP_PASSWORD'], true)
    payload = JSON.parse(params[:payload])
    halt 400, '' if payload['repository']['url'] != ENV['GITHUB_REPO']
    payload['commits'].each do |commit|
      puts "Commit message = #{commit['message'].inspect}"
      if commit['message'] =~ /(?:fix|fixes|closes?) (\d+)/i
        puts "Matching commit, TodoItem id = #{$1}"
        t = Basecamp::TodoItem.find($1)
        t.complete!
      end
    end
  end
end