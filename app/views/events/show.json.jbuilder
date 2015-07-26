json.event do
  json.cache! [@event, current_user, @event.owner == current_user ? "owner" : "guest"], expires: 2.hours do
    json.(@event, :title, :description, :address, :space, :start_time, :end_time, :excerpt)
    json.cover do
      json.url  @event.cover.present? ? @event.cover.url(:cover) : "#{root_url}assets/building-ecosystem.png"
      json.top @event.cover_position if @event.cover
      json.left @event.cover_left if @event.cover
      json.has_cover @event.cover.present?
    end

    json.id @event.uuid
    json.is_owner @event.owner_type == "School" ? @event.owner.user == current_user : @event.owner == current_user

    json.form delete_action: profile_delete_cover_path(@event), action: event_path(@event), method: "PUT"
    json.name @event.title
  end
end

