/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;

var Rate = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      rate: this.props.rate
    };
  },

  handleClick: function (badge) {
      this.setState({disabled: true});
      this.setState({loading: true});
      $.ajaxSetup({ cache: false });
      $("[data-toggle='tooltip']").tooltip('destroy');
      var url = this.state.rate.rated ? this.state.rate.rate_url : this.state.rate.rate_url+'?badge='+badge;
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
          console.error(this.state.rate.rate_url, status, err.toString());
        }.bind(this)
      });
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var title = this.state.rate.user_name + ' found this feedback ' + this.state.rate.badge_name;
    var badge_classes = 'activity-badges-list panel panel-default no-style no-margin inline no-border auto-overflow show-badges-list-'+this.props.record;

    if(this.state.rate.rated) {
      return (
        <p className="inline m-b-10 pull-right">
         <a className="badge text-white font-helvetica" data-container="body" data-toggle="tooltip" data-placement="top" title={title}>
           <span className="badge-type bronze"></span>
            {this.state.rate.badge_name}
         </a>
        </p>
        );
    } else {
      return (
      <div className="badges-list">
        <div className={badge_classes}>
          <ul className="no-style">
            <li className="m-r-10 pull-left no-padding text-center">
              <p className="inline m-b-10">
                <a className="badge text-white font-helvetica" onClick={this.handleClick.bind(this, "helpful")}>
                  <span className="badge-type bronze"></span>
                   Helpful
                </a>
              </p>
            </li>

            <li className="m-r-10 pull-left no-padding text-center">
              <p className="inline m-b-10">
                 <a className="badge text-white font-helvetica" onClick={this.handleClick.bind(this, "unhelpful")}>
                   <span className="badge-type bronze"></span>
                    Not helpful
                 </a>
               </p>
            </li>

            <li className="m-r-10 pull-left no-padding text-center">
              <p className="inline m-b-10">
               <a className="badge text-white font-helvetica" onClick={this.handleClick.bind(this, "irrelevant")}>
                 <span className="badge-type bronze"></span>
                  Irrelevant
               </a>
             </p>
            </li>
          </ul>
        </div>
        </div>
      );
    }
  }

});
