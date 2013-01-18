require 'active_record'
require 'rubygems'
require 'csv'

namespace :data do

  # Loads the raw spreadsheet data
  desc 'Loads the raw spreadsheet data. WARNING: Destroys all data in tables!!'
  task :load_raw_data do
    require 'highline/import'

    if ENV['SKIP_NAG'] or ENV['OVERWRITE'].to_s.downcase == 'true' or agree("This task will destroy any data in the database. Are you sure you want to \ncontinue? [y/n] ")
      # Drop all tables
      ActiveRecord::Base.configurations = Rails.application.config.database_configuration
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }

      arr_of_arrs = CSV.read("db/order.csv")
    end
  end
end
