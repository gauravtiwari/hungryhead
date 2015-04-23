/** @jsx React.DOM */

var CardContent = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'profile-card padding-20 bg-solid box-shadow': true,
      'hide': this.props.mode,
      'show': !this.props.mode,
    });

    if(this.props.profile.markets && this.props.profile.markets.length > 0 ) {
      var markets = this.props.profile.markets.map(function(market){
        return <li key={Math.random()}><a href={market.url} >#{market.tag}</a></li>
      });

    } else {
      if(this.props.is_owner) {
        var markets = <em className="sidebar_filler">Which markets are you interested in? ex: finance, ecommerce</em>;
      } else {
        var markets = <li>None</li>;
      }
    }

    if(this.props.profile.skills && this.props.profile.skills.length > 0 ) {
      var skills = this.props.profile.skills.map(function(skill){
        return <li key={Math.random()}><a href={skill.url} >#{skill.tag}</a></li>
      });
    } else {
      if(this.props.is_owner) {
        var skills = <em className="sidebar_filler"> What are you good at? ex: Design, Photoshop, PHP etc.</em>
      } else {
        var skills = <li>None</li>;
      }
    }

    if(this.props.profile.verified) {
      var verified_badge = <i className="fa fa-check-circle text-white fs-16 m-l-10"></i>;
    }

    return(
        <div className={classes}>
            <a onClick={this.props.openForm} className="pull-right displayblock text-white">{this.props.text}</a>
            <div className="container-xs-height">
                <div className="row text-center">
                    <div className="user-profile auto-margin">
                        <div className="thumbnail-wrapper d100 circular bordered b-white">
                            <div className="profile-avatar">
                              <Avatar data={this.props.data} />
                            </div>
                        </div>
                    </div>
                   <div className="clearfix p-l-10 p-r-10 p-t-10">
                       <h3 className="no-margin text-white">
                           {this.props.profile.name} {verified_badge}
                       </h3>
                       <p className="no-margin text-white fs-14">{this.props.profile.mini_bio}</p>
                       <p className="text-white m-t-5 small">
                       <a className="text-white b-r b-white b-dashed p-r-10" href={this.props.profile.school_url}>
                        <i className="fa fa-university"></i> {this.props.profile.school_name}
                        </a>
                       <a className="text-white p-l-10" href={this.props.profile.location_url}>
                        <i className="fa fa-map-marker"></i> {this.props.profile.location_name}
                       </a>
                       </p>
                   </div>
                </div>
            </div>
        </div>
    )
  }
});
