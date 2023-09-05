module Landlord
  class Engine < ::Rails::Engine
    rake_tasks do
      load File.join(__dir__, "../tasks/landlord_tasks.rake")
    end
  end
end
