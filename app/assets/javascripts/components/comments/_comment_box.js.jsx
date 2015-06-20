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
    if(this.isMounted()) {
      if(this.state.standalone) {
        this.loadComments();
      }
      var comment_channel = pusher.subscribe(this.props.comment_channel);
      if(comment_channel) {
        comment_channel.bind('new_comment', function(data){
          var response = JSON.parse(data.data);
          var comment = response.comment;
          if(presence_channel.members.me.id != comment.user_id) {
            var newState = React.addons.update(this.state, {
                comments : {
                  $unshift : [comment]
                }
            });
            this.setState(newState);
            $("#comment_"+comment.id).effect('highlight', {color: '#f7f7f7'} , 5000);
          }
          this.setState({count: this.state.count+1 });
        }.bind(this));
      }
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
        var comment = data.comment;
        var newState = React.addons.update(this.state, {
            comments : {
              $unshift : [comment]
            }
        });
        this.setState(newState);
        $("#comment_"+comment.id).effect('highlight', {color: '#f7f7f7'} , 5000);
        $('body textarea').trigger('autosize.destroy');
        this.setState({visible: false});
        this.setState({button_loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  loadMoreComments: function() {
    var loadingText = <i className="fa fa-spinner fa-spin"></i>;
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
      'standalone': this.state.standalone
    });

    var comment_loading_classes = cx({
      'fa fa-spinner fa-spin': this.state.comment_loading
    });
    if(this.state.comments_path && !this.state.show_comment_bar) {
    var pagination =  <div className="pagination-box text-center show padding-5">
              <a onClick={this.loadMoreComments} className="pointer"><i className="ion-refresh"></i> {this.state.text}</a>
            </div>;
    } else {
      var pagination = "";
      var no_comments =  this.state.no_comments;
    }

    var text = this.state.count > 1 || this.state.count === 0 ? 'comments' : 'comment';

    if(this.state.count > 0 && this.state.show_comment_bar && !this.state.standalone) {
      var show_comment_bar =  <div className="comments">
            <span><a className="b-b b-grey p-b-5 pointer" onClick={this.loadComments}><i className={comment_loading_classes}></i> Show {this.state.count} {text}</a></span>
          </div>;
    }

    if(this.props.standalone) {
      var heading = <h4 className="p-l-20 p-r-20"><i className="fa fa-comment-o"></i> Ask questions</h4>
    } else {
      var heading = "";
    }

    return (
      <div className={comments_box}>
        {heading}
        <CommentForm white={this.props.white || false}  loading = {classes} form={ this.state.form } imgSrc = {this.state.current_user.avatar} onCommentSubmit={ this.handleCommentSubmit } />
        <CommentList form={ this.state.form } standalone={this.props.standalone || false} onReplyCommentSubmit={ this.handleCommentSubmit } collapsed={this.state.collapsed} status={this.props.status} current_user = {this.state.current_user} comments={ this.state.comments } form={ this.state.form } removeComment = {this.removeComment} />
        {show_comment_bar}
        {pagination}
        {no_comments}
      </div>
    )


  }
});
