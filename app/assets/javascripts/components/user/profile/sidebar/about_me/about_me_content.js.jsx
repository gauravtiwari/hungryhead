/** @jsx React.DOM */

var AboutMeContent = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'display-mode-profile': true,
      'hidden': this.props.mode,
      'show': !this.props.mode,
    });

    if(this.props.sidebar.markets && this.props.sidebar.markets.length > 0 ) {
      var markets = this.props.sidebar.markets.map(function(market){
        return <li key={Math.random()}><a href={market.url} >#{market.tag}</a></li>
      });

    } else {
      if(this.props.is_owner) {
        var markets = <em className="sidebar_filler">Which markets are you interested in? ex: finance, ecommerce</em>;
      } else {
        var markets = <li>None</li>;
      }
    }

    if(this.props.sidebar.technologies && this.props.sidebar.technologies.length > 0 ) {
      var technologies = this.props.sidebar.technologies.map(function(technology){
        return <li key={Math.random()}><a href={technology.url} >#{technology.tag}</a></li>
      });

    } else {
      if(this.props.is_owner) {
        var technologies = <em className="sidebar_filler">Technologies you are skilled in? in? ex: Ruby, Python</em>;
      } else {
        var technologies = <li>None</li>;
      }
    }

    if(this.props.sidebar.services && this.props.sidebar.services.length > 0 ) {
      var services = this.props.sidebar.services.map(function(service){
        return <li key={Math.random()}><a href={service.url} >#{service.tag}</a></li>
      });

    } else {
      if(this.props.is_owner) {
        var services = <em className="sidebar_filler">What services are you willing to offer ? ex: Marketing, Programming etc.</em>;
      } else {
        var services = <li>None</li>;
      }
    }

    if(this.props.sidebar.skills && this.props.sidebar.skills.length > 0 ) {
      var skills = this.props.sidebar.skills.map(function(skill){
        return <li key={Math.random()}><a href={skill.url} >#{skill.tag}</a></li>
      });
    } else {
      if(this.props.is_owner) {
        var skills = <em className="sidebar_filler"> What are you good at? ex: Design, Photoshop, PHP etc.</em>
      } else {
        var skills = <li>None</li>;
      }
    }

    return(
        <div className={classes}>
          <ul className="wrapper-list">
            <li>
              <div className="display-mode">
                <span> Skills</span>
                <div className="display-mode-content">
                    <ul className="user-tag-list about-me-tags">
                      {skills}
                    </ul>
                </div>
              </div>
            </li>

            <li>
              <div className="display-mode">
                <span> Services offered</span>
                <div className="display-mode-content">
                    <ul className="user-tag-list about-me-tags">
                      {services}
                    </ul>
                </div>
              </div>
            </li>

            <li>
              <div className="display-mode">
                <span> Technologies I know </span>
                <div className="display-mode-content">
                    <ul className="user-tag-list about-me-tags">
                      {technologies}
                    </ul>
                </div>
              </div>
            </li>

            <li>
              <div className="display-mode">
                <span> Markets interested</span>
                <div className="display-mode-content">
                    <ul className="user-tag-list about-me-tags">
                      {markets}
                    </ul>
                </div>
              </div>
            </li>

          </ul>
        </div>
    )
  }
});
