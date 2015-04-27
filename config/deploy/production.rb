server 'clokwork.net', user: 'clok', roles: %w{app}
=begin
set :bundle_binstubs, nil

set :bundle_flags, '--deployment --quiet'
set :rvm_type, :user

SSHKit.config.command_map[:rake]  = "bundle exec rake"

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end
=end