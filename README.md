#CampBot

CampBot is a very crude Sinatra app that uses GitHub's post-receive hooks to complete your Basecamp todo items.

##How to install

The easiest way to use CampBot is to host your app on Heroku.

1. Clone this repository
2. Use `heroku create` to create your Heroku app
3. Add the following configuration variables using `heroku config:add NAME=value`:
  - `BASECAMP_URL`: Your Basecamp domain, e.g. yourcompany.basecamphq.com
  - `BASECAMP_LOGIN`: Either your Basecamp login name or your API token
  - `BASECAMP_PASSWORD`: Your Basecamp password, or 'X' if you're using your API token as the login
  - `GITHUB_REPO`: The GitHub repo to watch
4. Add your Heroku app's URL as a post-receive hook in your GitHub repository (you need to be the repo's owner)

##How to use

1. Find out the ID of the todo item you want to complete. In your Basecamp project, click on the comment bubble next to the todo item. This will take you to a page with a URL in the following format: `https://yourcompany.basecamphq.com/projects/1234-site-web/todo_items/5678/comments`. In this case, 5678 is the ID of your todo item.
2. When you want to complete the todo item, append `Closes 5678` to your commit message. `Fixes 5678`, `Fix 5678` and `close 5678` are also valid.
3. Push your changes to GitHub. Your Basecamp todo should be marked as completed within seconds.
