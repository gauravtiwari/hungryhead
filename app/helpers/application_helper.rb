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
        followable_id: object.slug
      }
    else
      followed = {
        follow: false,
        followable_type: object.class.name,
        followable_id: object.slug
      }
    end
  end

  def voted?(object)
    if current_user && object.voted?(current_user)
      voted =  {
        vote: true,
        votes_count: object.votes_counter.value,
        path: voters_votes_path(votable_type: object.class.name, votable_id: object.uuid),
        votable_type: object.class.name,
        votable_id: object.uuid
      }
    else
      voted = {
        vote: false,
        votes_count: object.votes_counter.value,
        path: voters_votes_path(votable_type: object.class.name, votable_id: object.uuid),
        votable_type: object.class.name,
        votable_id: object.uuid
      }
    end
  end

  def markdownify(content)
    context = {
    :asset_root => "http://a248.e.akamai.net/assets.github.com/images/icons/",
    :base_url   => root_url,
    :gfm => false
    }
    pipeline = HTML::Pipeline.new [
    HTML::Pipeline::MarkdownFilter,
    HTML::Pipeline::SanitizationFilter,
    HTML::Pipeline::EmojiFilter,
    HTML::Pipeline::MentionFilter
    ], context
    pipeline.call(content)[:output].to_s.html_safe
  end

  def linkify(content)
    context = {
    :asset_root => "http://a248.e.akamai.net/assets.github.com/images/icons/",
    :base_url   => root_url,
    :gfm => true
    }
    pipeline = HTML::Pipeline.new [
    HTML::Pipeline::MarkdownFilter,
    HTML::Pipeline::SanitizationFilter,
    HTML::Pipeline::EmojiFilter,
    HTML::Pipeline::MentionFilter
    ], context

    pipeline.call(content)[:output].to_s.html_safe
  end

  def sanitizify(content)
    context = {
    :asset_root => "http://a248.e.akamai.net/assets.github.com/images/icons/",
    :base_url   => root_url
    }
    pipeline = HTML::Pipeline.new [
    HTML::Pipeline::SanitizationFilter
    ], context

    pipeline.call(content)[:output].to_s.html_safe
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
