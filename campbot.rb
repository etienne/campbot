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
        t.complete!
        comment = "Completed by #{commit['author']['name']} in commit <a href=\"#{commit['url']}\">#{commit['id'][0..9]}</a>"
        Basecamp::Comment.create(:todo_item_id => todo_item_id, :contents => comment)
      end
    end
  end
end