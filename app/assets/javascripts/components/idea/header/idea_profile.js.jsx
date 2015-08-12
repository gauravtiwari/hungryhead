var IdeaProfile = React.createClass({

  render: function() {

    var market_list = _.map(this.props.idea.markets, function(tag){
      return  <a key={Math.random()} className="text-white bold fs-12 p-r-15 inline" href={tag.url}>
            {tag.name}
          </a>;
    });

    if(this.props.idea.looking_for_team) {
      var looking_for_team = <div className="clearfix text-white small"><span className='fa fa-search'></span> Looking for team</div>;
    }

    return (
      <div className="idea-meta text-center">
        <a onClick={this.props.openForm} data-toggle="tooltip" title="Click to edit" className="pull-right fs-12 b-b b-white pointer text-white">
          {this.props.text}
        </a>
        <div>
          <span className="fa full-width fa-lightbulb-o fs-50 text-white"></span>
        </div>
        <h3 className="no-margin bold text-white">
          {this.props.idea.name}
        </h3>
        <div className="no-margin text-white fs-16">
         {this.props.idea.high_concept_pitch}
        </div>
        <span className="text-white m-t-10">
          {market_list}
        </span>
        {looking_for_team}
      </div>
    );
  }
});