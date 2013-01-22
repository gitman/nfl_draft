require 'active_record'
require 'rubygems'
require 'csv'

namespace :data do

  # Loads the raw spreadsheet data
  desc 'Loads the raw spreadsheet data. WARNING: Destroys all data in tables!!'
  task :load_raw_data => [:environment] do
    require 'highline/import'

    if ENV['SKIP_NAG'] or ENV['OVERWRITE'].to_s.downcase == 'true' or agree("This task will destroy any data in the database. Are you sure you want to \ncontinue? [y/n] ")
      Rake::Task['db:reset'].execute
      Rake::Task['data:load_players'].execute
      Rake::Task['data:load_teams'].execute
      Rake::Task['data:load_orders'].execute
    end
  end

  desc 'Loading players'
  task :load_players => [:environment] do
    CSV.foreach('db/players.csv', :headers => true) do |row|
      Player.new(:name => row['Player Name'].strip, :position => row['Position'].strip).save!
    end
  end

  desc 'Loading teams'
  task :load_teams => [:environment] do
    CSV.foreach('db/teams.csv', :headers => true) do |row|
      Team.new(:name => row['Team Name'].strip, :division => row['Division'].strip).save!
    end
  end

  desc 'Loading order'
  task :load_orders => [:environment] do
    CSV.foreach('db/order.csv', :headers => true) do |row|
      team_name = row["Team Name"].strip
      team_name.gsub!(/(NY)/, "New York") if team_name.match(/(NY)/)
      Order.new(:round => row['Round'].strip, :pick => row['Pick'].strip, :team_id => Team.find_by_name(team_name).id).save!
    end
  end

  desc 'Simulate the draft process'
  task :simulate_draft_process => [:environment] do
    limits = offsets = Array.new(7) { 0 }

    for round in 1..7
      this_round_teams = Order.where(:round => round)
      offset = limits.inject(0){|sum,item|sum + item}
      puts "Offset ---> #{offset}"
      limits[round - 1] = this_round_teams.count
      if round == 0
        offsets[0] = 0
      elsif round > 1
        offsets[round -1] = offset
        puts " OFFSET: #{offsets[round -1]}"
      end

      players = Player.limit(limits[round-1]).offset(offsets[round-1])

      count = 0
      (1..limits[round - 1]).each do |i|
        count = count+1
        puts" ROUND & PICK : round : #{round}, i #{i}: "
        order_team = this_round_teams[i - 1].team
        puts"Team that has a chance to pick now :#{order_team.name}"
        player_picked = players[i - 1]
        puts" Player picked in round: #{round}, pick : #{i} is #{player_picked.name}"
        order_team.acquire(player_picked)
      end
    end
  end

end
