/** @jsx React.DOM */

var ChildCommentForm = React.createClass({
  getInitialState: function() {
    return {
      visible: false
    }
  },

  handleSubmit: function ( event ) {
    event.preventDefault();
    var body = this.refs.body.getDOMNode().value.trim();
  
    // validate
    if (!body) {
      return false;
    }

    // submit
    var formData = $( this.refs.form.getDOMNode() ).serialize();
    this.props.onReplyCommentSubmit(formData);

    // reset form;
    this.refs.body.getDOMNode().value = "";
    event.stopPropagation();
  },

  loadMentionables: function(e) {
    $(e.target).autosize();
    $.get(Routes.mentionables_path(this.props.comment.commentable_type, this.props.comment.commentable_id), function(data){  
      $('textarea').atwho({
        at:"@", 
        'data':data, 
        search_key: "username", 
        insertTpl: '@${username}',
        displayTpl: "<li data-value='@${name}'>${name} <small>${username}</small></li>",
      });
    }.bind(this));
  },

  
  render: function () {
    var cx = React.addons.classSet;
    var classes = cx({
      'add-reply-comment-form': true
    });

    return (
    <article className={classes}>
      <div className="user-avatar margin-right">
        <img alt={ window.currentUser.name } src={ window.currentUser.avatar } width="40px" />
      </div>
     <div className="add-comment">
      <form ref="form" className="add-comment" acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit }>
        <input type="hidden" name={ window.currentUser.csrf_param } value={ window.currentUser.csrf_token } />
        <p><textarea onClick={this.loadMentionables} ref="body" name="comment[body]" placeholder="Reply to this comment..." autofocus /></p>
        <input ref="commentable_id" type="hidden" value= { this.props.comment.commentable_id } name= "comment[commentable_id]"/>
        <input ref="parent_id" type="hidden" value= { this.props.comment.id } name= "comment[parent_id]"/>
        <input ref="commentable_type" type="hidden" value= { this.props.comment.commentable_type } name= "comment[commentable_type]" /> 
        <button type="submit" id="post_comment" className="main-button"><i className={this.props.loading}></i> Post</button>
      </form>
      </div>
    </article>
    )
  }
});
