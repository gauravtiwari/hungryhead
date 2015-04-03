/** @jsx React.DOM */

var PublishProfileButton = React.createClass({
  getInitialState: function() {
    return {
      published: this.props.published,
      url: this.props.url,
      profile_complete: this.props.profile_complete,
      loading: false
    }
  },

  handleClick: function ( event ) {
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: this.state.url,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({ published: data.published, url: data.url });
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
    var text = this.state.published ? 'Published' : 'Publish Profile';
    var cx = React.addons.classSet;

     var classes = cx({
      'main-button': true,
      'disabled': this.state.disabled,
      'published': this.state.published
    });

    return (
      <a title={text} onClick={this.handleClick} className={classes} ><i className="ion-checkmark"></i> {text}</a>
    )
  },

});
