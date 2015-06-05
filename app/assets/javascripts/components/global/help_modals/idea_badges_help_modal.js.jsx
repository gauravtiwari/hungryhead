var IdeaBadgesHelpModal = React.createClass({

  getInitialState: function(){
    return {
        bodyHeight: $("html").height() - 100 + "px"
    }
  },

  componentDidMount: function() {
    $(window).resize(this.sizeContent);
    $('#badges_help_modal').slimScroll({height: this.state.bodyHeight});
  },

  sizeContent: function() {
    var newHeight = $("html").height() - 100 + "px";
    this.setState({bodyHeight: newHeight.toString()});
    $('#badges_help_modal').slimScroll({destroy: true});
    $("#badges_help_modal").css("height", newHeight,toString());
    $('#badges_help_modal').slimScroll({height: this.state.bodyHeight});
  },


  render: function() {
    return (
      <div className="modal fade slide-right" id="leaderboardHelpModal" tabIndex="-1" role="dialog" aria-labelledby="newIdeaHelpModalLabel" aria-hidden="true">
       <div className="modal-dialog full-height">
       <div className="modal-content-wrapper">
           <div className="modal-content table-block">
               <button type="button" className="close m-t-10 m-r-10" data-dismiss="modal" aria-hidden="true">
                   <i className="pg-close"></i>
               </button>
               <div className="modal-header">
                   <h5 className="text-left p-b-5"><span className="semi-bold">Idea </span> Glossary</h5>
               </div>
               <div className="modal-body" id="badges_help_modal">
                   <div className="row">
                       <div className="col-md-12">
                         <div>
                           <h3 className="m-t-30">1. Idea Name.</h3>
                           <p>
                             We’re a home for everything from films, games, and music to art, design, and technology. Kickstarter is full of projects, big and small, that are brought to life through the direct support of people like you. Since our launch in 2009, <b>8.4 million people </b> have pledged more than <b>$1.7 billion</b>, funding <b>82,000</b> creative projects. Thousands of creative projects are raising funds on Kickstarter right now.
                           </p>
                         </div>
                         <div>
                           <h3 className="m-t-30">2. Market</h3>
                           <p>
                             The filmmakers, musicians, artists, and designers you see on Kickstarter have complete control over and responsibility for their projects. Kickstarter is a platform and a resource; we’re not involved in the development of the projects themselves. Anyone can launch a project on Kickstarter as long as it follows our rules.
                           </p>
                         </div>
                         <div>
                           <h3 className="m-t-30">2. High concept pitch</h3>
                           <p className="bold">Don't SPAM; Don't be a Jerk</p>
                           <p>
                             Project creators set a funding goal and deadline. If people like a project, they can pledge money to make it happen. Funding on Kickstarter is all-or-nothing — projects must reach their funding goals to receive any money. All-or-nothing funding might seem scary, but it’s amazingly effective in creating momentum and rallying people around an idea. To date, an impressive 44% of projects have reached their funding goals.
                           </p>
                         </div>
                         <div>
                           <h3 className="m-t-30">2. Elevator pitch</h3>
                           <p className="bold">Don't SPAM; Don't be a Jerk</p>
                           <p>
                             Project creators set a funding goal and deadline. If people like a project, they can pledge money to make it happen. Funding on Kickstarter is all-or-nothing — projects must reach their funding goals to receive any money. All-or-nothing funding might seem scary, but it’s amazingly effective in creating momentum and rallying people around an idea. To date, an impressive 44% of projects have reached their funding goals.
                           </p>
                         </div>
                       </div>
                   </div>
               </div>
           </div>
       </div>
       </div>
       </div>
    );
  }
});