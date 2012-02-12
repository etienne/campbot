class CampBot < Sinatra::Base
  get '/' do
    "Nothing to see here."
  end
  
  post '/' do
    Basecamp.establish_connection!(ENV['BASECAMP_URL'], ENV['BASECAMP_LOGIN'], ENV['BASECAMP_PASSWORD'], true)
    push = JSON.parse(params[:payload])
    puts "----------------- repo url = #{push['repository']['url']}"
    halt 400 if push['repository']['url'] != ENV['GITHUB_REPO']
    push['commits'].each do |commit|
      puts "Commit."
      if commit['message'] =~ /(fixes?|closes?) (\d+)/
        puts "Matching commit."
        t = Basecamp::TodoItem.find($1)
        t.complete!
      end
    end
  end
end