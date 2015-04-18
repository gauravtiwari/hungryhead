
var ReadMoreInvestment = React.createClass({
  render: function(){
    return (
        <div className="modal fade slide-right" id="readmoreInvestmentPopup" tabindex="-1" role="dialog" aria-labelledby="modalFillInLabel" aria-hidden="true">
        <div className="modal-dialog ">
            <div className="modal-content">
                <button type="button" className="close m-t-10 m-r-10" data-dismiss="modal" aria-hidden="true">
                    <i className="pg-close"></i>
                </button>
                <div className="modal-header">
                    <h5 className="text-left p-b-5"><span className="semi-bold">Idea/Startup </span> Investment</h5>
                </div>
                <div className="modal-body">
                    <div className="row">
                        <div className="col-md-12">
                          <p>"Inc." magazine defines seed funding as the earliest round of capital for a startup company. FundingSavvy, a funding resource website, defines early-stage funding as a startup ideas first round of substantial funding. Early-stage funding usually consists of two parts, commonly known as Series A and Series B financing. Seed funding allows a startup to develop a prototype product and generate sufficient investor interest for successive financing rounds. Early-stage funding allows additional operational flexibility over the medium to long term.</p>
                        </div>

                    </div>
                </div>
                <div className="modal-footer">
                  <button type="button" className="btn btn-danger m-r-10 pull-right" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
        </div>
      );
  }
});