/** @jsx React.DOM */

var MetaContent = React.createClass({
  
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      meta: data.meta,
      form: data.meta.form
    };
  },

  componentDidMount: function() {
    if(this.isMounted() && this.state.meta.is_owner) {
      this.updateContent();
      var id = this.state.meta.id;
    }
  },

  updateContent: function() {
    var self = this;
    var id = this.state.meta.id;
    $.pubsub('subscribe', 'updated_meta'+id, function(msg, data) {
      $.pubsub('publish', 'closeSectionForm', false);
      self.setState({meta: data.meta, form: data.meta.form});
    });
  },

  render: function() {

      if(this.state.meta.video_html || this.state.meta.is_owner) {
        var video = <MetaVideo meta= {this.state.meta} form= {this.state.form}/>;
      }
      return (
        <div>
          {video}
          <MetaPlan meta= {this.state.meta} form= {this.state.form}/>
          <MetaMarket meta= {this.state.meta} form= {this.state.form}/>
          <MetaProblems meta= {this.state.meta} form= {this.state.form}/>
          <MetaSolutions meta= {this.state.meta} form= {this.state.form}/>
          <MetaValueProposition meta= {this.state.meta} form= {this.state.form}/>
          <MetaVision meta= {this.state.meta} form= {this.state.form}/>
        </div>
    )
  }
});
