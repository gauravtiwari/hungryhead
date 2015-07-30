var IdeaProfile = React.createClass({

  render: function() {

    var market_list = _.map(this.props.idea.markets, function(tag){
      return  <a key={Math.random()} className="text-white bold fs-12 p-r-15 inline" href={tag.url}>
            {tag.name}
          </a>;
    });

    return (
      <div className="col-md-6">
        <div className="idea-meta m-l-15 inline p-t-20 p-b-20">
        <h4 className="no-margin bold text-white">
          {this.props.idea.name}
          <a onClick={this.props.openForm} data-toggle="tooltip" title="Click to edit" className="m-l-20 inline fs-12 b-b b-white pointer text-white">
            {this.props.text}
          </a>
        </h4>
        <p className="no-margin text-white p-t-10 fs-16">
         {this.props.idea.high_concept_pitch}
        </p>
        <span className="text-white">
          {market_list}
        </span>
      </div>
      </div>
    );
  }
});