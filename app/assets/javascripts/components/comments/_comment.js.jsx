/** @jsx React.DOM */
var converter = new Showdown.converter();
var Comment = React.createClass({
  getInitialState: function() {
    return  {
      liked: this.props.comment.like, 
      comment: this.props.comment, 
      vote_url: this.props.comment.vote_url, 
      likes_count: this.props.comment.votes,
      sure: false,
      deleting: false
    };
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

  handleDelete: function (index, id) {
    this.setState({deleting: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.comment_path(id),
      type: "DELETE",
      dataType: "json",
      success: function ( data ) {
        this.setState({deleting: false});
        this.setState({sure: false});
        if(data.deleted){
            var options =  {
              content: data.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
            this.props.removeComment(index, id);
          } else if(data.error) {
             var options =  {
              content: data.error.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
          }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  cancelDelete: function() {
    this.setState({sure: false});
  },

  checkDelete: function() {
    this.setState({sure: true});
  },

  showPostActions: function(event) {
    $(event.target).find('.post-actions').show();
  },

  hidePostActions: function(event) {
    $(event.target).find('.post-actions').hide();
  },

  render: function () {
    var text = this.state.liked ? 'Unlike' : 'Like';
    var comment = this.state.comment;

    var cx = React.addons.classSet;

    var replies_count = [];
    var commentChildNodes = _.map(comment.childrens, function ( children, index ) {
      if(children.created_at !== 'undefined') {
        var date = moment(children.created_at).fromNow();
      } else {
        var now = moment()._d;
        var date = moment(now).fromNow();
      }

      if(comment.id == children.parent_id) {
        replies_count.push(children);
        return  <CommentChildren index = {index} comment = {children} removeChildrenComment = {this.removeChildrenComment} key={ children.id } />
      }

    });


    var deleteClass = cx({
      'fa fa-spinner fa-spin': this.state.deleting
    });

    if(this.state.likes_count) {
      var likes_count = '('+this.state.likes_count + ')';
    }

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

    var html = converter.makeHtml(this.state.comment.comment);

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
                      <li> <a className='like-link' onClick={this.openReplyForm}>
                        Reply
                        <span className="count">{replies_count.length}</span>
                      </a></li>
                      <li><span className="count"><em>{LocalTime.relativeTimeAgo(new Date(this.state.comment.created_at))}</em> </span></li>
                    </ul>
                     <div className="post-actions float-right">
                      {confirm_delete}
                    </div>
                  </div>
              </div>
            </div>
          </div>
          <ul className="comment-replies" id={html_id}>
            {commentChildNodes}
            <ChildCommentForm onReplyCommentSubmit={this.props.onReplyCommentSubmit} comment={this.state.comment} />
          </ul>
        </li>

    )
  }
});
