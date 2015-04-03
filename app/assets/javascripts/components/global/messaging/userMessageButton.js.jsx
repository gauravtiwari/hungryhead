/**
 * @jsx React.DOM
 */


var UserMessageButton = React.createClass({

  getInitialState: function () {
    return {
      loading: false,
      conversation: []
    };
  },
  loadConversation: function(){
    this.setState({loading: true});
    React.render(<UserMessage key={this.props.id} source={this.props.source} />,
          document.getElementById('conversation-chat-box'))
    $("#modalPopup").modal('show');
    this.setState({loading: false});
  },
  openMessageBox: function () {
    this.loadConversation();
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });
    return(
        <a className="main-button send-message" onClick={this.openMessageBox}><i className={classes}></i> Message</a>
      )
  }
});

var Messaging = React.createClass({
  getInitialState: function(){
    return {
      conversation: [],
      ready: false
    };
  },

  render: function() {
    return (
      <div>
       <UserMessageButton source={this.props.source} isReady={this.isReady} />
      </div>
    );
  }

});
