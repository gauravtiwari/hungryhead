var IdeaProfile = React.createClass({
  render: function() {

    var market_list = _.map(this.props.idea.market, function(tag){
      return  <a key={Math.random()} className="text-white bold fs-12 p-r-15" href={tag.url}>
            #{tag.name}
          </a>;
    });

    var location_list = _.map(this.props.idea.location, function(tag){
      return  <a key={Math.random()}  className="text-white bold fs-12" href={tag.url}>
            #{tag.name}
          </a>;
    });

    return (
      <div className="col-md-6">
          <div className="idea-meta m-l-15 inline p-t-20 p-b-10">
        <h3 className="no-margin bold text-white">
          {this.props.idea.name}
        </h3>
        <h4 className="no-margin text-white">
         {this.props.idea.high_concept_pitch}
        </h4>
        <span className="text-white">
          {market_list}
        </span>
        <span className="text-white">
         {location_list}
        </span>
        <a href={this.props.idea.school_url}>
          <p className="text-white bold fs-12 m-t-5">{this.props.idea.school_name}</p>
        </a>
      </div>
      </div>
    );
  }
});