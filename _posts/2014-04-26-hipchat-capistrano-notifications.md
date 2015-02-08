---
layout: post-no-feature
title: Cleaner HipChat notifications with Capistrano
description: "Use more of the API features that are available."
category: articles
tags: [ Capistrano, HipChat, Ruby ]
---

The `hipchat` gem has many features that the default `capistrano` integration does not take advantage of. This is quick run down of how I integrated a more full featured use of the gem. This particular walkthrough is for integrating with Capistano 3.

First off, in your `deploy.rb` file `require` the HipChat gem. We will also need to set a few state wide symbols that will be used throughout the cap tasks. NOTE: DO NOT `require 'hipchat/capistrano'`. This will cause the old capistrano integration to take over. I have found that the old capistrano hipchat integration to be flawed, mainly confusing stages that are being acted on.

``` ruby
# HipChat client
require 'hipchat'
set :hipchat_token,     "SuperSecretToken"
set :hipchat_room_name, "Deployments"
set :hipchat_user,      "Deploy Bot"
set :hipchat_announce,  true
set :hipchat_client,    HipChat::Client.new(fetch(:hipchat_token))
```

Note the `:hipchat_client` symbol. This will be what is used to post notifications throughout the multiple cap tasks.

Next we can add a simple `ping` task to test the HipChat integration.

``` ruby
namespace :hipchat do
  desc 'Test HipChat API connection'
  task :ping do
    fetch(:hipchat_client)[fetch(:hipchat_room_name)].send(fetch(:hipchat_user), "Test 1, 2... Test! (#{fetch(:stage)})", :notify => fetch(:hipchat_announce), :color => 'purple')
  end
end
```

What I like about this method is that I am able to control the Username, Message, Notification and Color with every call. Using the capistrano `fetch` method, I am able to call on the many different state wide variables I hav setup to make the overall pattern highly repeatable.

Taking the pattern in the above example, it's easy to place that into another cap task:

``` ruby
namespace :apache do
  [:start, :stop, :restart, :reload].each do | command_sym |
    desc "#{command_sym} apache services"
    task command_sym do
      on roles(:admin, :web), in: :parallel do |host|
        fetch(:hipchat_client)[fetch(:hipchat_room_name)].send(fetch(:hipchat_user), "#{command_sym}ing apache servers on #{host.hostname} (#{fetch(:stage)})", :notify => fetch(:hipchat_announce), :color => 'blue')
        sudo "/etc/rc.d/init.d/httpd #{command_sym}"
      end
    end
  end
end
```

I love capistrano.