/** @jsx React.DOM */

var MainContent = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      idea: data.idea,
      form: data.idea.form,
      meta: data.meta
    };
  },

  componentDidMount: function() {
    if(this.isMounted() && this.state.meta.is_owner) {
      this.updateContent();
    }
  },

  updateContent: function() {
    var self = this;
    var id = this.state.idea.slug;
    idea_collaboration_channel.bind('idea_update_'+id, function(data) {
      var response = JSON.parse(data.data);
      $.pubsub('publish', 'closeSectionForm', false);
      self.setState({idea: response.idea, form: response.idea.form, meta: response.meta});
    });
  },

  render: function() {
      return (
        <div>
          <Plan idea= {this.state.idea} form= {this.state.form} meta= {this.state.meta} />
          <Problems idea= {this.state.idea} form= {this.state.form} meta= {this.state.meta} />
          <Solutions idea= {this.state.idea} form= {this.state.form} meta= {this.state.meta} />
          <ValueProposition idea= {this.state.idea} form= {this.state.form} meta= {this.state.meta} />
          <Market idea= {this.state.idea} form= {this.state.form} meta= {this.state.meta} />
        </div>
    )
  }
});
