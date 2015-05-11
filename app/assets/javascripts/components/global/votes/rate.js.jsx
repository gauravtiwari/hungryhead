/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;

var Rate = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
    var data = JSON.parse(this.props.data);
     return {
      loading: false,
      rate: data.rate
    };
  },

  handleClick: function (badge) {
      this.setState({disabled: true});
      this.setState({loading: true});
      $.ajaxSetup({ cache: false });
      $("[data-toggle='tooltip']").tooltip('destroy');
      var url = this.state.rate.voted ? this.state.rate.vote_url : this.state.rate.vote_url+'?badge='+badge;
      $.ajax({
        url: url,
        type: "PUT",
        dataType: "json",
        success: function ( data ) {
          this.setState({ rate: data.rate });
          this.setState({disabled: false});
          this.setState({loading: false});
          $("[data-toggle='tooltip']").tooltip();
          $('body').pgNotification({style: "simple", message: "<span>You have successfully reviewed this feedback", position: "bottom-left", type: "success",timeout: 5000}).show();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.vote_url, status, err.toString());
        }.bind(this)
      });
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var badged_class = "thumbnail-wrapper displayblock d32 circular b-white m-r-5 m-b-5 b-a b-white bg-" + this.state.rate.badge_bg;

    var rate_class = this.state.rate.voted ? 'fs-16 fa fa-' + this.state.rate.badge_class : 'fs-16';
    var text = this.state.rate.voted ?   'Reviewed' : 'Review';
    var title = this.state.rate.user_name + ' earned a ' + this.state.rate.badge_name + ' badge';
    var badge_classes = 'activity-badges-list panel panel-default no-style no-margin inline no-border auto-overflow show-badges-list-'+this.props.record;

    if(this.state.rate.voted) {
      return (
          <div className={badged_class} data-container="body" data-toggle="tooltip" data-placement="top" title={title}>
              <span className="bold displayblock text-white">
                <i className={rate_class}></i>
              </span>
          </div>
        );
    } else {
      return (
      <div className="badges-list">
        <span className="pull-left m-r-10 m-t-10">{text}</span>
        <div className={badge_classes}>
          <ul className="no-style">
          <li className="m-r-10 pull-left no-padding text-center">
            <a className="displayblock" onClick={this.handleClick.bind(this, 15)} data-container="body" data-toggle="tooltip" data-placement="top" title="Helpful">
              <div className="thumbnail-wrapper auto-margin displayblock bg-solid d32 circular b-white m-r-5 m-b-5 b-a b-white">
                  <span className="bold displayblock text-white">
                    <i className="fa fa-thumbs-up fs-16"></i>
                  </span>
              </div>
            </a>
          </li>

          <li className="m-r-10 pull-left no-padding text-center">
            <a className="displayblock" onClick={this.handleClick.bind(this, 16)} data-container="body" data-toggle="tooltip" data-placement="top" title="Not helpful">
              <div className="thumbnail-wrapper auto-margin displayblock bg-master d32 circular b-white m-r-5 m-b-5 b-a b-white">
                  <span className="bold displayblock text-white">
                    <i className="fa fa-thumbs-down fs-16"></i>
                  </span>
              </div>
            </a>
          </li>

          <li className="m-r-10 pull-left no-padding text-center">
            <a className="displayblock" onClick={this.handleClick.bind(this, 17)} data-container="body" data-toggle="tooltip" data-placement="top" title="OK">
              <div className="thumbnail-wrapper bg-warning-dark auto-margin displayblock d32 circular b-white m-r-5 m-b-5 b-a b-white">
                  <span className="displayblock bold text-white">
                    <i className="fa fa-check-circle fs-16"></i>
                  </span>
              </div>
            </a>
          </li>

           <li className="m-r-10 pull-left no-padding text-center">
              <a className="displayblock" onClick={this.handleClick.bind(this, 18)} data-container="body" data-toggle="tooltip" data-placement="top" title="Very Helpful">
                <div className="thumbnail-wrapper auto-margin displayblock bg-danger d32 circular b-white m-r-5 m-b-5 b-a b-white">
                    <span className="bold displayblock text-white">
                      <i className="fa fa-heart fs-16"></i>
                    </span>
                </div>
              </a>
            </li>

            <li className="pull-left no-padding text-center">
               <a className="displayblock" onClick={this.handleClick.bind(this, 19)} data-container="body" data-toggle="tooltip" data-placement="top" title="Game Changing!">
                 <div className="thumbnail-wrapper auto-margin displayblock bg-green d32 circular b-white m-r-5 m-b-5 b-a b-white">
                     <span className="bold displayblock text-white">
                       <i className="fa fa-magic fs-16"></i>
                     </span>
                 </div>
               </a>
             </li>

          </ul>
        </div>
        </div>
      );
    }
  }

});
