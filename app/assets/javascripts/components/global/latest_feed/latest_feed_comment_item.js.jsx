
var LatestFeedCommentItem = React.createClass({

  render: function() {
    return (
        <li className="p-b-15 fs-12 clearfix">
          <span className="inline">
            <a className="text-master hint-text" href={this.props.item.url}>
              <strong>{this.props.item.actor}</strong>
            </a>
            <span className="icon p-l-5"><i className="fa fa-comment"></i></span>
            <span className="verb p-l-5">
              {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              on {this.props.item.recipient}
            </span>
          <span className="date p-l-10 fs-11 text-danger">{moment(Date.parse(this.props.item.created_at)).fromNow()}</span>
          </span>
        </li>
      );
  }
});