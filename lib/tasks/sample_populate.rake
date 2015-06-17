namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        populate_projects
        populate_features
      end
    end

    private
      def populate_projects(num=3)
        puts "populate projects"
        Project.destroy_all
        FactoryGirl.create_list(:project, num)
      end

      def populate_features(num=30)
        puts "populate features"
        Feature.destroy_all
        Project.all.each do |p|
          FactoryGirl.create_list(:feature, num, project: p)
        end
      end
  end
end
