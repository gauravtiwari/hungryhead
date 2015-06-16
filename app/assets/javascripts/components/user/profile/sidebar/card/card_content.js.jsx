/** @jsx React.DOM */

var CardContent = React.createClass({

  render: function() {

    if(this.props.profile.markets && this.props.profile.markets.length > 0 ) {
      var markets = this.props.profile.markets.map(function(market){
        return <li className="inline" key={Math.random()}><a className="text-brand p-r-10" href={market.url} >#{market.tag}</a></li>
      });

    } else {
      if(this.props.is_owner) {
        var markets = <em className="sidebar_filler clearfix">Which markets are you interested in? ex: finance, ecommerce</em>;
      } else {
        var markets = "";
      }
    }

    if(this.props.profile.hobbies && this.props.profile.hobbies.length > 0 ) {
      var hobbies = this.props.profile.hobbies.map(function(hobby){
        return <li className="inline"  key={Math.random()}><a className="text-brand p-r-10" href={hobby.url} >#{hobby.tag}</a></li>
      });
    } else {
      if(this.props.is_owner) {
        var hobbies = <em className="sidebar_filler clearfix"> What interests you? ex: Games, Football, Science etc.</em>
      } else {
        var hobbies = "";
      }
    }

    if(this.props.profile.skills && this.props.profile.skills.length > 0 ) {
      var skills = this.props.profile.skills.map(function(skill){
        return <li className="inline"  key={Math.random()}><a className="text-brand p-r-10" href={skill.url} >#{skill.tag}</a></li>
      });
    } else {
      if(this.props.is_owner) {
        var skills = <em className="sidebar_filler clearfix"> What are your skills? ex: Technology, Programming, Marketing etc.</em>
      } else {
        var skills = "";
      }
    }

    if(this.props.profile.website_url) {
      var website_url =  <li className="inline">
                            <a className="text-white p-r-10" target="_blank" href={this.props.profile.website_url} ><i className="fa fa-rss fs-14"></i></a>                         </li>;
    }

    if(this.props.profile.facebook_url) {
      var facebook_url =  <li className="inline">
                            <a className="text-white p-r-10" target="_blank" href={this.props.profile.facebook_url} ><i className="fa fa-facebook fs-14"></i></a>
                          </li>;
    }

    if(this.props.profile.linkedin_url) {
      var linkedin_url =  <li className="inline">
                            <a className="text-white p-r-10" target="_blank" href={this.props.profile.linkedin_url} ><i className="fa fa-linkedin fs-14"></i></a>
                          </li>;
    }

    if(this.props.profile.twitter_url) {
      var twitter_url =  <li className="inline">
                            <a className="text-white p-r-10" target="_blank" href={this.props.profile.twitter_url} ><i className="fa fa-twitter fs-14"></i></a>
                          </li>;
    }

    if(this.props.profile.location_name) {
      var location = <a className="text-white" href={this.props.profile.location_url}>
                          <i className="fa fa-map-marker"></i> {this.props.profile.location_name}
                         </a>;
    }

    if(this.props.profile.school_url) {
      var school = <a className="text-white p-l-10" href={this.props.profile.school_url}>
                           <i className="fa fa-university"></i> {this.props.profile.school_name}
                          </a>;
    } else {
      var school = "";
    }

    var classes = "profile-card padding-20 box-shadow bg-" + this.props.profile.theme;


    if(markets.length > 0) {
      var market_content = <div className="m-b-15"><span className="text-master bold"><i className="fa fa-briefcase"></i> Markets interested</span> <span className="clearfix text-brand p-t-5 displayblock">{markets}</span></div>;
    }

    if(hobbies.length > 0) {
      var hobbies_content = <div className="m-b-15"><span className="text-master bold"><i className="fa fa-smile-o"></i> Likes</span> <span className="clearfix text-brand p-t-5 displayblock">{hobbies}</span></div>;
    }

    if(skills.length > 0){
      var skills_content = <div className="m-b-15"><span className="text-master bold"><i className="fa fa-graduation-cap"></i> Knows about</span> <span className="clearfix text-brand p-t-5 displayblock">{skills}</span></div>;
    }

    return(
      <div className="profile-card-sidebar">
        <div className={classes}>
            <div className="container-xs-height">
                <div className="row text-center">
                <a onClick={this.props.openForm} className="pull-right pointer p-r-20 displayblock text-white">{this.props.text}</a>
                  <div className="user-profile auto-margin">
                      <div className="thumbnail-wrapper d100 circular bordered b-white">
                          <div className="profile-avatar">
                            <Avatar data={this.props.data} />
                          </div>
                      </div>
                  </div>
                  <div className="clearfix p-l-10 p-r-10 p-t-10">
                       <h3 className="no-margin bold text-white">
                           {this.props.profile.name}
                           <div className="role-badge inline m-l-10 v-middle" data-toggle="tooltip" data-container="body" title={this.props.profile.role}>
                             <img src={this.props.profile.role_badge} alt={this.props.profile.role_badge} width="30px" height="30px" />
                           </div>
                       </h3>
                       <p className="no-margin text-white fs-12 p-t-10">{this.props.profile.mini_bio}</p>
                       <p className="no-margin text-white fs-12">{location}{school}</p>
                       <ul className="social-list text-white m-t-5 small no-style">
                        {website_url}
                        {linkedin_url}
                        {facebook_url}
                        {twitter_url}
                       </ul>
                   </div>
                </div>
            </div>
        </div>
        <div className="padding-20 box-shadow bg-master-lightest">
          <ul className="text-master m-t-5 small no-style">
            {market_content}
            {hobbies_content}
            {skills_content}
          </ul>
        </div>
      </div>
    )
  }
});
