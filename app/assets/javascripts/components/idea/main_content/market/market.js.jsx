/** @jsx React.DOM */
var converter = new Showdown.converter();
var Market = React.createClass({

  getInitialState: function() {
    return {
      mode: false,
      editable: false,
      loading: false,
      alreadyOpened: false,
      editing_user: "",
      editing_user_id: null
    }
  },

  componentDidMount: function() {
    var self = this;
    $.pubsub('subscribe', 'closeSectionForm', function(msg, data){
      self.setState({loading: data, editable: false});
    });
  },

  handleMarketSubmit: function(formData, body) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.idea_path(this.props.idea.id),
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        if(data.error) {
          this.setState({error: data.error});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openMarketForm: function() {
    var idea = this.state.idea;
    this.setState({editable: !this.state.editable});
  },

  showMarkDownModal: function(){
    $('body').append($('<div>', {class: 'markdown-modal', id: 'markdown-modal'}));
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'idea-market': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

    var text = this.state.editable ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span><i className="fa fa-pencil"></i> Edit market</span>;

    if(this.props.idea.sections && this.props.idea.sections.market) {
      var html = converter.makeHtml(this.props.idea.sections.market);
      var market_classes = "section-content market";
    } else {
      var html = "<div class='no-content text-center fs-16 light'>Describe the market for your idea. <span>People you are targeting? Estimated numbers? Any metrices? etc.</span> </div>";
      var market_classes = "section-content canvas-placeholder sales-marketing market";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="panel box-shadow">
          {error}
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title b-b b-grey p-b-5 text-master">Describe your market</div>
            <div className="panel-controls p-r-60">
            <ul>
              <li>
                <a className="portlet-maximize text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close text-master fs-12" onClick={this.openMarketForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div onClick={this.openMarketForm} className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <MarketForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleMarketSubmit= {this.handleMarketSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
      <div className="panel bg-light-blue box-shadow">
        <div className="panel-heading p-l-60 p-b-10">
          <div className="panel-title b-b b-grey p-b-5 text-master">Market</div>
        </div>
        <div className="panel-body p-l-60 p-r-60 text-master">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    )
    }
  }
});
