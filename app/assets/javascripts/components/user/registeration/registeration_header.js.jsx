/** @jsx React.DOM */

var RegisterationHeader = React.createClass({
  render: function() {
    var cx = React.addons.classSet;

    var header_class = cx({
      "welcome-text": this.props.header_text
    })

    return ( <div className="profile-wrapper-title">
              <h4 className={header_class}><i className="ion-person-add red-link"></i> Fill this form to create an account</h4>
            </div>
    );
  }

});
