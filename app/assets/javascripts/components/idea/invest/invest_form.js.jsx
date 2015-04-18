/** @jsx React.DOM */

var InvestForm = React.createClass({

render: function() {
  var cx = React.addons.classSet;
  var classes = cx({
    'fa fa-spinner fa-spin': this.props.loading
  });

  return (
    <form id="information-form" role="form" noValidate="novalidate" acceptCharset="UTF-8" ref="invest_form" onSubmit={this._onKeyDown}>
       <div className="form-group">
           <div className="row">
               <div className="col-md-12">
                   <div className="form-group form-group-default">
                       <label>Investment amount</label>
                       <input ref="amount" name="investment[amount]" className="form-control required" id="amount" placeholder="Type amount" type="text" required aria-required="true"/>
                   </div>
               </div>
               <div className="col-md-6 pull-right">
                  <button type="submit" id="update_section" className="btn btn-success m-r-10 pull-right">
                  <i className={classes}></i> Invest
                  </button>
                  <button type="button" className="btn btn-danger m-r-10 pull-right" data-dismiss="modal">Cancel</button>
               </div>
           </div>
       </div>
   </form>
  )
},
_onKeyDown: function(event) {
  event.preventDefault();
  var amount = this.refs.amount.getDOMNode().value.trim();
  var formData = $( this.refs.invest_form.getDOMNode() ).serialize();
  if($(this.refs.invest_form.getDOMNode()).valid()) {
    this.props.sendInvestment(formData, this.props.form.action, {amount: amount});
    this.refs.amount.getDOMNode().value = '';
  }
}
});
