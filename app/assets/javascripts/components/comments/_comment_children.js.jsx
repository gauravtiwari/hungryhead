/** @jsx React.DOM */
var converter = new Showdown.converter();

var CommentChildren = React.createClass({
	getInitialState: function() {
    return  {comment: this.props.comment, liked: this.props.comment.like, likes_count: this.props.comment.votes, vote_url: this.props.comment.vote_url};
  },

  handleClick: function ( event ) {
    var likes_count = this.state.likes_count;
    this.setState({ liked: !this.state.liked });
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: this.state.vote_url,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({ liked: data.like });
        this.setState({ vote_url: data.url });
        this.setState({ likes_count: data.likes_count});
        this.setState({disabled: false});
        this.forceUpdate();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  handleDelete: function ( index, id) {
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.comment_path(id),
      type: "DELETE",
      dataType: "json",
      success: function ( data ) {
        this.props.removeChildrenComment(index)
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  showPostActions: function(event) {
    $(event.target).find('.post-actions').show();
  },

  hidePostActions: function(event) {
    $(event.target).find('.post-actions').hide();
  },


  render: function () {

    var text = this.state.liked ? 'Unlike' : 'Like';
    var comment = this.props.comment;
		var current_user = this.props.current_user;
    var comment_reply_id = "comment-reply-"+this.props.key;
    var comment_reply_button_id = "post-comment-reply-button"+this.props.key;
    var comment_id = "comment-"+this.props.key;
		if(comment.is_owner) {
			var deleteComment =  <li><a id="commentDelete" rel="delete" onClick={this.handleDelete.bind(this, this.props.index, this.props.key)}>Delete</a></li>;
		}

    var html_id = "comment_"+comment.id;
    var index = this.props.index;
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.deleting
    });

    var delete_text = this.state.sure ? 'Are you sure?' : '';

    var html_id = "comment_"+comment.id;
    var index = this.props.index;

    if(comment.is_owner) {
      if(this.state.sure) {
        var confirm_delete = <span>{delete_text} <a onClick={this.handleDelete.bind(this, index, comment.id)}><i className={classes}></i> confirm</a> or <a onClick={this.cancelDelete}> cancel</a></span>;
      } else {
        var confirm_delete = <a onClick={this.checkDelete}><i className="ion-trash-b"></i> {delete_text}</a>;
      }       
    }

  var html = converter.makeHtml(this.props.comment.comment);

  return (
    		<li key={this.props.key} className="comment" id={html_id} onMouseEnter={this.showPostActions} onMouseLeave={this.hidePostActions}>
         <div className="box-generic">
          <div className="timeline-top-info" id={html_id}>
          <div className="user-avatar margin-right">
            <a href="javascript:void(0)" data-popover-href={this.state.comment.user_url} className='load-card'><img width="40px" src={ this.state.comment.avatar } /></a>
             </div> 
              <div className="comment-body">
                  <span>
                  <span dangerouslySetInnerHTML={{__html: html}}></span></span>
                  <div className="timeline-bottom">
                    <ul className="social-actions">
                      <li><Like vote_button={false} css_class="like-link" voted= {this.state.comment.voted}  vote_url = {this.state.comment.vote_url} votes_count= {this.state.comment.votes_count} /></li>
                      <li><span><em>{LocalTime.relativeTimeAgo(new Date(this.state.comment.created_at))}</em> </span></li>
                    </ul>
                     <div className="post-actions float-right">
                      {confirm_delete}
                    </div>
                  </div>
              </div>
            </div>
          </div>
        </li>

    )
  }
});