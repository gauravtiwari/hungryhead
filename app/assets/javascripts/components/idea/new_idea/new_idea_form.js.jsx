
var NewIdeaForm = React.createClass({

  componentDidMount: function() {
    this.selectMarkets();
  },

  selectMarkets: function(e){
    var $marketsSelect = $('#markets_select');
    var self = this;
    $marketsSelect.each((function(_this) {
      return function(i, e) {
        var select;
        select = $(e);
        return $(select).select2({
          minimumInputLength: 2,
          placeholder: select.data('placeholder'),
          tags: true,
          maximumSelectionSize: 3,
          ajax: {
            url: Routes.autocomplete_market_name_markets_path(),
            dataType: 'json',
            type: 'GET',
            cache: true,
            quietMillis: 50,
            data: function(term) {
              return {
                term: term
              };
            },
            results: function(data) {
              return {
                results: $.map(data, function(item) {
                  return {
                    text: item.label,
                    value: item.value,
                    id: item.id
                  };
                })
              };
            }
          },
          id: function(object) {
            return object.text;
          },
          initSelection: function (element, callback) {
            var markets = self.props.profile.markets.map(function(market){
              return {id: Math.random(), text: market.tag}
            });
            callback(markets);
          }
        });
      };
    })(this));
  },
  _onSubmit: function(event) {
    event.preventDefault();
    if($(this.refs.form.getDOMNode()).valid()) {
      var formData = $(this.refs.form.getDOMNode()).serialize();
      this._handleSubmit(formData);
    }
  },

  _handleSubmit: function(formData){
    $.post(Routes.ideas_path(), formData, function(data, textStatus, xhr) {
      window.location.href = data.location_url;
    }).fail(function(error){
      $('body').pgNotification({style: "simple", message: error.responseText.toString(), position: "top-right", type: "danger",timeout: 5000}).show();
    });
  },

  newIdeaModalHelp: function() {
    $('body').append($('<div>', {class: 'new_idea_help_modal', id: 'new_idea_help_modal'}));
    React.render(<NewIdeaHelpModal key={Math.random()} />,
      document.getElementById('new_idea_help_modal')
    );
    ReactRailsUJS.mountComponents();
    $('#newIdeaHelpModal').modal('show');
  },

  render: function() {
    return (
      <form className="pitch_idea_form" ref="form" id="pitch_idea_form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={this._onSubmit}>
        <input name="utf8" type="hidden" value="✓" />
        <h5>If you need help, click on question mark to open help popups. <a className="fa fa-question-circle" onClick={this.newIdeaModalHelp}></a></h5>
        <div className="idea-basics m-t-20">
          <div className="col-md-6 no-padding p-r-15">
            <div className="form-group">
            <label>Name</label>
            <span className="help"> "eg: facebook, twitter"</span>
            <input label="false" className="string required form-control empty" placeholder="Idea name" type="text" name="idea[name]" id="idea_name" />
            </div>
            <div className="form-group">
            <label>Select market</label>
              <span className="help"> "eg: social, education"</span>
              <input label="false" className="string optional form-control empty market_list" autofocus="autofocus" placeholder="Add market, maximum 3 markets" type="text" value="" name="idea[market_list]" id="markets_select" />
            </div>
            <div className="input hidden idea_location_list">
              <input className="hidden" autofocus="autofocus" placeholder="Add your location" type="hidden" defaultValue={this.props.meta.location} name="idea[location_list]" id="idea_location_list" />
            </div>
            <div className="form-group m-t-20">
                <div className="checkbox check-success checkbox-circle">
                <input type="checkbox" name="idea[looking_for_team]" defaultValue="1" id="looking_for_team" />
                <label htmlFor="looking_for_team"> Are you looking for a team?</label>
              </div>
            </div>
          </div>
          <div className="col-md-6 no-padding p-l-15">
            <div className="form-group">
              <label>High concept pitch</label>
              <span className="help"> "eg: Commonly, We are X for Y"</span>
              <input label="false" className="string required form-control empty" placeholder="ex: Facebook for business" type="text" name="idea[high_concept_pitch]" id="idea_high_concept_pitch" />
            </div>
            <div className="form-group">
              <label>Elevator Pitch</label>
              <span className="help"> "max: 140 characters (twitter style)"</span>
              <textarea label="false" className="text required form-control empty" placeholder="ex: A social network for everyone, everywhere to connect and share content." name="idea[elevator_pitch]" id="idea_elevator_pitch"></textarea>
            </div>

          <div className="form-buttons pull-right clearfix m-t-20">
            <button name="button" type="submit" className=" btn btn-sm btn-green pull-right fs-13 text-white continue">
              Continue
            </button>
            <small className="clearfix"><strong>Note:</strong> Your idea will not be published until you publish it from profile page.</small>
          </div>
          </div>
        </div>
      </form>
    );
  }
});