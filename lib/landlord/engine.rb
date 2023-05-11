module Landlord
  class Engine < Rails::Engine
    rake_tasks do
      load File.join(__dir__, "tasks/landlord.rake")
    end
  end
end
