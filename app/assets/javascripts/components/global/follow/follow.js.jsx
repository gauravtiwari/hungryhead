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
    var title_text =  this.state.follow ? 'Following' : 'Follow to receive updates';

    if(this.props.no_button){
       var classes = cx({
        'disabled': this.state.disabled,
        'following': this.state.follow
      });
    } else {
      var classes = cx({
        'main-button fs-13 bold pull-right text-white m-r-10': true,
        'disabled': this.state.disabled,
        'text-brand': !this.state.follow,
        'followed text-white semi-bold': this.state.follow
      });
    }

    if(this.state.follow) {
      var icon = <span><i className="fa fa-check-circle"></i></span>;
    } else {
      var icon = <i className="fa fa-user-plus"></i>;
    }

    return (
        <button data-toggle="tooltip" data-container="body" title={title_text} onClick={this.handleClick} className={classes}>
          {icon} <span className="hidden-xs">{text}</span>
        </button>
    );
  }

});
