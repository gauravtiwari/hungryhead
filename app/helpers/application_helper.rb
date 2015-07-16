module ApplicationHelper

  def notifications_count
    current_user.mailbox.notifications(read: false).length if current_user
  end

  def is_beta
    false
  end

  def current_class?(test_path)
    return 'text-brand bold p-b-5 b-b b-grey' if request.path == test_path
    ''
  end

  def active_class?(test_path)
    return 'active' if request.fullpath == test_path
    ''
  end

  def followed?(object)
    if current_user && object.followers_ids.member?(current_user.id)
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
