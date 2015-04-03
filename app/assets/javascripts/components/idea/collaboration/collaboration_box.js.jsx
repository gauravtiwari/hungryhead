/**
 * @jsx React.DOM
 */

var CollaborationBox = React.createClass({
  getInitialState: function () {
     return {
      messages: [],
      form: this.props.form,
      team_members: [],
      meta: [],
      loading: false
    };
  },

  componentDidMount: function() {
    var self = this;
    if(this.isMounted()){
      $.getJSON(this.props.form.action, function(data) {
        this.setState({
          messages: data.idea_messages.reverse(),
          meta: data.meta,
          team_members: data.members
        });
      this.addCollaborationMessage();
      }.bind(this));

    idea_collaboration_channel.bind('pusher:subscription_succeeded', function(members) {
      members.each(self.add_member);
    });

    idea_collaboration_channel.bind('pusher:member_added', function(member) {
      self.add_member(member);
    });

    idea_collaboration_channel.bind('pusher:member_removed', function(member) {
      self.remove_member(member);
    });

    var typer = new Typer({
      onStart: function() {
        self.showTyping(idea_collaboration_channel.members.me);
      },
      onTyping: function() {
        if(idea_collaboration_channel.subscribed) {
          idea_collaboration_channel.trigger('client-typing', {user_id: idea_collaboration_channel.members.me.id})
        }
      },
      onEnd: function() {
        self.hideTyping(idea_collaboration_channel.members.me.id);
        if(idea_collaboration_channel.subscribed) {
          idea_collaboration_channel.trigger('client-notTyping', {user_id: idea_collaboration_channel.members.me.id})
        }
      }
    });

    $(".message-form #message").monitor(typer);

    idea_collaboration_channel.bind('client-typing', function(data) {
      var member = idea_collaboration_channel.members.get(data.user_id)
      member.info.typer.typing();
    });

    idea_collaboration_channel.bind('client-notTyping', function(data) {
      var member = idea_collaboration_channel.members.get(data.user_id)
      member.info.typer.notTyping();
    });

   }

  },

  showTyping: function(member) {
  if(member.id != idea_collaboration_channel.members.me.id) {
     var user = $("#typing_status")
      var typing = $("<div>", {
        "class": "typing",
        text: member.info.name+' is typing...'
      })
      user.find(".typing").remove()
      user.append(typing)
    }
  },

  hideTyping: function(user_id) {
    var user = $("#typing_status")
    user.find(".typing").fadeOut(200, function() {
        $(this).remove()
    })
  },

  remove_member: function(member) {
    $('#presence_'+member.id).remove();
  },

  add_member: function(member) {
    var self = this;
    var content
    var container = $("<li>", {
      "class": "member",
      id: "presence_" + member.id
    }).css({
      "-webkit-transition": "all 0.2s ease-in-out"
    })

    if (member.info.avatar) {
      link = $("<a>", {
        href: member.info.url
      })
      content = link.append($("<img>", {
        src: member.info.avatar,
        valign: "middle",
        width: "20px"
      }))
    }

    if (member.id == idea_collaboration_channel.members.me.id) {
      container.addClass("me")
    }

    if (member.id != idea_collaboration_channel.members.me.id) {
      member.info.typer = new Typer({
        onStart: function() { self.showTyping(member) },
        onEnd: function() { self.hideTyping(member) }
      })
    }

    $('#presence').append(container.html(content));
  },

  addCollaborationMessage: function() {
    var self = this;
    idea_collaboration_channel.bind('collaboration_new_message', function(data) {
      var response = JSON.parse(data.data);
      if(!$('body').hasClass('show-collaboration')) {
        self.speak(response)
      }
      var messages = self.state.messages.reverse();
      var newMessages = [response].concat(messages);
      self.setState({messages: newMessages.reverse()});
      $("#message-"+response.uuid).effect('highlight', {color: '#f2f2f2'} , 3000);
    });
  },

  speak: function(message) {

    var bubble = $("<li>", {
      "class": "bubble"
    })

    var bubble_image = bubble.prepend($("<img>", {
      "class": "bubble-image",
      src: message.user_avatar,
      valign: "left"
    }))

    var content = bubble_image.append($("<p>", {
      "class": "bubble-content",
      text: message.body
    }));

    var options =  {
      content: "<li><img width='40px' src="+message.user_avatar+"><span> "+message.body+"</span></li>", // text of the snackbar
      style: "snackbar", // add a custom class to your snackbar
      timeout: 10000 // time in milliseconds after the snackbar autohides, 0 is disabled
    }
    $.snackbar(options);
  },

  handleMessageSubmit: function ( formData, action, body ) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "POST",
      dataType: "json",
      success: function ( response ) {
        this.setState({loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
      if(this.state.messages) {
        var messages_section =  <MessageSection messages ={this.state.messages}  />;
      } else {
        var messages_section = <div className="loading-component"><i className="ion-loading-d"></i></div>;
      }

      return (<div>
        <aside className="chat-inner" id="my-conversation">
          {messages_section}
        </aside>
       <IdeaMessageComposer loading = {this.state.loading} form = {this.state.form} onMessageSubmit={this.handleMessageSubmit}/>
      </div>


      )
  }

});
