var CommentForm = React.createClass({
  getInitialState: function() {
    return {
      visible: false
    }
  },

  handleSubmit: function ( event ) {
    event.preventDefault();
    var body = this.refs.body.value.trim();
    if (!body) {
      return false;
    }
    var formData = $( this.refs.form ).serialize();
    this.props.onCommentSubmit(formData);
    this.refs.body.value = "";
    event.stopPropagation();
  },

  loadMentionables: function(e) {
    $(e.target).autosize();
    $(e.target).atwho({
      at:"@",
      data: Routes.mentionables_path(this.props.form.commentable_type, this.props.form.commentable_id),
      search_key: "username",
      insertTpl: '@${username}',
      displayTpl: "<li data-value='@${name}'>${name} <small>${username}</small></li>",
    });
    e.stopPropagation();
  },

  render: function () {
    var classes = classNames({
      'add-comment-form margin-left': true,
      'bg-white p-b-20': this.props.white
    });

    if(this.props.imgSrc) {
      var imgSrc = <img src={ this.props.imgSrc } width="40px" />;
    } else {
      var imgSrc = <span className="placeholder bold text-white">
                {currentUser.user_name_badge}
              </span>;
    }

    return (
    <article className={classes}>
     <div className="add-comment">
      <div className="user-pic  m-r-10 pull-left">
        {imgSrc}
      </div>
      <form ref="form" className="add-comment" acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit }>
        <textarea className="form-control empty" onFocus={this.loadMentionables} ref="body" name="comment[body]" placeholder="Write your comment..." autofocus />
        <input ref="commentable_id" type="hidden" value= { this.props.form.commentable_id } name= "comment[commentable_id]"/>
        <input ref="commentable_type" type="hidden" value= { this.props.form.commentable_type } name= "comment[commentable_type]" />
        <button type="submit" id="post_comment" className="main-button bold m-t-10 pull-right"><i className={this.props.loading}></i> <i className="fa fa-comment"></i> Post</button>
      </form>
      </div>
    </article>
    )
  }
});
