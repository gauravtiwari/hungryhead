module ConversationsHelper
  def mailbox_section(title, current_box, mailbox, opts = {})
    opts[:class] = opts.fetch(:class, 'mailbox')
    opts[:class] += ' active' if title.downcase == current_box
    content_tag :li, link_to(title.capitalize + " (#{ mailbox.length})", conversations_path(box: title.downcase)), opts
  end
end