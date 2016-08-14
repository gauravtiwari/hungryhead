var TextWidgetContent = React.createClass({

  render: function() {
    var classes = classNames({
      'panel-body p-t-10': true,
      'hidden': this.props.mode,
      'show': !this.props.mode,
    });
    if(this.props.content) {
      return(
        <div className={classes} dangerouslySetInnerHTML={{__html: this.props.content}}>
        </div>
      )
    } else {
      return(
      <div className="no-content">Please publish your summary </div>
      )
    }
  }
});
