CarrierWave.configure do |config|
  config.root = Rails.public_path.to_s
  config.storage = (Rails.env.development? || Rails.env.test?) ? :file : :fog
end
