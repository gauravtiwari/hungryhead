/**
 * @jsx React.DOM
 */

var ThreadSection = React.createClass({
  getInitialState: function() {
    return {
      threads: [],
      meta: [],
      conversations_count: 0,
      isInfiniteLoading: false,
      done: false
    }
  },
  componentDidMount: function() {
    if(this.isMounted()){
      this.loadConversations();
      $('.notification-conversations-list').slimScroll({
        height: '285px'
      });
    }
  },

  loadConversations: function() {
    $.getJSON(this.props.path, function(data) {
      this.setState({
        threads: this.buildElements(data.conversations),
        conversations_count: data.conversations_count,
        meta: data.meta
      });
    }.bind(this));
  },

  buildElements: function(threads) {
      var elements = [];
      _.map(threads, function(conversation){
        elements.push(<ThreadListItem
          key={conversation.uuid}
          conversation={conversation} />)
      });
      return elements;
  },

  loadMoreConversations: function() {
    var self = this;
    if(!self.state.done) {
      $.ajax({
        url: this.props.path + "&page=" + this.state.meta.next_page,
        success: function(data) {
          var new_elements = self.buildElements(data.conversations)
          self.setState({meta: data.meta, isInfiniteLoading: false,  threads: self.state.threads.concat(new_elements)});
          if(self.state.meta.next_page === null) {
            self.setState({done: true, isInfiniteLoading: false});
            event.stopPropagation();
          }
        }
      });
    }
  },

  handleInfiniteLoad: function() {
    if(this.state.meta.next_page != null) {
      this.loadMoreConversations();
    }
  },

  elementInfiniteLoad: function() {
    return;
  },

  render: function() {

    return(
    <div>
      <div className="notification-section-header clearfix">
        <a href={Routes.conversations_path({box: 'inbox'})}>Inbox ({this.state.conversations_count}) </a>
        <div className="show-all pull-right bold"><a className=" text-complete" href={Routes.new_message_path()} data-remote="true"> Send new message </a></div>
      </div>
      <div className="notification-conversations-list">
        <Infinite elementHeight={80}
         containerHeight={285}
         infiniteLoadBeginBottomOffset={220}
         onInfiniteLoad={this.handleInfiniteLoad}
         loadingSpinnerDelegate={this.elementInfiniteLoad()}
         isInfiniteLoading={this.state.isInfiniteLoading}
         >
          {this.state.threads}
         </Infinite>
      </div>
    </div>
      );

  }

});

