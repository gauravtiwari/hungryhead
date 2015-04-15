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
            $('body').pgNotification({style: "simple", message: data.message, position: "top-right", type: "success",timeout: 5000}).show();
            $('.post_'+this.props.record).addClass('animated fadeOutUp').remove();
          } else if(data.error) {
            $('body').pgNotification({style: "simple", message: data.error.message, position: "top-right", type: "danger",timeout: 5000}).show();
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
      var confirm_delete = <span className="text-master">{text} <a className="text-danger" onClick={this.handleClick}><i className={classes}></i> confirm</a> or <a onClick={this.cancelDelete}> cancel</a></span>;
    } else {
      var confirm_delete = <a className="text-danger" onClick={this.checkDelete}><i className="fa fa-trash-o"></i> {text}</a>;
    }
 
    return (
      <div className="text-master">
        {confirm_delete}
      </div>
    );
  }

});
