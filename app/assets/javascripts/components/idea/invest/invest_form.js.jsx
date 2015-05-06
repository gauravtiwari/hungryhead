/** @jsx React.DOM */

var InvestForm = React.createClass({

componentDidMount: function(){
  var self = this;
  $.pubsub('subscribe', 'idea_invested', function(msg, data){
    self.refs.amount.getDOMNode().value = '';
    self.refs.note.getDOMNode().value = '';
  });
},

render: function() {
  var cx = React.addons.classSet;
  var classes = cx({
    'fa fa-spinner fa-spin': this.props.loading
  });

  return (
    <form id="information-form" role="form" noValidate="novalidate" acceptCharset="UTF-8" ref="invest_form" onSubmit={this._onKeyDown}>
       <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
       <h5>Your available funds are: {this.props.idea.user_fund}</h5>
       <div className="form-group">
           <div className="row">
               <div className="form-group">
                <div className="col-md-12">
                  <label>Virtual amount</label>
                  <input ref="amount" name="investment[amount]" className="form-control required" id="amount" placeholder="Type amount ex: 200" type="text" required aria-required="true"/>
                </div>
                </div>
                <div className="form-group">
                <div className="col-md-12 p-t-10">
                  <label htmlFor="note">Add investment note <span className="small text-danger">(*optional)</span></label>
                  <textarea ref="note" name="investment[note]" className="form-control empty" id="note" placeholder="Type here..." />
                </div>
               </div>
               <p className="hint-text small clearfix p-t-10">
                 <i className="fa fa-info-circle m-r-5"></i>
                 Investing in early stage ideas involves risks therefore, <span className="bold">invest wisely</span>.
                 <a className="inline m-l-5" onClick={this.readmoreInvestment}>Read More</a>
               </p>
               <div className="col-md-6 pull-right m-t-15">
                  <button type="submit" id="update_section" className="btn btn-success pull-right">
                  <i className={classes}></i> Invest
                  </button>
                  <button type="button" className="btn btn-danger m-r-10 pull-right" data-dismiss="modal">Cancel</button>
               </div>
           </div>
       </div>
   </form>
  )
},

readmoreInvestment: function() {
  $('body').append($('<div>', {class: 'readmore_investment', id: 'readmore_investment'}));
  React.render(
    <ReadMoreInvestment key={Math.random()} />,
    document.getElementById('readmore_investment')
  );
  $('#readmoreInvestmentPopup').modal('show');
},
_onKeyDown: function(event) {
  event.preventDefault();
  var amount = this.refs.amount.getDOMNode().value.trim();
  var formData = $( this.refs.invest_form.getDOMNode() ).serialize();
  if($(this.refs.invest_form.getDOMNode()).valid()) {
    this.props.sendInvestment(formData, this.props.form.action, {amount: amount});
  }
}
});
