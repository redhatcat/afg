# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_afg_session',
  :secret      => '0c533d6d557c3135773849a29120046ba1f488496a7037225e21bfb9d696c32abac982b46255f133c4f8a8bba66f73df802fd2446d9db43fa10e41a4eae31670'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
