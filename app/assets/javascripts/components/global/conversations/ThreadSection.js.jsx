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
      <div className="view-port clearfix" id="conversations">
        <div className="view bg-white">
          <div className="navbar navbar-default">
            <div className="navbar-inner">
              <a href="javascript:;" className="inline action p-l-10 link text-master" data-navigate="view" data-view-port="#conversations" data-view-animation="push-parrallax">
                <i className="pg-plus"></i>
              </a>
              <div className="view-heading">
                Conversations
              </div>
              <a href="#" className="inline action p-r-10 pull-right link text-master">
                <i className="pg-more"></i>
              </a>
            </div>
          </div>

          <div data-init-list-view="ioslist" className="list-view boreded no-top-border">
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
        <div className="view conversations-view bg-white clearfix" >
          <div className="navbar navbar-default">
            <div className="navbar-inner">
              <a href="javascript:;" className="link text-master inline action p-l-10" data-navigate="view" data-view-port="#conversations" data-view-animation="push-parrallax">
                <i className="pg-arrow_left"></i>
              </a>
              <div className="view-heading">
                John Smith
                <div className="fs-11 hint-text">Online</div>
              </div>
              <a href="#" className="link text-master inline action p-r-10 pull-right ">
                <i className="pg-more"></i>
              </a>
            </div>
          </div>
          <div className="conversations-inner">
            <div className="message clearfix">
              <div className="conversations-bubble from-me">
                Hello there
              </div>
            </div>
            <div className="message clearfix">
              <div className="profile-img-wrapper m-t-5 inline">
                <img className="col-top" width="30" height="30" src="assets/avatar_small.jpg" alt="" data-src="assets/avatar_small.jpg" data-src-retina="assets/avatar_small2x.jpg" />
              </div>
              <div className="conversations-bubble from-them">
                Hey
              </div>
            </div>
            <div className="message clearfix">
              <div className="conversations-bubble from-me">
                Did you check out Pages framework ?
              </div>
            </div>
            <div className="message clearfix">
              <div className="conversations-bubble from-me">
                Its an awesome conversations
              </div>
            </div>
            <div className="message clearfix">
              <div className="profile-img-wrapper m-t-5 inline">
                <img className="col-top" width="30" height="30" src="assets/avatar_small.jpg" alt="" data-src="assets/avatar_small.jpg" data-src-retina="assets/avatar_small2x.jpg" />
              </div>
              <div className="conversations-bubble from-them">
                Yea
              </div>
            </div>
          </div>
          <div className="b-t b-grey bg-white clearfix p-l-10 p-r-10">
            <div className="row">
              <div className="col-xs-1 p-t-15">
                <a href="#" className="link text-master"><i className="fa fa-plus-circle"></i></a>
              </div>
              <div className="col-xs-8 no-padding">
                <input type="text" className="form-control conversations-input" data-conversations-input="" data-conversations-conversation="#my-conversation" placeholder="Say something" />
              </div>
              <div className="col-xs-2 link text-master m-l-10 m-t-15 p-l-10 b-l b-grey col-top">
                <a href="#" className="link text-master"><i className="pg-camera"></i></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

      );

  }

});

