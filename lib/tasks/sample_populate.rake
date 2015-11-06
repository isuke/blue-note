namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        populate_users
        populate_projects
        populate_members
        populate_features
        populate_iterations
      end
    end

  private

    def populate_users(num = 5)
      puts "populate users"
      User.destroy_all
      num.times do |n|
        FactoryGirl.create(:user, email: "user#{n}@example.com", password: 'foobar')
      end
    end

    def populate_projects(num = 10)
      puts "populate projects"
      Project.destroy_all
      FactoryGirl.create_list(:project, num)
    end

    def populate_members(num = 3)
      puts "populate members"
      Member.destroy_all
      Project.all.each do |project|
        User.all.sample(num).each.with_index do |user, index|
          if index.zero?
            user.join!(project, role: :admin)
          else
            user.join!(project, role: :general)
          end
        end
      end
    end

    def populate_features(num = 30)
      puts "populate features"
      Feature.destroy_all
      Project.all.each do |p|
        FactoryGirl.create_list(:feature, num, project: p)
      end
    end

    def populate_iterations
      puts "populate iterations"
      Iteration.destroy_all
      Project.all.each do |p|
        3.times do |i|
          FactoryGirl.create(:iteration, project: p, number: i + 1)
        end
      end
    end
  end
end
