/** @jsx React.DOM */

var CardStats = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'widget-16 p-l-20 p-r-20 bg-info-dark': true,
      'hide': this.props.mode,
      'show': !this.props.mode,
    });

    return(
      <div className={classes}>
          <div className="row text-white">
              <div className="col-md-4 p-b-10 p-t-10 no-padding text-center b-r b-white b-dashed">
                  <h1 className="all-caps fs-13 text-white bold small">Feedbacks</h1>
                  <p className="all-caps bold fs-13 no-margin">
                    {this.props.feedbacks_count}
                  </p>
              </div>
              <div className="col-md-4 p-b-10 p-t-10 text-center b-r b-white b-dashed">
                  <h1 className="all-caps fs-13 text-white bold small">Invested</h1>
                  <p className="all-caps bold  fs-13 no-margin">
                    {this.props.investments_count}
                  </p>
              </div>
              <div className="col-md-4 p-b-10 p-t-10 text-center">
                  <h1 className="all-caps fs-13 text-white bold small">Followers</h1>
                  <p className="all-caps bold  fs-13 no-margin text-white">
                    {this.props.followers_count}
                  </p>
              </div>
          </div>
      </div>
    )
  }
});
