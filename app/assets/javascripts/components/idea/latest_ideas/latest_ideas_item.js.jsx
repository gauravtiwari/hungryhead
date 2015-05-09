var LatestIdeasItem = React.createClass({

  getInitialState: function() {
    return {
      name_badge: null
    }
  },

  componentDidMount: function() {
    this.generateNameBadge();
  },

  generateNameBadge: function() {
    words = this.props.item.name.split(' ')
    badge = []
    _.each(words, function(w, i){
      if(words.length > 1) {
        badge.push(w[i]);
      } else {
        badge.push(w[i]);
        badge.push(w[i+1]);
      }
    });
    this.setState({name_badge: badge.join('').toUpperCase()});
  },

  render: function() {
    return (
      <li className="m-b-10">
        <div className="widget-16-header p-b-10 p-l-15">
        <span className="icon-thumbnail placeholder bg-master-light pull-left text-white">{this.state.name_badge}</span>
        <div className="pull-left">
            <a href={this.props.item.url}>
              <p className="all-caps bold  small no-margin overflow-ellipsis ">{this.props.item.name}</p>
            </a>
            <p className="small no-margin">{this.props.item.pitch}</p>
        </div>
        <div className="clearfix"></div>
        </div>
      </li>
    );
  }
});