module ApplicationHelper

  def notifications_count
    current_user.mailbox.notifications(read: false).length
  end

  def current_class?(test_path)
    return 'active' if request.path == test_path
    ''
  end

  def followed?(object)
    if current_user && current_user.followings_ids.values.include?(object.id.to_s)
      followed =  {
        follow: true,
        followable_type: object.class.name,
        followable_id: object.id
      }
    else
      followed = {
        follow: false,
        followable_type: object.class.name,
        followable_id: object.id
      }
    end
  end

  def idea_followed?(object)
    if current_user && current_user.idea_followings_ids.values.include?(object.id.to_s)
      followed =  {
        follow: true,
        followable_type: object.class.name,
        followable_id: object.id
      }
    else
      followed = {
        follow: false,
        followable_type: object.class.name,
        followable_id: object.id
      }
    end
  end

  def your_name(user, type)
    if user == current_user && type
      "your"
    elsif user == current_user && !type
      "You"
    else
      user.name
    end
  end

end
