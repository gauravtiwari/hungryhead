/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;

var Upvote = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      css_class: this.props.css_class,
      voted: this.props.voted,
      vote_url: this.props.vote_url,
      votes_count: this.props.votes_count,
      likers_path: this.props.likers_path
    };
  },

  loadLikers: function() {
    this.setState({loading: true});
    var path = this.props.likers_path;
    $('body').append($('<div>', {class: 'likers_list', id: 'listing_modal'}));
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
    if(this.state.voted) {
      var button_classes = css_classes + ' delete-vote';
    } else {
      var button_classes = css_classes;
    }

    var text = this.state.voted ? 'You liked this' : 'Like';
    
    var voter_text = this.state.votes_count > 1 ? 'people' : 'person';

    if(this.state.votes_count > 0) {
      var voters =<a onClick={this.loadLikers} className="m-l-5"><i className={classes}></i>({this.state.votes_count})</a>;
    }

    return (<div className="pull-left b-r b-grey b-dashed p-r-10">
              <a className={button_classes} onClick={this.handleClick}>
                {text}{voters}
              </a>
            </div>
           
    );
  }

});
