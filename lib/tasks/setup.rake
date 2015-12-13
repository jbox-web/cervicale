namespace :app do

  desc 'Setup first installation'
  task setup: %w(first_install:create_admin_user)

  namespace :first_install do
    desc 'Create Admin User'
    task create_admin_user: [:environment] do
      user_option = {
        first_name: 'Admin',
        last_name:  'Cervicale',
        email:      'admin@example.net',
        admin:      true,
        password:   'admin123',
        language:   'fr',
        time_zone:  'Paris'
      }

      if User.find_by_email('admin@example.net').nil?
        puts 'Create Admin user ...'
        admin = User.new(user_option)
        admin.save!
        puts 'Done!'
        puts
        puts 'email    : admin@example.net'
        puts 'password : admin123'
      else
        puts 'User admin already exists, skip ...'
      end
    end
  end

end
