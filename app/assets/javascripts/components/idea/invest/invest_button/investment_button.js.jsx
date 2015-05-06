/**
* @jsx React.DOM
*/
var InvestButton = React.createClass({

  getInitialState: function () {
    return {loading: false, invested: this.props.invested};
  },

  openInvestBox: function () {
    this.setState({loading: true});
    $('body').append($('<div>', {class: 'investment_modal', id: 'investment_modal'}));
    React.render(
      <Invest idea={this.props.idea} key={Math.random()}  />,
      document.getElementById('investment_modal')
    );
    this.setState({loading: false});
    $("#investPopup").modal('show');
  },

  componentDidMount: function(){
    var self = this;
    $.pubsub('subscribe', 'idea_invested', function(msg, data){
      self.setState({invested: false});
    });
  },

  openInvestedBox: function() {
    swal({
      title: "Error!",
      text: "Hey! You have already invested",
      type: "error",
      confirmButtonText: "",
      timer: 2000
    });
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-dollar': true
    });

    var invested_classes = cx({
      'btn btn-cons padding-5 pull-right m-r-10': true,
      'btn-info': !this.state.invested,
      'btn-green text-white semi-bold': this.state.invested
    });

    if(this.state.invested) {
      var buttonText = <a className={invested_classes} onClick={this.openInvestedBox}><i className={classes}></i> Invested</a>;
    } else {
      var buttonText = <a className={invested_classes} onClick={this.openInvestBox}><i className={classes}></i> Invest</a>;
    }

    return(
      buttonText
    )
  }
});
