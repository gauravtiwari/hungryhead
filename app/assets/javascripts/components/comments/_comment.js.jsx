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
            $('body').pgNotification({style: "simple", message: data.message, position: "top-right", type: "success",timeout: 5000}).show();
            this.props.removeComment(index, id);
          } else if(data.error) {
            $('body').pgNotification({style: "simple", message: data.error.message, position: "top-right", type: "danger",timeout: 5000}).show();
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
        var confirm_delete = <span>{delete_text} <a className="text-danger" onClick={this.handleDelete.bind(this, index, comment.id)}><i className={classes}></i> confirm</a> or <a onClick={this.cancelDelete}> cancel</a></span>;
      } else {
        var confirm_delete = <a className="text-danger" onClick={this.checkDelete}><i className="fa fa-trash-o"></i> {delete_text}</a>;
      }       
    }

    if(this.state.comment.avatar) {
      var imgSrc = <img width="40px" src={ this.state.comment.avatar } />;
    } else {
      var imgSrc = <span className="placeholder bold text-white">
                {this.state.comment.user_name_badge}
              </span>;
    }

    var html = converter.makeHtml(this.state.comment.comment);

    return (
       <li key={this.props.key} className="comment padding-10 fs-12 p-b-10" id={html_id} onMouseEnter={this.showPostActions} onMouseLeave={this.hidePostActions}>
         <div className="box-generic">
            <div className="user-pic m-r-10 pull-left inline">
              <a href="javascript:void(0)" data-popover-href={this.state.comment.user_url} className='load-card'>
                {imgSrc}
              </a>
            </div> 
          <div className="timeline-top-info" id={html_id}>
            <div className="comment-body">
                <span>
                <span dangerouslySetInnerHTML={{__html: html}}></span></span>
                <div className="timeline-bottom">
                  <ul className="social-actions no-style no-padding m-t-5">
                    <li><Like vote_button={false} css_class="like-link pull-left p-r-10 b-r b-grey b-dashed" voted= {this.state.comment.voted}  vote_url = {this.state.comment.vote_url} votes_count= {this.state.comment.votes_count} /></li>
                    <li className='like-link pull-left p-l-10'><span className="count">{moment(this.state.comment.created_at).fromNow()}</span></li>
                  </ul>
                   <div className="post-actions pull-right">
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
