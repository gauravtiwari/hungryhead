var IdeaProfile = React.createClass({

  render: function() {

    var market_list = _.map(this.props.idea.market, function(tag){
      return  <a key={Math.random()} className="text-white bold fs-12 p-r-15 inline" href={tag.url}>
            {tag.name}
          </a>;
    });

    var location_list = _.map(this.props.idea.location, function(tag){
      return  <a key={Math.random()}  className="text-white bold fs-12 inline" href={tag.url}>
            {tag.name}
          </a>;
    });

    return (
      <div className="col-md-6">
        <div className="idea-meta m-l-15 inline p-t-20 p-b-10">
        <h4 className="no-margin bold text-white">
          {this.props.idea.name}
          <a onClick={this.props.openForm} className="m-l-20 inline fs-12 b-b b-white pointer text-white">{this.props.text}</a>
        </h4>
        <p className="no-margin text-white p-b-10 fs-16 p-t-10">
         {this.props.idea.high_concept_pitch}
        </p>
        <span className="text-white">
          {market_list}
        </span>
        <span className="text-white clearfix m-t-10">
         <i className="fa fa-map-marker"></i> {location_list}
        </span>
      </div>
      </div>
    );
  }
});