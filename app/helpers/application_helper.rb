module ApplicationHelper

  def notifications_count
    current_user.mailbox.notifications(read: false).length if current_user
  end

  def is_beta?
    false
  end

  def current_class?(test_path)
    return 'text-brand bold p-b-5 b-b b-grey' if request.path == test_path
    ''
  end

  def sub_menu_active?(test_path)
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
        follow: true
      }
    else
      followed = {
        follow: false
      }
    end
    followed.merge!(
      followable_type: object.class.name,
      followable_id: object.slug
    )
  end

  def voted?(object)
    if current_user && object.voted?(current_user)
      voted =  {
        vote: true
      }
    else
      voted = {
        vote: false
      }
    end
    voted.merge!(
      votes_count: object.votes_counter.value,
      path: voters_votes_path(votable_type: object.class.name, votable_id: object.uuid),
      votable_type: object.class.name,
      votable_id: object.uuid
    )
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

end
