class CampBot < Sinatra::Base
  get '/' do
    "Nothing to see here."
  end
  
  post '/' do
    Basecamp.establish_connection!(ENV['BASECAMP_URL'], ENV['BASECAMP_LOGIN'], ENV['BASECAMP_PASSWORD'], true)
    payload = JSON.parse(params[:payload])
    halt 400, '' if payload['repository']['url'] != ENV['GITHUB_REPO']
    payload['commits'].each do |commit|
      if commit['message'] =~ /(?:fix|fixes|closes?) (\d+)/i
        todo_item_id = $1
        t = Basecamp::TodoItem.find(todo_item_id)
        if t.complete!
          c = Basecamp::Comment.new(:todo_item_id => todo_item_id)
          puts "Created comment for todo item #{todo_item_id}"
          c.body = "Completed by #{commit['author']['name']} in commit <a href=\"#{commit['url']}\">#{commit['id'][0..6]}</a>"
          puts "Added comment body"
          c.save
          puts "Saved comment"
        end
      end
    end
  end
end