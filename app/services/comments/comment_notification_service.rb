class CommentNotificationService
	
	def initialize(comment, commentable, user, profile_url)
		@comment = comment
		@user = user
		@commentable = commentable
		@profile_url = profile_url
	end

	def notify
	  if @commentable.class.to_s == "Idea"
        commenter = @commentable.student
      else 
        commenter = @commentable.user
      end
      if @user != commenter
        NewCommentNotificationJob.perform_later(@user, @commentable, msg)
      end
	end

	def msg
		 msg = "<a href='#{@profile_url}'>#{@user.name}</a> commented your " + "#{@commentable.class.to_s.downcase}".html_safe
	end

end