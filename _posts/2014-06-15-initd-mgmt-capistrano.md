---
layout: post-no-feature
title: Managing init.d services with Capistrano
description: "Time to get a little meta."
category: articles
tags: [ Capistrano, Ruby, meta, DevOps ]
---

I really do love Capistrano. Doing a little ruby-fu with some cap-fu you can quickly and cleanly generate useful management tasks.

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
Doing a quick check of the tasks descriptions we see that 4 tasks were created.

``` shell
clok@level1 ~/github/cap-demo/ (git::master) $ be cap -T apache
cap apache:reload   # reload apache services
cap apache:restart  # restart apache services
cap apache:start    # start apache services
cap apache:stop     # stop apache services
clok@level1 ~/github/cap-demo/ (git::master) $
```
So what is happening here?

Under the `namespace` `:apache` we have:

``` ruby
[:start, :stop, :restart, :reload].each do | command_sym |
  desc "#{command_sym} apache services"
  task command_sym do
```

This will take the four symbols (`:start`, `:stop`, `:restart`, `:reload`) and it will generate `desc` and `task` under the namespace. The `httpd` service above has commands in the `init.d` file that are associated with these tasks. 

And with that, you have a full suite of management cap tasks for your service.