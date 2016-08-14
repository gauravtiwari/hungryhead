var PureRenderMixin = React.addons.PureRenderMixin;

var Upvote = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      css_class: this.props.css_class,
      voted: this.props.voted.vote,
      votes_count: this.props.voted.votes_count,
      voters_path: this.props.voted.voters_path
    };
  },

  loadVoters: function() {
    this.setState({loading: true});
    var path = this.props.vote.voters_path;
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
        url: Routes.vote_votes_path({
          votable_type: this.props.voted.votable_type,
          votable_id: this.props.voted.votable_id
        }),
        type: "POST",
        dataType: "json",
        success: function ( data ) {
          this.setState({ voted: data.vote });
          this.setState({ votes_count: data.votes_count });
          $.pubsub('publish', 'update_vote_stats', data.votes_count);
          $.pubsub('publish', 'update_voters_listing', data);
          this.forceUpdate();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(Routes.unvote_votes_path({
            votable_type: this.props.voted.votable_type,
            votable_id: this.props.voted.votable_id
          }), status, err.toString());
        }.bind(this)
      });
  },

  handleDelete: function (badge) {
      this.setState({voted: !this.state.voted});
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
          this.setState({ votes_count: data.votes_count });
          $.pubsub('publish', 'update_vote_stats', data.votes_count);
          $.pubsub('publish', 'update_voters_listing', data);
          this.forceUpdate();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(Routes.unvote_votes_path({
            votable_type: this.props.voted.votable_type,
            votable_id: this.props.voted.votable_id
          }), status, err.toString());
        }.bind(this)
      });
  },

  render: function() {
    var classes = classNames({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var button_classes = classNames({
      'main-button fs-13 bold pointer m-r-10': true,
      'disabled': this.state.disabled,
      'voted text-white': this.state.voted
    });

    var text = this.state.voted ? 'You voted this' : 'Click to vote';
    var button_text = this.state.voted ? 'Voted' : 'Vote';
    var heart = this.state.voted ? <i className="fa fa-thumbs-up inline text-danger"></i> : <i className="fa fa-thumbs-o-up"></i>;

    var voter_text = this.state.votes_count > 1 ? 'people' : 'person';

    if(this.state.votes_count > 0) {
      var voters =<a onClick={this.loadVoters} className="bold"><i className={classes}></i>{this.state.votes_count}</a>;
    }

    if(this.props.button_style) {
      return (
        <a onClick={this.state.voted? this.handleDelete : this.handleClick} className={button_classes}>
          <i className="fa fa-thumbs-up"></i> {button_text}
        </a>
        )
    } else {
      return (<div className="text-black fs-14 pointer no-padding text-center">
                <a className="m-r-5" data-toggle="tooltip" data-container="body" title={text} onClick={this.state.voted? this.handleDelete : this.handleClick}>
                  {heart}
                </a>
                {voters}
              </div>

      );
    }
  }

});
