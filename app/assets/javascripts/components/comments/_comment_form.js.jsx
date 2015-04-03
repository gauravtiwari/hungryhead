/** @jsx React.DOM */

var CommentForm = React.createClass({
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
    this.props.onCommentSubmit(formData);

    // reset form;
    this.refs.body.getDOMNode().value = "";
    event.stopPropagation();
  },

  loadMentionables: function(e) {
    $(e.target).autosize();
    $.get(Routes.mentionables_path(this.props.form.commentable_type, this.props.form.commentable_id), function(data){  
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
      'add-comment-form margin-left': true
    });

    return (
    <article className={classes}>
      <div className="user-avatar margin-right">
        <img src={ this.props.imgSrc } width="40px" />
      </div>
     <div className="add-comment">
      <form ref="form" className="add-comment" acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit }>
        <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
        <p><textarea onClick={this.loadMentionables} ref="body" name="comment[body]" placeholder="Write your comment..." autofocus /></p>
        <input ref="commentable_id" type="hidden" value= { this.props.form.commentable_id } name= "comment[commentable_id]"/>
        <input ref="commentable_type" type="hidden" value= { this.props.form.commentable_type } name= "comment[commentable_type]" /> 
        <button type="submit" id="post_comment" className="main-button"><i className={this.props.loading}></i> Post</button>
      </form>
      </div>
    </article>
    )
  }
});
