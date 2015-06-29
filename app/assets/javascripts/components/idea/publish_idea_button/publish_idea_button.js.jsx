/** @jsx React.DOM */

var PublishIdeaButton = React.createClass({
  getInitialState: function() {
    return {
      id: this.props.id,
      is_team: this.props.is_team,
      privacy: this.props.current_privacy,
      is_public: this.props.is_public,
      is_friends: this.props.is_friends,
      is_school: this.props.is_school,
      loading: false,
      published: this.props.published,
      profile_complete: this.props.profile_complete,
      loading: false
    }
  },

  componentDidMount: function() {
    $('[data-toggle="tooltip"]').tooltip();
  },

  handleClick: function ( action ) {
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.publish_idea_path(this.state.id, {privacy: action}),
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({
         privacy: data.current_privacy,
         is_public: data.is_public,
         is_friends: data.is_friends,
         is_school: data.is_school,
         is_team: data.is_team,
         published: data.published,
         url: data.url
       });
        this.setState({disabled: false});
        $('body').pgNotification({style: "bouncy", message: data.msg, position: "bottom-left", type: "info",timeout: 5000}).show();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    var text = this.state.published ? this.state.privacy : 'Publish Idea';
    var title = this.state.published ? 'Click to change, currently visible to your: ' : "Click to publish";

    var cx = React.addons.classSet;
    var classes = cx({
      'btn dropdown-toggle privacy fs-13 padding-5 p-l-10 p-r-10 m-r-10 pull-right': true,
      'privacy-team btn-info': !this.state.published,
      'privacy-public btn-success': this.state.published,
    });

    var icon_class = cx({
      "fa fa-lock": !this.state.published,
      "fa fa-globe": this.state.is_public && this.state.published,
      "fa fa-users": this.state.is_friends && this.state.published,
      "fa fa-building": this.state.is_team && this.state.published,
      "fa fa-university": this.state.is_school && this.state.published
    });

    return (
        <div className="dropdown" data-toggle="tooltip" title={title}>
         <button className={classes} type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span><i className={icon_class}></i> {text} <span className="caret"></span></span>
         </button>
          <ul className="dropdown-menu privacy no-padding" role="menu">
            <li className="small padding-10 b-b b-grey">Who should see your idea?</li>
            <li>
              <a className="pointer displayblock"  onClick={this.handleClick.bind(this, "school")}>
                <i className="fa fa-university m-r-5"></i>My School {this.state.is_school ? <i className="fa fa-check-circle text-brand"></i> : ""}
                <span className="privacy-info-text">Everyone in your university</span>
              </a>
            </li>
            <li>
              <a className="pointer displayblock" onClick={this.handleClick.bind(this, "friends")}>
                <i className="fa fa-users m-r-5"></i>My Friends {this.state.is_friends ? <i className="fa fa-check-circle text-brand"></i> : ""}
                <span className="privacy-info-text">People your are following </span>
              </a>
            </li>
            <li>
              <a className="pointer displayblock" onClick={this.handleClick.bind(this, "everyone")}>
                <i className="fa fa-globe m-r-5"></i>Everyone {this.state.is_public ? <i className="fa fa-check-circle text-brand"></i> : ""}
                <span className="privacy-info-text">Everyone on hungryhead</span>
              </a>
            </li>
            <li>
              <a className="pointer displayblock" onClick={this.handleClick.bind(this, "team")}>
                <i className="fa fa-lock m-r-5"></i>Private {this.state.is_team ? <i className="fa fa-check-circle text-brand"></i> : ""}
                <span className="privacy-info-text">You and your team</span>
              </a>
            </li>
          </ul>
        </div>

    )
  },

});
