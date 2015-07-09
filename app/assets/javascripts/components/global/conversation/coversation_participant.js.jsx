var ConversationParticipant = React.createClass({


  render: function() {

    if(this.props.participant.sender_avatar) {
      var placeholder = <img width="40px" className="participant-avatar m-r-10" src={this.props.participant.sender_avatar} alt="Avatar img 20121207 022806" />;
    } else {
      var placeholder = <span className="thumbnail-wrapper d32 circular inline  m-r-10">
      <span className="placeholder no-padding bold text-white participant-avatar">{this.props.participant.sender_name_badge}
              </span></span>;
    }

    return (
       <a key={Math.random()}  href={this.props.participant.sender_path}>
        {placeholder}
       </a>
    );

  },

});



