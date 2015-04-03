/**
 * @jsx React.DOM
 */

var Trash = React.createClass({

  getInitialState: function() {
    return {
      loading: false, 
      sure: false
    }
  },

 handleClick: function (badge) {
      this.setState({sure: false});
      this.setState({loading: true});
      $.ajaxSetup({ cache: false });
      $.ajax({
        url: this.props.delete_url,
        type: "DELETE",
        dataType: "json",
        success: function ( data ) {
          this.setState({loading: false});
          if(data.deleted){
            var options =  {
              content: data.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);

            $('.post_'+this.props.record).addClass('animated fadeOutUp').remove();
          } else if(data.error) {
             var options =  {
              content: data.error.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
          }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.vote_url, status, err.toString());
        }.bind(this)
      });
  },

  checkDelete: function() {
    this.setState({sure: true});
  },

  cancelDelete: function() {
    this.setState({sure: false});
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var text = this.state.sure ? 'Are you sure?' : '';

    if(this.state.sure) {
      var confirm_delete = <span>{text} <a onClick={this.handleClick}><i className={classes}></i> confirm</a> or <a onClick={this.cancelDelete}> cancel</a></span>;
    } else {
      var confirm_delete = <a onClick={this.checkDelete}><i className="ion-trash-b"></i> {text}</a>;
    }
 
    return (
      <div>
        {confirm_delete}
      </div>
    );
  }

});
