/** @jsx React.DOM */

var MarketForm = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'market-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

    var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

     if(this.props.idea.sections && this.props.idea.sections.market) {
      var market = this.props.idea.sections.market;
     } else {
      var market = "";
     }

    return (
      <div className={classes}>
         <form id="market-edit-form" ref="market_form" className="market-edit-form" onSubmit={this._onKeyDown}>
             <input type="hidden"  name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
             <label className="margin-bottom">Describe the market for your idea. <span>Estimated numbers? Any metrices? etc.</span> You can link images. </label>
             <textarea ref="description" className="form-control empty" defaultValue={market} name="idea[market]" placeholder='Describe your market' autofocus/>
             <div className="form-buttons send-button">
              <div>
                <button type="submit" id="post_feedback_message" className="main-button"><i className={loading_class}></i> Save </button>
              </div>
            </div>
          </form>
      </div>
    )
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      var formData = $( this.refs.market_form.getDOMNode() ).serialize();
      this.props.handleMarketSubmit(formData, {text: this.refs.description.getDOMNode().value});
  }

});

