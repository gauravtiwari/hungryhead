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
    var classes = classNames({
      'fa fa-spinner fa-spin': this.state.loading
    });

    if(this.state.rate.rated) {
      return (
        <div className="inline m-b-10 pull-right">
          <span>You found this feedback  - <span className="b-b b-grey p-b-5 text-green">
          {this.state.rate.badge_name}</span>
          </span>
        </div>
        );
    } else {
      return (
        <div className="inline m-b-10 pull-right">
          <span>Was this feedback?</span> <a onClick={this.handleClick.bind(this, "helpful")}>
            <span className="b-b b-grey p-b-5 text-green">Helpful</span>
          </a> or <a  onClick={this.handleClick.bind(this, "unhelpful")}>
           <span className="b-b b-grey p-b-5 text-warning-dark"> Not helpful</span>
         </a>  or <a onClick={this.handleClick.bind(this, "irrelevant")}>
           <span className="b-b b-grey p-b-5 text-danger">Irrelevant</span>
         </a>
        </div>
      );
    }
  }

});
