/** @jsx React.DOM */

var TextWidgetHeader = React.createClass({

  render: function() {

    return(
	        <div className="panel-heading">
	            <div className="panel-title b-b b-grey p-b-5">
	                <i className="fa fa-user text-danger"></i> About me
	            </div>
	            <div className="panel-controls">
	                <ul>
	                    <li>
	                        <a onClick={this.props.openForm} className="portlet-collapse pointer">{this.props.text}</a>
	                    </li>
	                </ul>
	            </div>
	        </div>
    )
  }
});
