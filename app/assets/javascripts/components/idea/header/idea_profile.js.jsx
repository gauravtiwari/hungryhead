var IdeaProfile = React.createClass({
  render: function() {

    var market_list = _.map(this.props.idea.market, function(tag){
      return  <a key={Math.random()} className="text-white fs-11 p-r-10" href={tag.url}>
            {tag.name}
          </a>;
    });

    var location_list = _.map(this.props.idea.location, function(tag){
      return  <a key={Math.random()}  className="text-white fs-11" href={tag.url}>
            {tag.name}
          </a>;
    });

    return (
      <div className="col-md-6">
          <div className="idea-meta m-l-15 inline p-t-20 p-b-10">
        <h3 className="no-margin text-white">
          {this.props.idea.name}
          <i className="fa fa-check-circle text-white fs-16 m-l-10"></i>
        </h3>
        <p className="no-margin text-white fs-16">
         {this.props.idea.high_concept_pitch}
        </p>
        <span className="text-white">
          {market_list}
        </span>
        <span className="text-white">
         {location_list}
        </span>
        <a href={this.props.idea.school_url}>
          <p className="text-white m-t-5 small">{this.props.idea.school_name}</p>
        </a>
      </div>
      </div>
    );
  }
});