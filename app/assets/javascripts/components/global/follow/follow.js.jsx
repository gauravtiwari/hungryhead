/** @jsx React.DOM */

var Follow = React.createClass({
  getInitialState: function() {
    return {
      followed: this.props.followed,
      follow: this.props.followed.follow
    };
  },

  componentDidMount: function() {
    this.setState({disabled: false});
  },

  handleClick: function ( event ) {
    this.setState({ follow: !this.state.follow });
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.follows_path({
        followable_type: this.state.followed.followable_type,
        followable_id: this.state.followed.followable_id
      }),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        this.setState({ follow: data.follow });
        this.setState({ url: data.url });
        this.setState({disabled: false});
        $.pubsub('publish', 'update_followers_stats', data.followers_count);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },
  render: function() {
    var text = this.state.follow ? 'Following' : 'Follow';
    var cx = React.addons.classSet;
    if(this.props.no_button){
       var classes = cx({
        'disabled': this.state.disabled,
        'following': this.state.follow
      });
    } else {
      var classes = cx({
        'btn btn-sm fs-13 padding-5 pull-right text-white m-r-10': true,
        'disabled': this.state.disabled,
        'btn-info': !this.state.follow,
        'btn-green semi-bold': this.state.follow
      });
    }

    return (
        <button onClick={this.handleClick} className={classes} title="Follow">
          <i className="fa fa-user-plus"></i> {text}
        </button>
    );
  }

});
