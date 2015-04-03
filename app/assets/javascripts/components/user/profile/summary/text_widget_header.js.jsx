/** @jsx React.DOM */

var TextWidgetHeader = React.createClass({

  render: function() {

    return(
      <div className="widget-title">
        <h4><i className="fa fa-book red-link"></i> Summary</h4>
        <a className="see-all" onClick={this.props.openForm}>{this.props.text}</a>
      </div>
    )
  }
});
