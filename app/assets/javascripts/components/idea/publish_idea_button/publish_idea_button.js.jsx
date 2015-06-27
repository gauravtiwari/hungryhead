/** @jsx React.DOM */

var PublishIdeaButton = React.createClass({
  getInitialState: function() {
    return {
      id: this.props.id,
      is_team: this.props.is_team,
      privacy: this.props.current_privacy,
      is_public: this.props.is_public,
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
    var text = this.state.published ? this.state.privacy : 'Private';
    var title = this.state.published ? 'Click to change privacy of your idea: ' : "Click to publish your idea";

    var cx = React.addons.classSet;
    var classes = cx({
      'btn dropdown-toggle fs-13 padding-5 p-l-10 p-r-10 m-r-10 pull-right': true,
      'privacy-team btn-info': !this.state.published,
      'privacy-public btn-success': this.state.published,
    });

    var icon_class = cx({
      "fa fa-lock": !this.state.published,
      "fa fa-globe": this.state.is_public,
      "fa fa-users": this.state.is_team,
      "fa fa-unlock-alt": this.state.published && !this.state.is_team && !this.state.is_public
    });

    return (
        <div className="btn-group dropdown-default" data-toggle="tooltip" data-placement="top" data-original-title={title}>
          <a data-toggle="dropdown" className={classes}><i className={icon_class}></i> {text}
            <span className="caret"></span>
          </a>
          <ul className="dropdown-menu">
            <li>
              <a className="pointer displayblock"  onClick={this.handleClick.bind(this, "school")}><i className="fa fa-university"></i> My School</a>
            </li>
            <li>
              <a className="pointer displayblock" onClick={this.handleClick.bind(this, "friends")}><i className="fa fa-users"></i> My Friends</a>
            </li>
            <li>
              <a className="pointer displayblock" onClick={this.handleClick.bind(this, "everyone")}><i className="fa fa-globe"></i> Everyone</a>
            </li>
            <li>
              <a className="pointer displayblock" onClick={this.handleClick.bind(this, "team")}><i className="fa fa-lock"></i> Private</a>
            </li>
          </ul>
        </div>

    )
  },

});
