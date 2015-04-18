/** @jsx React.DOM */
var CommentList = React.createClass({
  render: function () {

    var comments = this.props.comments;
    var form = this.props.form;
    var vote_url = this.props.vote_url;
    var current_user = this.props.current_user;
    var votes = this.props.votes;
    var loading = this.props.loading;
    var handleUpdate = this.props.handleUpdate;
    var status = this.props.status;
    var removeComment = this.props.removeComment;
    var css_id = this.props.form.commentable_type+"-comments-"+this.props.form.commentable_id;
    var onReplyCommentSubmit= this.props.onReplyCommentSubmit;
    var commentNodes = comments.map(function ( comment, index ) {
      if(comment.created_at !== 'undefined') {
        var date = comment.created_at
      }
      return  <Comment form={form} onReplyCommentSubmit={onReplyCommentSubmit} status={status} current_user = {current_user} index = {index} removeComment = {removeComment} comment = {comment} key={comment.uuid} />

    });

    return (

      <ul id={css_id} className="comment-list timeline-activity list-unstyled" ref="commentList">
       { commentNodes }
      </ul>

    )
  },
  componentDidUpdate: function() {
    this._scrollToBottom();
  },


  _scrollToBottom: function() {
    var ul = this.refs.commentList.getDOMNode();
    ul.scrollTop = ul.scrollHeight;
  }

});
