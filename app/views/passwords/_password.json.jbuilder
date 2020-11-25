json.extract! password, :id, :login, :password, :site, :created_at, :updated_at
json.url password_url(password, format: :json)
