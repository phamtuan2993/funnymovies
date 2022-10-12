# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store,
  key: '_funny_movies_session',
  secure: (Rails.env.production? || Rails.env.staging?),
  httponly: true,
  same_site: :lax
