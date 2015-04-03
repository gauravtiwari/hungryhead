/** @jsx React.DOM */

var InvestForm = React.createClass({

render: function() {
  var cx = React.addons.classSet;
  var classes = cx({
    'fa fa-spinner fa-spin': this.props.loading
  });

  return (
    <div className="pledge-information-popup">
    <article className="right">
        <div className="top">
        <h1>Accountability is important</h1>
        <p>Under state law, companies can raise funding from 35 un-accredited investors in MA, CA, and NY. </p>
        <a href="#">Learn more about accountability</a>
        </div>
      </article>
        <article className="left">
          <h1>Enter Amount</h1>
          <span className="label label-info">Your Virtual Balance is {this.props.idea.user_fund}</span>
          <form id="information-form" ref="invest_form"className="invest-form" onSubmit={this._onKeyDown}>
            <label htmlFor="amount">Investment amount</label>
            <input type="number" ref="amount" name="investment[amount]" className="form-control empty" id="amount" placeholder="Type amount" />
            <label htmlFor="note">Why are you investing?</label>
            <textarea ref="note" name="investment[note]" className="form-control empty" id="note" placeholder="Type here..." />
            <div className="invest-buttons">
              <button type="submit" id="update_section" className="main-button">
              <i className={classes}></i> Invest
              </button>
               <button type="button" className="main-button margin-left" data-dismiss="modal">Cancel</button>
            </div>
          </form>
        </article>
    </div>
  )
},
_onKeyDown: function(event) {
  event.preventDefault();
  var amount = this.refs.amount.getDOMNode().value.trim();
  var formData = $( this.refs.invest_form.getDOMNode() ).serialize();
  this.props.sendInvestment(formData, this.props.form.action, {amount: amount});
  this.refs.amount.getDOMNode().value = '';
  this.refs.note.getDOMNode().value = '';
}
});
