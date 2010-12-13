# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_on_rails_session',
  :secret      => 'cfc3ee00ebcb4099dfddf74fa2e98231fdb40b652647c2d369ba0fa86144e3d8f2b0f2988f1ea4fb16f9dfd9d88422543556a2a002adf7da039906c0b227c3c6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
