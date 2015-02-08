---
layout: post-no-feature
title: Gearman + Capistrano = Awesome
description: "Managing Gearman servers with capistrano."
category: articles
tags: [ Capistrano, Ruby, meta ]
---

To properly monitor and maintain your Gearman cluster, you will need to use the `mod-gearman` tools. [You can find them here](https://labs.consol.de/nagios/mod-gearman/).

Using the pattern I described in a [previous post]({{ site.url }}/articles/initd-mgmt-capistrano/) we can build the `gearmand` service management tasks.

``` ruby
namespace :gearman do
  [:start, :stop, :restart].each do | command_sym |
    desc "#{command_sym} gearmand on gm servers"
    task command_sym do
      on roles(:gm), in: :parallel do |host|
        fetch(:hipchat_client)[fetch(:hipchat_room_name)].send(fetch(:hipchat_user), "#{command_sym} of gearmand service on #{host.hostname}", :notify => fetch(:hipchat_announce), :color => 'purple')
        execute "/etc/init.d/gearmand #{command_sym}"
      end
    end
  end
```

The `check_gearman` tool is a toold provided by installing the [mod-gearman](https://labs.consol.de/nagios/mod-gearman/) tools suite. It is a client that runs locally and queries the `gearmand` servers for status data. It produces useful data on what workers are connected, how many jobs are queued and how many are in process. The task below will ensure you have `check_gearman` installed before running the tool and cleaning up the output.

``` ruby
  desc 'runs the "check_gearman" support utility on the gearman servers'
  task :check do
    on roles(:gm) do |host|
      unless `which check_gearman`.empty?
        # This was done to get the output in sequence
        info "Status of jobs on #{host.hostname}\n#{`check_gearman -v -H #{host.hostname} | grep 'name'`}"
      else
        error "In order to run gearman:check you will need the check_gearman utility. It can be installed using the mod_gearman suite: https://labs.consol.de/nagios/mod-gearman/"
      end
    end
  end
```

One last useful task I use is one to wipe out the Gearman server log. Some times it can get absurdly large and this can help clean that up, especially when in a debug state.

``` ruby
  desc 'clear gearmand log. It can get quite large.'
  task :clear_log do
    on roles(:gm) do |host|
      execute 'rm /home/gearman/shared/log/gearman.log'
    end
  end
end
```

Doing a quick check of the tasks descriptions we see:

``` shell
clok@level1 ~/github/cap-demo/ (git::master) $ be cap -T gearman
cap gearman:check      # runs the "check_gearman" support utility on the gearman servers
cap gearman:clear_log  # clear gearmand log
cap gearman:restart    # restart gearmand on gm servers
cap gearman:start      # start gearmand on gm servers
cap gearman:stop       # stop gearmand on gm servers
clok@level1 ~/github/cap-demo/ (git::master) $
```
