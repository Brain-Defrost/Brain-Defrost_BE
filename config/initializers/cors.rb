# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:3000", "http://127.0.0.1:3000", "https://brain-defrost.netlify.app", "https://brain-defrost.github.io", "https://brain-defrost.github.io/Brain-Defrost_FE/", "https://development--brain-defrost.netlify.app"

    resource "*",
      headers: :any,
      methods: [:get, :post, :patch, :delete, :options, :head]
  end
end
