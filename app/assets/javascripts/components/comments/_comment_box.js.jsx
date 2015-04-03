/** @jsx React.DOM */

var ComponentIsMountedMixin = {
    componentWillMount: function() {
        this.componentIsMounted = false;
    },
    componentDidMount: function() {
        this.componentIsMounted = true;
    },
    componentWillUnmount: function() {
        this.componentIsMounted = false;
    }, 
    safeSetState: function(newState) {
        if (this.componentIsMounted) {
            this.setState(newState);
        }
    }
};

var CommentBox = React.createClass({
  mixins: [ComponentIsMountedMixin],
  getInitialState: function () {
    var data = JSON.parse(this.props.data);
     return {
      comments: data.comments,
      form: data.form,
      loading: true,
      standalone: this.props.standalone,
      comments_path: this.props.comments_path,
      show_comment_bar: true,
      count: this.props.count,
      comment_loading: false,
      current_user: window.currentUser,
      text: "Load more comments",
      no_comments: ""
    }
  },

  componentDidMount: function() {
    if(this.isMounted()){
      this.setState({loading: false});
    }
    
  },

  handleCommentSubmit: function ( formData ) {
    this.setState({button_loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.comments_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        this.setState({visible: false});
        var new_comments = this.state.comments.concat(data.comment);
        this.setState({comments: new_comments.reverse(), count: this.state.count+1 });
        $("#comment_"+data.comment.id).effect('highlight', {color: '#f7f7f7'} , 3000);
        this.setState({button_loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  loadMoreComments: function() {
    var loadingText = <i className="ion-loading-d"></i>;
    this.setState({text: loadingText});
     $.get(this.state.comments_path, function(data){
      var new_comments = this.state.comments.concat(data.comments);
      this.setState({
        comments: new_comments, 
        comments_path: data.comments_path,
        text: "Load More comments"
      });
    }.bind(this));
  },

  loadComments: function() {
    this.setState({comment_loading: true});
    $.get(this.state.comments_path, function(data){
      this.setState({
        comments: data.comments, 
        comment_loading: false,
        comments_path: data.comments_path, 
        show_comment_bar: false
    });
    }.bind(this));
   },

  removeComment: function(key, id) {
    arr = _.without(this.state.comments, _.findWhere(this.state.comments, {id: id}));
    this.setState({comments: arr});
  },

  render: function () {
    var like = this.state.like;
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.button_loading
    });

    var comments_box = cx({
      'commentapp comment-box': true,
      'white-background': this.state.standalone
    });

    var comment_loading_classes = cx({
      'fa fa-spinner fa-spin': this.state.comment_loading
    });
    if(this.state.comments_path && !this.state.show_comment_bar) {
    var pagination =  <div className="pagination-box text-center show">
              <a onClick={this.loadMoreComments}><i className="ion-refresh"></i> {this.state.text}</a>
            </div>;
    } else {
      var pagination = "";
      var no_comments =  this.state.no_comments;
    }

    var text = this.state.count > 1 || this.state.count === 0 ? 'comments' : 'comment';

    if(this.state.comments.length <= 0 && this.state.count > 0 && this.state.show_comment_bar) {
      var show_comment_bar =  <div className="comments">
            <span><a className="border-bottom-dotted" onClick={this.loadComments}><i className={comment_loading_classes}></i> Show {this.state.count} {text}</a></span>
          </div>;
    }

    return (
      <div className={comments_box}>
        <CommentForm loading = {classes} form={ this.state.form } imgSrc = {this.state.current_user.avatar} onCommentSubmit={ this.handleCommentSubmit } />
        {show_comment_bar}
        <CommentList form={ this.state.form } onReplyCommentSubmit={ this.handleCommentSubmit } collapsed={this.state.collapsed} status={this.props.status} current_user = {this.state.current_user} comments={ this.state.comments } form={ this.state.form } removeComment = {this.removeComment} />
        {pagination}
        {no_comments}
      </div>
    )

    
  }
});
