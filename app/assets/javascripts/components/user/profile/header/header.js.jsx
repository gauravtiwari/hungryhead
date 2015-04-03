/** @jsx React.DOM */

var UserProfileHeader = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      profile: data.user.profile
    }
  },

  componentDidMount: function() {
    this.setState({disabled: false});
    var self = this;
    $.pubsub('subscribe', 'updatedProfileContent', function(msg, data){
      self.setState({
        profile: data.user.profile
      });
      $('.edit-profile-mode').fadeOut(400, function(){
      $('.cover-wrap').removeClass('hidden');
      $('.profile-header').removeClass('edit-mode panel panel-default');
      $('.idea-header').removeClass('edit-mode');
      $('#cover-edit-menu').removeClass('hidden');
      $('.inner-profile-content').fadeIn();
      });
    });
  },

  render: function() {

    if(this.state.profile.university_url) {
      var university = <li> <a  href={this.state.profile.university_url}><i className="ion-at"> </i>{this.state.profile.university}</a></li>;
    }

    if(this.state.profile.location) {
      var location =  <li><a  href={this.state.profile.location_url}><i className="ion-home"></i>  {this.state.profile.location}</a></li>;
    }
    if(this.state.profile.institution_url) {
      var institution = <li> <a  href={this.state.profile.institution_url}><i className="fa fa-fw fa-institution"></i> {this.state.profile.institution}</a></li>;
    }
    
    if(this.state.profile.website_url) {
      var website_url = <li><a className="icon-rss" target="_blank" href={this.state.profile.website_url}></a></li>;
    }

    if(this.state.profile.facebook_url) {
      var facebook_url = <li><a className="icon-facebook4" target="_blank" href={this.state.profile.facebook_url}></a></li>;
    }

    if(this.state.profile.twitter_url) {
      var twitter_url = <li><a className="icon-twitter5" target="_blank" href={this.state.profile.twitter_url}></a></li>;
    }

    if(this.state.profile.linkedin_url) {
      var linkedin_url = <li><a className="icon-linkedin2" target="_blank" href={this.state.profile.linkedin_url}></a></li>;
    }

    return (
      <div className="user-data">
        <div className="top-user-line">
          <h1>{this.state.profile.name}</h1>
        </div>

         <h3><i className="ion-person"></i> {this.state.profile.mini_bio}</h3>

         <div className="mini-resume">
          <ul className="user-tag-list">
            {institution}
            {location}
          </ul>
        </div>

        <div className="social-icons">
            <ul className="profile-social">
              {website_url}
              {facebook_url}
              {twitter_url}
              {linkedin_url}
            </ul>
        </div>
      </div>
    );
  }

});
