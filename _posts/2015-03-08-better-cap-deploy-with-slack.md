---
layout: post
title: A Better Slack Bot + Capistrano
description: "How to get readable, informative Slack notifications from Capistrano"
category: articles
tags: [ Capistrano, Ruby, Slack, Deployment, DevOps ]
image:
  feature: better_slack_bot_for_cap.png
---

There are a lot of options for [Slack](https://slack.com/) ruby and capistrano clients out there. I wasn't terribly happy with the overall presentation of most, but I found that the [slack-notifier](https://github.com/stevenosloan/slack-notifier) gem by Steven Sloan was the most extensible out of the box. Great work!

Setting up a slack client in my main `deploy.rb` file, I could then use it throughout my capistrano tasks to notify slack channels. 

``` ruby
# Slack notifications setup
set :slack_url, 'WEB HOOK URL HERE'
set :slack_channel, '#devops'
set :slack_username, 'capistrano'
set :slack_emoji, ':saiyan:'
set :slack_user, `git config --get user.name`.chomp
set :slack_client, Slack::Notifier.new(
  fetch(:slack_url),
  channel: fetch(:slack_channel),
  username: fetch(:slack_username),
  icon_emoji: fetch(:slack_emoji)
)
```

I then wrote a series of cap tasks for the new slack bot that I used for deployment hooks. The main reason I did this instead of using an already existing gem is that I wanted an output that was informative and pretty in the slack channel. Here is an example of the end result:

<figure>
  <img src="/images/better_slack_bot_for_cap.png">
  <figcaption>A clearly readable table of events.</figcaption>
</figure>

Compare this against the typical integrations that are out there:

<figure>
  <img src="/images/old_slack_bot_for_cap.png">
  <figcaption>A bland blob of text.</figcaption>
</figure>


Here is the code that I put together to get that output. I would like to put this in a gem for capistrano since I believe it would be helpful to others.

``` ruby
namespace :slack do
  desc 'Notify slack start of deployment'
  task :deploy_start do
    set :time_started, Time.now.to_i
    fetch(:slack_client).ping '', attachments: [{
      fallback: "#{fetch(:slack_user)} starting a deploy. Stage: #{fetch(:stage)} "\
        "Revision/Branch: #{fetch(:current_revision, fetch(:branch))} "\
        "App: #{fetch(:application)}",
      title: "Deployment Starting",
      color: "#F35A00",
      fields: [
        {
          title: "User",
          value: "#{fetch(:slack_user)}",
          short: true
        },
        {
          title: "Stage",
          value: "#{fetch(:stage)}",
          short: true
        },
        {
          title: "Revision/Branch",
          value: "#{fetch(:current_revision, fetch(:branch))}",
          short: true
        },
        {
          title: "Application",
          value: "#{fetch(:application)}",
          short: true
        }
      ]
    }]
  end

  desc 'Notify slack completion of deployment'
  task :deploy_complete do
    set :time_finished, Time.now.to_i
    elapsed = Integer(fetch(:time_finished) - fetch(:time_started))
    fetch(:slack_client).ping '', attachments: [{
      fallback: "Revision #{fetch(:current_revision, fetch(:branch))} of "\
        "#{fetch(:application)} deployed to #{fetch(:stage)} by #{fetch(:slack_user)} "\
        "in #{elapsed} seconds.",
      title: 'Deployment Complete',
      color: "#7CD197",
      fields: [
        {
          title: "User",
          value: "#{fetch(:slack_user)}",
          short: true
        },
        {
          title: "Stage",
          value: "#{fetch(:stage)}",
          short: true
        },
        {
          title: "Revision/Branch",
          value: "#{fetch(:current_revision, fetch(:branch))}",
          short: true
        },
        {
          title: "Application",
          value: "#{fetch(:application)}",
          short: true
        },
        {
          title: "Duration",
          value: "#{elapsed} seconds",
          short: true
        }
      ]
    }]
  end

  desc 'Notify slack of a failure in deployment'
  task :deploy_failed do
    fetch(:slack_client).ping "Deploy Failed!", attachments: [{
      fallback: "#{fetch(:stage)} deploy of #{fetch(:application)} "\
        "with revision/branch #{fetch(:current_revision, fetch(:branch))} failed",
      title: "Deployment Failed",
      text: "#{fetch(:stage)} deploy of #{fetch(:application)} "\
        "with revision/branch #{fetch(:current_revision, fetch(:branch))} failed",
      color: "#FF0000",
      fields: [
        {
          title: "User",
          value: "#{fetch(:slack_user)}",
          short: true
        },
        {
          title: "Stage",
          value: "#{fetch(:stage)}",
          short: true
        },
        {
          title: "Revision/Branch",
          value: "#{fetch(:current_revision, fetch(:branch))}",
          short: true
        },
        {
          title: "Application",
          value: "#{fetch(:application)}",
          short: true
        }
      ]
    }]
  end

  desc 'Notify slack of Rails Cache clearing'
  task :rails_cache_cleared do
    fetch(:slack_client).ping '', attachments: [{
      fallback: "Rails cache cleared on #{fetch(:stage)}",
      text: "Rails cache cleared on #{fetch(:stage)}",
      color: "#7CD197"
    }]
  end
end
```

Doing a quick check of the tasks descriptions we see:

``` shell
clok@level4 ~/captastic (git::master) $ be cap -T slack
cap slack:deploy_complete      # Notify slack completion of deployment
cap slack:deploy_failed        # Notify slack of a failure in deployment
cap slack:deploy_start         # Notify slack start of deployment
cap slack:rails_cache_cleared  # Notify slack of Rails Cache clearing
clok@level4 ~/captastic (git::master) $
```
