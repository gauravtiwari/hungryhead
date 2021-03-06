var PureRenderMixin = React.addons.PureRenderMixin;

var Like = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      css_class: this.props.css_class,
      voted: this.props.voted.vote,
      vote_url: this.props.vote_url,
      votes_count: this.props.votes_count
    };
  },

  handleClick: function ( event ) {
    this.setState({ voted: !this.state.voted });
    this.setState({ votes_count: this.state.votes_count + 1});
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.vote_votes_path({
        votable_type: this.props.voted.votable_type,
        votable_id: this.props.voted.votable_id
      }),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        this.setState({ voted: data.vote });
        this.setState({ votes_count: data.votes_count});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  handleDelete: function ( event ) {
    this.setState({ voted: !this.state.voted });
    this.setState({ votes_count: this.state.votes_count - 1});
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.unvote_votes_path({
        votable_type: this.props.voted.votable_type,
        votable_id: this.props.voted.votable_id
      }),
      type: "DELETE",
      dataType: "json",
      success: function ( data ) {
        this.setState({ voted: data.vote });
        this.setState({ votes_count: data.votes_count});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },


  render: function() {
    var classes = classNames({
      'fa fa-spinner fa-spin': this.state.loading
    });
    var css_classes = this.state.css_class;

    if(this.state.voted) {
      var button_classes = css_classes + ' delete-vote' + ' pointer'
    } else {
      var button_classes = css_classes + ' pointer'
    }

    var text = this.state.voted ? 'Likes' : 'Like';

    if(this.state.votes_count == 0) {
      var votes_count = "";
    } else {
      var votes_count = '(' + this.state.votes_count + ')';
    }

    return (
      <a className={button_classes} onClick={this.state.voted? this.handleDelete : this.handleClick}>
      {text}  {votes_count}
      <span className="count"></span>
      </a>

    );
  }

});
