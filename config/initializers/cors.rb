Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000', 'http://172.28.32.1:3000'  # cho tất cả domain
    resource '*',
      headers: :any,
      expose: ['Set-Cookie', 'Authorization'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      max_age: 86400
  end
end
