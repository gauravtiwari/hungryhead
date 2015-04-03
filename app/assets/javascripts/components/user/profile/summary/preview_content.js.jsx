/** @jsx React.DOM */

var PreviewContent = React.createClass({
	render:function() {
		return (
				<div className="preview-content">
        			<div dangerouslySetInnerHTML={{__html: this.props.content}}>
                    </div>
				</div>
			)
	}
})