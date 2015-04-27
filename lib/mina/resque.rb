# -*- coding: utf-8 -*-
namespace :resque do

  desc "初始化 god"
  task :start_god do
    queue 'echo "-----> 初始化 god "'
    queue echo_cmd "cd #{pro_root_path} && bundle exec god -c ./config/resque.god -P #{pro_root_path}/tmp/pids/god.pid"
  end

  task :stop_god do
    queue 'echo "-----> 停止 god "'
    queue echo_cmd "kill `cat #{pro_root_path}/tmp/pids/god.pid`"
  end


  desc "启动 resque的workers"
  task :start do
    queue 'echo "-----> 启动 resque的workers "'
    queue echo_cmd "kill `cat #{pro_root_path}/tmp/pids/god.pid` && cd #{pro_root_path} && bundle exec god -c ./config/resque.god -P #{pro_root_path}/tmp/pids/god.pid && bundle exec god start resque"
    # queue echo_cmd "cd #{pro_root_path} && bundle exec god start resque"
  end


  desc "启动resque的workers"
  task :stop do
    queue 'echo "-----> 停止 resque的workers "'
    # 跟resque.god 同步
    2.times do |num|
      queue echo_cmd "kill -QUIT `cat #{pro_root_path}/tmp/pids/resque-#{num}.pid`"
    end
  end


  desc "重启resque的workers"
  task :restart do
    queue 'echo "-----> 重启 resque的workers "'
    invoke :'resque:stop'
    # invoke :'resque:start'
  end

end
