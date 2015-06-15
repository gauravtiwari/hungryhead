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

    $(".add-comment #message").monitor(typer);

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
    } else {

      placeholder = $('<div>', {
        "class": "thumbnail-wrapper absolute m-r-5 d32 circular bordered b-white"
      })
      content = placeholder.append($("<span>", {
        text: member.info.name.split(' ')[0].split('')[0] + member.info.name.split(' ')[1].split('')[0],
        "class": "placeholder bold text-white"
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
  },

  handleMessageSubmit: function ( formData, action, body ) {
    message = {
      body: body,
      uuid: Math.random(),
      user_id: window.currentUser.id,
      user_name: window.currentUser.name,
      user_avatar: window.currentUser.avatar,
      user_name_badge: window.currentUser.user_name_badge
    }
    var new_message = this.state.messages.concat(message);
    this.setState({messages: new_message});
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

      return (  <div className="view chat-view bg-white clearfix">
          <MessageSection messages ={this.state.messages}  />
          <span id="typing_status"></span>
        <IdeaMessageComposer loading = {this.state.loading} form = {this.state.form} onMessageSubmit={this.handleMessageSubmit}/>
      </div>


      )
  }

});
