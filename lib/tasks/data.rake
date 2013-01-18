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
end
