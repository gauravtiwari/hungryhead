/** @jsx React.DOM */

var Invest = React.createClass({

  getInitialState: function() {
    return {
      idea: this.props.idea,
      mode: false,
      amount: 0,
      loading: false
    }
  },

  sendInvestment: function(formData, action, amount) {
    this.setState({amount: amount.amount});
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        this.setState({idea: data.idea});
        this.setState({mode: false});
        this.setState({loading: false});
        $("#investPopup").modal('hide');
        $.pubsub('publish', 'idea_invested', true);
        var options =  {
          content: "<img width='40px' src="+data.idea.user_avatar+"> <span>You have successfully invested "+data.idea.amount+ " coins into " + data.idea.name +"</span>",
          style: "snackbar",
          timeout: 3000
        }
        $.snackbar(options);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    if(this.state.idea.can_invest) {
      var content =   <div className="modal-body">
      <InvestForm loading= {this.state.loading} form={this.state.idea.form} sendInvestment= {this.sendInvestment} idea={this.state.idea} />
      </div>;
    } else {
      var content = <NoBalance />;
    }

    return (
      <div className="investapp invest-box">
        <div className="modal fade" tabIndex="-1" role="dialog" id="investPopup" aria-labelledby="investlPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
          <div className="modal-dialog modal-lg">
            <div className="modal-content">
              <div className="profile-wrapper-title">
               <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
                <h4><i className="fa fa-dollar"></i> Invest in {this.state.idea.name }</h4>
              </div>
              {content}
          </div>
          </div>
        </div>
      </div>
    )
  }
});
