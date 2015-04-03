/** @jsx React.DOM */

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
        var options =  {
          content: ""+data.msg+"",
          style: "notice",
          timeout: 10000
        }
        $.snackbar(options);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    var text = this.state.is_public && this.state.published ? 'Published' : 'Team';
    var title = this.state.is_public ? 'Visible to everyone on Hungryhead' : 'Private, visible only to team members';
    
    var cx = React.addons.classSet;
    var classes = cx({
      'main-button': true,
      'privacy-team': !this.state.is_public,
      'privacy-public': this.state.is_public
    });

    var icon_class = cx({
      "ion-locked": !this.state.is_public,
      "ion-unlocked": this.state.is_public
    });

    return (
        <a data-toggle="tooltip" data-placement="top" data-original-title={title} onClick={this.handleClick} className={classes} ><i className={icon_class}></i> {text}</a>
    )
  },

});
