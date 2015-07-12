var PublishIdeaButton = React.createClass({
  getInitialState: function() {
    return {
      url: this.props.url,
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

  handleClick: function ( event ) {
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: this.state.url,
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
        $('body').pgNotification({style: "simple", message: data.msg, position: "bottom-left", type: "danger",timeout: 5000}).show();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    var text = this.state.is_public && this.state.published ? 'Published' : 'Private';
    var title = this.state.is_public ? 'Visible to everyone on Hungryhead' : 'Private, visible to you and team members. Click to publish.';

    var cx = React.addons.classSet;
    var classes = cx({
      'main-button pointer fs-13 m-r-10 bold pull-right': true,
      'privacy-team': !this.state.is_public,
      'privacy-public bg-green text-white': this.state.is_public
    });

    var icon_class = cx({
      "fa fa-lock": !this.state.is_public,
      "fa fa-unlock-alt": this.state.is_public
    });

    return (
        <a data-toggle="tooltip" data-placement="top" data-original-title={title} onClick={this.handleClick} className={classes} >
          <i className={icon_class}></i> {text}
        </a>
    )
  },

});