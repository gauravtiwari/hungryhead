/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;

var Rate = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      css_class: this.props.css_class,
      voted: this.props.voted,
      vote_url: this.props.vote_url,
      points: this.props.points,
      votes_count: this.props.votes_count
    };
  },

  componentDidMount: function() {
    var self = this;
    if(this.isMounted()){
      $('.show-badges-list-'+this.props.record).hide();
      $('body').click(function(event){
        $('.show-badges-list-'+self.props.record).hide();
      });
    }
  },

  handleClick: function (badge) {
      this.setState({disabled: true});
      this.setState({loading: true});
      $.ajaxSetup({ cache: false });
      var url = this.state.voted ? this.state.vote_url : this.state.vote_url+'?badge='+badge;
      $.ajax({
        url: url,
        type: "PUT",
        dataType: "json",
        success: function ( data ) {
          this.setState({ voted: data.voted });
          this.setState({ vote_url: data.url });
          this.setState({ votes_count: data.votes_count});
          this.setState({disabled: false});
          this.setState({loading: false});
          $('.show-badges-list-'+this.props.record).closest('.main-post-content').find('.item-tags').show();
          $('.show-badges-list-'+this.props.record).closest('.main-post-content').find('.likers').show();
          $('.show-badges-list-'+this.props.record).hide();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.vote_url, status, err.toString());
        }.bind(this)
      });
  },

  showBadges: function(event) {
    event.preventDefault();
    $('.show-badges-list-'+this.props.record).toggle();
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });
    var css_classes = this.state.css_class;

    if(this.state.voted) {
      var button_classes =  'feedback-rated-link float-left margin-right'
    } else {
      var button_classes = css_classes
    }

    var text = this.state.voted ?  <span className="ion-checkmark-circled"> Reviewed ({this.state.points} <i className="ion-arrow-up-b"></i>)</span> : 'Review';
    var badge_classes = 'activity-badges-list panel panel-default show-badges-list-'+this.props.record;

    var handleClick = this.state.voted ? false : this.showBadges;

    return (
    <div>
    <a className={button_classes} onClick={handleClick}>
      {text}
    </a>

    <div className={badge_classes}>
      <button type="button" className="close" onClick={this.closeBadges}><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
      <span className="displayblock margin-bottom">Choose a badge and click to like: </span>
      <ul className="noliststyle">
            <li className="float-left margin-right">
              <a className="displayblock text-center" onClick={this.handleClick.bind(this, 6, 10)} data-toggle="tooltip" data-placement="top" data-original-title="Wise">
                <img className="borderless displayblock" src="/assets/badges/wise.png" width="40px" />
                <span className="badge-point">10</span>
              </a>
            </li>
            <li className="float-left margin-right">
              <a className="displayblock text-center" onClick={this.handleClick.bind(this, 10, 2)} data-toggle="tooltip" data-placement="top" data-original-title="Expert">
                <img className="borderless displayblock" src="/assets/badges/ninja.png" width="40px" />
                <span className="badge-point">4</span>
              </a>
            </li>

            <li className="float-left margin-right">
              <a className="displayblock text-center" onClick={this.handleClick.bind(this, 11, 5)} data-toggle="tooltip" data-placement="top" data-original-title="Mentor">
                <img className="borderless displayblock" src="/assets/badges/mentor.png" width="40px" />
                <span className="badge-point">4</span>
              </a>
            </li>

            <li className="float-left margin-right">
              <a className="displayblock text-center" onClick={this.handleClick.bind(this, 7, 3)} data-toggle="tooltip" data-placement="top" data-original-title="Cool">
                <img className="borderless displayblock" src="/assets/badges/cool-guy.png" width="40px" />
                <span className="badge-point">3</span>
              </a>
            </li>

            <li className="float-left margin-right">
              <a className="displayblock text-center" onClick={this.handleClick.bind(this, 9, 10)} data-toggle="tooltip" data-placement="top" data-original-title="Fish">
                <img className="borderless displayblock" src="/assets/badges/fish.png" width="40px" />
                <span className="badge-point">2</span>
              </a>
            </li>

             <li className="float-left margin-right">
              <a className="displayblock text-center" onClick={this.handleClick.bind(this, 8, 5)} data-toggle="tooltip" data-placement="top" data-original-title="Scholar">
                <img className="borderless displayblock" src="/assets/badges/scholar.png" width="40px" />
                <span className="badge-point">7</span>
              </a>
            </li>
          </ul>
         </div>
      </div>
    );
  }

});
