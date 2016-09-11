class AddPfsRegistrationEndsOnForEvents < ActiveRecord::Migration
  def change
    add_column(:events, :pfs_registration_ends_on, :date)
  end
end
