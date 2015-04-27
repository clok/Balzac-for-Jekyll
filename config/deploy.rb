# config valid only for current version of Capistrano
lock '3.4.0'

# replace this with your site's name
set :application, "clokwork.net"
set :user, 'clok'
set :repo_url, 'git@github.com:clok/blog.git'
set :scm, :git
set :deploy_to, '/opt/clokwork.net/blog'
set :linked_dirs, fetch(:linked_dirs, []).push('demos', 'pispace', 'box2dpong')

set :format, :pretty
namespace :deploy do
  before :starting, :ask_branch

  desc 'Get branch to deploy'
  task :ask_branch do
    set :branch, ask("a branch to deploy or press ENTER for default. Default branch is", `git rev-parse --abbrev-ref HEAD`.chomp)
  end
  
  task :update_jekyll do
    on roles(:app) do
      #within "#{deploy_to}/current" do
        execute "cd #{deploy_to}/current && /home/clok/.rvm/gems/ruby-2.2.0/wrappers/bundle exec jekyll build"
      #end
    end
  end

end

after "deploy:symlink:release", "deploy:update_jekyll"