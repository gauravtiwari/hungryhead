class PostMailer < ActionMailer::Base

  def new_post(post, user, recipient)
    @user = user
    @post = post
    @recipient = recipient
    @subject = "Your friend #{@user.name} shared a post - #{@post.title}"
    mail(:from => @user.email, :to => @recipient.email, :subject => @subject)
  end

end