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
        'btn btn-cons pull-right no-padding padding-5 p-l-10 p-r-10 m-r-10': true,
        'disabled': this.state.disabled,
        'btn-complete': !this.state.follow,
        'btn-success': this.state.follow
      });
    }

    return (
        <button onClick={this.handleClick} className={classes} title="Follow"><i className="fa fa-user-add"></i> {text}</button>
    );
  }

});
