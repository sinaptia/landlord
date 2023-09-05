class ApplicationRecord < ActiveRecord::Base
  include Landlord::Concern

  fetch_db_connections
  primary_abstract_class
end
