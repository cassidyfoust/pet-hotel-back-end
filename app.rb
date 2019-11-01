require 'sinatra'
require 'sinatra/json'
require 'bundler'

Bundler.require

DataMapper.setup(:default, 'sqlite::memory')
DataMapper.finalize
DataMapper.auto_migrate!

# Listen on all interfaces in the development environment
# This is needed when we run from Cloud 9 environment
# source: https://gist.github.com/jhabdas/5945768
set :bind, '0.0.0.0'
set :port, 4567

get '/pets' do
  content_type :json
  pets = []
  begin
    connection = PG.connect :dbname => 'pet_hotel', :user => 'Nathan', :password => 'Nathan'

    get_pets = connection.exec 'SELECT * FROM "pets"
    JOIN "owners" ON "pets".owner_id = "owners".id;'

    get_pets.each do |s_pet|
      pets.push({ id: s_pet['id'], pet_name: s_pet['pet_name'], breed: s_pet['breed'], color: s_pet['color'], checked_in: s_pet['checked_in'], owner_id: s_pet['owner_id'], owner_name: s_pet['name'] })
    end
  pets.to_json
  end
end

get '/owners' do
  content_type :json
  owners = []
  begin
    connection = PG.connect :dbname => 'pet_hotel', :user => 'Nathan', :password => 'Nathan'

    get_owners = connection.exec 'SELECT * FROM "owners";'

    get_owners.each do |s_owner|
      owners.push({ id: s_owner['id'], name: s_owner['name'] })
    end
  owners.to_json
  end
end

get '/owners' do
  content_type :json
  owners = []
  begin
    connection = PG.connect :dbname => 'pet_hotel', :user => 'cassidyfoust'

    get_owners = connection.exec 'SELECT * FROM "owners"
    JOIN "pets" ON "pets".owner_id = "owners".id;'

    get_owners.each do |s_owner|
      owners.push({ id: s_owner['id'], name: s_owner['name']})
    end
  owners.to_json
  end
  # pets = Pets.all
  # pets.to_json
end


post '/pets' do
  content_type :json
  puts 'post pets hit:', params[:name], params[:color], params[:breed], params[:owner], params[:checkedIn]

  # begin
  #   connection = PG.connect :dbname => 'pet_hotel', :user => 'cassidyfoust'

  #   get_owners = connection.exec 'INSERT INTO "pets" ()
  #   JOIN "pets" ON "pets".owner_id = "owners".id;'
  # end

  # if pets.save
  #   status 201
  # else 
  #   status 500
  #   json pets.errors.full_messages
  # end
end

# put '/pets/:id' do
#   content_type :json
#   pets = Pets.get params[:id]
#   if pets.update params[:pets]
#     status 200
#     json "Pet was updated"
#   else
#     status 500
#     json pets.errors.full_messages
#   end
# end

# delete '/pets/:id' do
#     content_type :json
#     pets = Pets.get params[:id]
#     if pets.destroy
#       status 200
#       json "Pet was destroyed."
#   else
#     status 500
#     json "There was a problem destroying the pet"
#   end

# end