Rswag::Ui.configure do |config|
  config.openapi_endpoint '/api-docs/v1/swagger.yaml', 'Patient Injection API V1'
end

Rswag::Api.configure do |config|
  config.openapi_root = Rails.root.join('swagger')
end
