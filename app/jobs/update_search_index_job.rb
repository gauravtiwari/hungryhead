 class UpdateSearchIndexJob < ActiveJob::Base
  queue_as :default

  def perform(status, id, image, name, description, type, path)
    if status
      loader = Soulmate::Loader.new(type)
      loader.add("term" => name, "image" => image, "description" => description, "id" => id, "data" => {
          "link" => path
      })
    else
      loader = Soulmate::Loader.new(type)
      loader.remove("id" => id) 
    end
  end
end
