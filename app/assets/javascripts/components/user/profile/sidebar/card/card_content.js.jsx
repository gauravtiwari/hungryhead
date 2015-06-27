/** @jsx React.DOM */

var CardContent = React.createClass({

  render: function() {

    if(this.props.profile.markets && this.props.profile.markets.length > 0 ) {
      var markets = this.props.profile.markets.map(function(market){
        return <a key={Math.random()} className="text-white fs-13 m-l-5 lighter-text" href={market.url} > @{market.tag} </a>;
      });
    }

    if(this.props.profile.hobbies && this.props.profile.hobbies.length > 0 ) {
      var hobbies = this.props.profile.hobbies.map(function(hobby){
        return <a key={Math.random()} className="text-white fs-13 m-l-5 lighter-text" href={hobby.url} > @{hobby.tag} </a>;
      });
    }

    if(this.props.profile.skills && this.props.profile.skills.length > 0 ) {
      var skills = this.props.profile.skills.map(function(skill){
        return <a key={Math.random()} key={Math.random()} className="text-white fs-13 m-l-5 lighter-text" href={skill.url} > @{skill.tag} </a>;
      });
    }

    if(this.props.profile.subjects && this.props.profile.subjects.length > 0 ) {
      var subjects = this.props.profile.subjects.map(function(subject){
        return <a key={Math.random()} className="text-white fs-13 m-l-5 lighter-text" href={subject.url} > @{subject.tag} </a>;
      });
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

    if(this.props.profile.locations && this.props.profile.locations.length > 0 ) {
      var location = this.props.profile.locations.map(function(location){
        return <a className="text-white" href={location.url}>
                          <i className="fa fa-map-marker"></i> {location.tag}
                         </a>;
      });
    }

    if(this.props.profile.school_url) {
      var school = <a className="text-white p-l-10" href={this.props.profile.school_url}>
                           <i className="fa fa-university"></i> {this.props.profile.school_name}
                          </a>;
    } else {
      var school = "";
    }

    var classes = "profile-card padding-20  p-t-40 box-shadow bg-solid";

    if(markets) {
      var market_content =  <span>Markets interested in: {markets}</span>;
    } else {
      var market_content = ""
    }

    if(skills) {
      var skill_content =   <span className="m-l-5">Knows about: {skills}</span>;
    } else {
      var skill_content = ""
    }

    if(hobbies) {
      var hobby_content =    <span className="m-l-5">Likes: {hobbies}</span>;
    } else {
      var hobby_content = ""
    }

    if(subjects) {
      var subject_content =  <span className="m-l-5">Studying: {subjects}</span>;
    } else {
      var subject_content = ""
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
                  <div className="clearfix p-l-10 p-r-10 p-t-10  font-opensans">
                       <h3 className="no-margin bold text-white">
                           {this.props.profile.name}
                       </h3>
                       <p className="no-margin text-white fs-13 p-t-10">
                        {this.props.profile.mini_bio}
                        <p className="no-margin text-white fs-12 p-t-5">{location}{school}</p>
                       </p>
                       <p className="text-white about-list fs-14">
                          {market_content}
                          {skill_content}
                          {subject_content}
                          {hobby_content}
                       </p>
                       <ul className="social-list text-white p-t-5 small no-style">
                        {website_url}
                        {linkedin_url}
                        {facebook_url}
                        {twitter_url}
                       </ul>
                   </div>
                </div>
            </div>
        </div>
      </div>
    )
  }
});
