class Facultad < ApplicationRecord
  has_many :programas, :dependent => :restrict_with_error
end
