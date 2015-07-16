var PureRenderMixin = React.addons.PureRenderMixin;

var Upvote = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      css_class: this.props.css_class,
      voted: this.props.voted,
      vote_url: this.props.vote_url,
      style: this.props.style,
      votes_count: this.props.votes_count,
      voters_path: this.props.voters_path
    };
  },

  loadVoters: function() {
    this.setState({loading: true});
    var path = this.props.voters_path;
    $('body').append($('<div>', {class: 'voters_list', id: 'listing_modal'}));
    React.render(
      <ModalListing path={path} key={Math.random()}  />,
      document.getElementById('listing_modal')
    );
    this.setState({loading: false});
    $('#modalListingPopup').modal('show');
    ReactRailsUJS.mountComponents();
  },

  handleClick: function (badge) {
      this.setState({voted: !this.state.voted});
      $.ajaxSetup({ cache: false });
      $.ajax({
        url: this.state.vote_url,
        type: "PUT",
        dataType: "json",
        success: function ( data ) {
          this.setState({ voted: data.voted });
          this.setState({ vote_url: data.url });
          this.setState({ votes_count: data.votes_count });
          $.pubsub('publish', 'update_vote_stats', data.votes_count);
          this.forceUpdate();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.vote_url, status, err.toString());
        }.bind(this)
      });
  },

  render: function() {
    var css_classes = this.state.css_class;

    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var button_classes = cx({
      'main-button fs-13 bold text-white m-r-10': true,
      'disabled': this.state.disabled,
      'text-brand': !this.state.voted,
      'voted text-white': this.state.voted
    });

    var text = this.state.voted ? 'You voted this' : 'Click to vote';
    var button_text = this.state.voted ? 'Voted' : 'Vote';
    var heart = this.state.voted ? <i className="fa fa-thumbs-up text-danger"></i> : <i className="fa fa-thumbs-o-up"></i>;

    var voter_text = this.state.votes_count > 1 ? 'people' : 'person';

    if(this.state.votes_count > 0) {
      var voters =<a onClick={this.loadVoters} className="m-l-5"><i className={classes}></i>{this.state.votes_count}</a>;
    }

    if(this.props.button_style) {
      return (
        <button onClick={this.handleClick} className={button_classes}>
          <i className="fa fa-thumbs-up"></i> {button_text}
        </button>
        )
    } else {
      return (<li className="inline text-black m-r-10 fs-14 bold pointer">
                <a data-toggle="tooltip" data-container="body" title={text} onClick={this.handleClick}>
                  {heart}
                </a>
                {voters}
              </li>

      );
    }
  }

});
