module SeedUser
  def self.seed

  User.destroy_all

  25.times do |x|
    user = User.new do |u|
      u.build_profile(:biography => Faker::Lorem.paragraph)
      u.fullname = Faker::Name.first_name
      u.email = "user_#{x + 1}@example.com"
      u.password = '123456'
      u.password_confirmation = '123456'
      # u.profile.avatar = File.open(Rails.root.join('db', 'seeds', 'images', 'avatar',"avatar_#{rand(11)+1}.jpg"), 'r')
      u.confirmed_at = Time.now.utc
    end
    user.save!
  end

  end
end

