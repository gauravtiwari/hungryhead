var IdeaLeaderboardHelpModal = React.createClass({

  getInitialState: function(){
    return {
        bodyHeight: $("html").height() - 100 + "px"
    }
  },

  componentDidMount: function() {
    $(window).resize(this.sizeContent);
    $('#leaderboard_help_modal').slimScroll({height: this.state.bodyHeight});
  },

  sizeContent: function() {
    var newHeight = $("html").height() - 100 + "px";
    this.setState({bodyHeight: newHeight.toString()});
    $('#leaderboard_help_modal').slimScroll({destroy: true});
    $("#leaderboard_help_modal").css("height", newHeight,toString());
    $('#leaderboard_help_modal').slimScroll({height: this.state.bodyHeight});
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
                   <h5 className="text-left p-b-5"><span className="semi-bold b-b b-grey p-b-5">Leaderboard </span> Glossary</h5>
               </div>
               <div className="modal-body" id="leaderboard_help_modal">
                   <div className="row">
                       <div className="col-md-12">
                         <div>
                           <h3 className="m-t-30">Idea Score </h3>
                           <p>
                             <span className="bold">Idea score</span> is total score of an idea calculated from total
                             feedbacks, votes, investments and comments made on an idea.

                             <p>A total score of 10K is needed to make an idea qualify as a <span className="bold">validated idea</span></p>
                           </p>
                         </div>
                         <div>
                           <h3 className="m-t-30">Trending Score </h3>
                           <p>
                             Trending score is calculated from total unique views.
                           </p>
                         </div>
                         <div>
                           <h3 className="m-t-30">Point rules </h3>
                           <ul className="no-style">
                            <li className="m-b-10"><span className="bold">Feedback: </span> For every feedback, an idea earns 15 points</li>
                            <li className="m-b-10"><span className="bold">Investment: </span> For every investment, an idea earns 25 points</li>
                            <li className="m-b-10"><span className="bold">Vote: </span> For every vote, an idea earns 5 points</li>
                            <li className="m-b-10"><span className="bold">Comment: </span> For every comment, an idea earns 2 points</li>
                           </ul>
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