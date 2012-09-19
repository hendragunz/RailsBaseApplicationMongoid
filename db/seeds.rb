# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def load_rb(seed)
  puts "executing file #{seed.inspect}"
  require "#{seed}"
  klass_name = ("seed_" + File.basename("#{seed}", '.rb').split('-').last).classify
  klass = klass_name.constantize
  klass.send(:seed)
end

if ENV["VERSION"]
  Dir[Rails.root.join('db', 'seeds', Rails.env, '*')].sort.each do |seed|
    next unless File.basename(seed).split('-').first.to_f == ENV["VERSION"].to_f
    load_rb(seed)
  end
else
  # database_config = load_config
  Dir[Rails.root.join('db', 'seeds', Rails.env, '*')].sort.each do |seed|
    load_rb(seed)
  end
end
