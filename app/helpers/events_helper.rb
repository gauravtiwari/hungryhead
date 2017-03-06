module EventsHelper
  def attending?(event)
    event = if current_user && event.attending?(current_user)
              {
                attending: true
              }
            else
              {
                attending: false
              }
            end
    event.merge!(
      event_slug: event.slug,
      user_id: current_user.uid,
      user_slug: current_user.slug
    )
  end
end
