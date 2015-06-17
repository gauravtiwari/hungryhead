
/** @jsx React.DOM */

var IdeaEditForm = React.createClass({

  getInitialState: function() {
    return {
      loading: false
      }
  },

  componentDidMount: function() {
    if(this.isMounted()){
      $.pubsub('subscribe', 'idea_edit_form_saving', function(msg, data){
        this.setState({loading: data});
      }.bind(this));

      $('#edit_idea_form').validate();
      $('#idea_high_concept_pitch').rules('add', {
        minlength: 20,
        maxlength: 50
      });

      $('#idea_elevator_pitch').rules('add', {
        minlength: 100,
        maxlength: 140
      });

      $("#editIdeaFormPopup").on("hidden.bs.modal", function (e) {
        $('#edit_idea_form_modal').remove();
      });
      $('body textarea').on('focus', function(event) {
        event.preventDefault();
        $(this).autosize();
      });
      this.selectMarkets();
      this.selectLocations();
    }
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
            var markets = self.props.idea.market.map(function(market){
              return {id: Math.random(), text: market.name}
            });
            callback(markets);
          }
        });
      };
    })(this));
  },

  selectLocations: function(e){
    var $locationsSelect = $('#locations_select');
    var self = this;
    $locationsSelect.each((function(_this) {
      return function(i, e) {
        var select;
        select = $(e);
        return $(select).select2({
          minimumInputLength: 2,
          placeholder: select.data('placeholder'),
          tags: true,
          maximumSelectionSize: 1,
          ajax: {
            url: Routes.autocomplete_location_name_locations_path(),
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
            var locations = self.props.idea.location.map(function(location){
              return {id: Math.random(), text: location.name}
            });
            callback(locations);
          }
        });
      };
    })(this));
  },


  render: function() {
    var cx = React.addons.classSet;

    var markets = this.props.idea.market.map(function(market){
      return market.name
    });

    var locations = this.props.idea.location.map(function(location){
      return location.name;
    });

    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    return(
      <div className="modal fade stick-up" id="editIdeaFormPopup" tabIndex="-1" role="dialog" aria-labelledby="editProfileFormPopupLabel" aria-hidden="true">
        <div className="modal-dialog modal-lg">
            <div className="modal-content">
                <div className="modal-header clearfix text-left">
                    <button type="button" className="close" onClick={this.props.closeForm}>
                      <i className="pg-close fs-14"></i>
                    </button>
                    <h5 className="b-b b-grey p-b-5 pull-left">Edit your <span className="semi-bold">Profile</span></h5>
                </div>
                <div className="modal-body p-t-20">
                    <div className="editProfile">
                      <div className="panel panel-default no-border">
                        <div className="panel-body no-padding no-border">
                          <form ref="idea_form" noValidate="novalidate" className="edit_idea" id="edit_idea_form" method="put" onSubmit={this._onKeyDown} acceptCharset="UTF-8">
                            <div className="col-md-6">
                              <div className="form-group">
                                  <label>Idea name</label>
                                  <span className="help"> e.g. "Facebook, twitter" <span className="text-danger">required</span></span>
                                  <input className="string required form-control" required="required" aria-required="true" type="text" defaultValue={this.props.idea.name} name="idea[name]" id="ideaname" />
                              </div>

                              <div className="form-group">
                                  <label>High concept pitch</label>
                                  <span className="help"> e.g. "Linkedin for musicians"  <span className="text-danger">required</span></span>
                                  <input className="string required form-control" required="required" aria-required="true" type="text" placeholder="Linkedin for musicians" defaultValue={this.props.idea.high_concept_pitch}  name="idea[high_concept_pitch]" id="idea_high_concept_pitch" />
                              </div>

                              <div className="form-group">
                                  <label>Location</label>
                                  <span className="help"> e.g. "London, Manchester"</span>
                                  <input className="string required form-control" required="required" aria-required="true" type="text" defaultValue={locations} name="idea[location_list]" id="locations_select" />
                              </div>

                            </div>
                            <div className="col-md-6">

                              <div className="form-group">
                                  <label>Elevator Pitch</label>
                                  <span className="help"> e.g. "100 to 140 characters"  <span className="text-danger">required</span></span>
                                  <textarea className="string required form-control" required="required" aria-required="true" type="text" placeholder="A social music platform for all to collaborate and create music" defaultValue={this.props.idea.elevator_pitch}  name="idea[elevator_pitch]" id="idea_elevator_pitch" ></textarea>
                              </div>

                              <div className="form-group clearfix">
                                <label>Markets interested</label>
                                <span className="help"> e.g. "Ecommerce, SASS"</span>
                                <input defaultValue={markets} className="string optional form-control market_list full-width" required="required" aria-required="true" data-placeholder="Which markets your idea belongs to?" type="text" name="idea[market_list]" id="markets_select" />
                              </div>

                              <div className="m-t-20 pull-right">
                                <button name="commit" className="btn btn-success btn-sm fs-13"><i className={loadingClass}></i> Save</button>
                                <a onClick={this.props.closeForm} id="cancel-edit-profile" className="btn btn-danger btn-sm fs-13 m-l-10">Cancel</a>
                              </div>
                            </div>
                          </form>
                        </div>
                    </div>
                  </div>
                </div>
            </div>
        </div>
    </div>

    )
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    if($(this.refs.idea_form.getDOMNode()).valid()) {
      var formData = $( this.refs.idea_form.getDOMNode() ).serialize();
      this.props.saveIdeaForm(formData, this.props.form.action);
    }
  }

});
