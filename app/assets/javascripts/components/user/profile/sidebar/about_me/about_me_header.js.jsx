/** @jsx React.DOM */

var AboutMeHeader = React.createClass({

  render: function() {

    return(
      <div className="profile-wrapper-title">
        <h4><i className="ion-person red-link"></i> Interests</h4>
         <a className="see-all" onClick={this.props.openForm}>{this.props.text}</a>
      </div>
    )
  }
});
