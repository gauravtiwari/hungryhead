
/** @jsx React.DOM */

var AboutMeForm = React.createClass({

  componentDidMount: function() {
    $('.market_list').tokenfield({
      autocomplete: {
        minLength: 2,
        source: Routes.autocomplete_market_name_markets_path(),
        delay: 100
      },
    showAutocompleteOnFocus: false,
    limit: 3
    });

    $('.skill_list').tokenfield({
      autocomplete: {
        minLength: 2,
        source: Routes.autocomplete_skill_name_skills_path(),
        delay: 100
      },
    showAutocompleteOnFocus: false,
    limit: 3
    });

    $('.technology_list').tokenfield({
      autocomplete: {
        minLength: 2,
        source: Routes.autocomplete_technology_name_technologies_path(),
        delay: 100
      },
    showAutocompleteOnFocus: false,
    limit: 3
    });

    $('.service_list').tokenfield({
      autocomplete: {
        minLength: 2,
        source: Routes.autocomplete_service_name_services_path(),
        delay: 100
      },
    showAutocompleteOnFocus: false,
    limit: 3
    });

    $('.service_list, .technology_list, .skill_list, .market_list').on('tokenfield:createtoken', function (event) {
      var existingTokens = $(this).tokenfield('getTokens');
      $.each(existingTokens, function(index, token) {
          if (token.value === event.attrs.value)
              event.preventDefault();
      });
    });
  },
  render: function(){
    var cx = React.addons.classSet;
    var classes = cx({
      'edit-mode-section': true,
      'show': this.props.mode,
      'hidden': !this.props.mode,
    });

    var markets = this.props.sidebar.markets.map(function(market){
      return market.tag
    });

    var services = this.props.sidebar.services.map(function(service){
      return service.tag
    });

    var technologies = this.props.sidebar.technologies.map(function(technology){
      return technology.tag
    });

    var skills = this.props.sidebar.skills.map(function(skill){
      return skill.tag
    });

    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return(
     <div className={classes}>
        <form ref="sidebar_form"  noValidate="novalidate" onSubmit={this._onKeyDown} className="simple_form edit_user" acceptCharset="UTF-8">
          <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
          <ul className="wrapper-list">
            <li>
              <div className="edit-display-mode">
                <span>Skills</span>
                <div className="edit-display-mode-content">
                  <div className="form-control-wrapper">
                    <input defaultValue={skills} className="string optional skill_list three-tags" placeholder="Add 3 skills" type="text" name="user[skill_list]" id="user_skill_list" />
                  </div>
                </div>
              </div>
            </li>
            
            <li>
              <div className="edit-display-mode">
                <span>Services </span>
                <div className="edit-display-mode-content">
                  <div className="form-control-wrapper">
                    <input defaultValue={services} className="string optional service_list three-tags" placeholder="Add 3 services you can offer" type="text" name="user[service_list]" id="user_service_list" />
                  </div>
                </div>
              </div>
            </li>

            <li>
              <div className="edit-display-mode">
                <span>Technologies </span>
                <div className="edit-display-mode-content">
                  <div className="form-control-wrapper">
                    <input defaultValue={technologies} className="string optional technology_list three-tags" placeholder="Select 3 technologies you know" type="text" name="user[technology_list]" id="user_technology_list" />
                  </div>
                </div>
              </div>
            </li>

            <li>
              <div className="edit-display-mode">
                <span>Markets Interested</span>
                <div className="edit-display-mode-content">
                  <div className="form-control-wrapper">
                    <input defaultValue={markets} className="string optional market_list three-tags" placeholder="Add 3 markets you are interested in" type="text" name="user[market_list]" id="user_market_list" />
                  </div>
                </div>
              </div>
            </li>
          </ul>
          <div className="about-me-forms">
            <button name="button" type="submit" className="main-button"><i className="fa fa-floppy-o"></i> Save <i className={loadingClass}></i></button>
          </div>
      </form>
      </div>
    )
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    var formData = $( this.refs.sidebar_form.getDOMNode() ).serialize();
    this.props.saveSidebarWidget(formData, this.props.form.action);
  }

});
