var PureRenderMixin = React.addons.PureRenderMixin;

var Like = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      css_class: this.props.css_class,
      voted: this.props.voted,
      vote_url: this.props.vote_url,
      votes_count: this.props.votes_count
    };
  },

  handleClick: function ( event ) {
    this.setState({ voted: !this.state.voted });
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: this.state.vote_url,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({ voted: data.voted });
        this.setState({ vote_url: data.url });
        this.setState({ votes_count: data.votes_count});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },


  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });
    var css_classes = this.state.css_class;

    if(this.state.voted) {
      var button_classes = css_classes + ' delete-vote'
    } else {
      var button_classes = css_classes
    }

    var text = this.state.voted ? 'Unlike' : 'Like';


    return (
      <a className={button_classes} onClick={this.handleClick}>
      {text} ({this.state.votes_count})
      <span className="count"></span>
      </a>

    );
  }

});
