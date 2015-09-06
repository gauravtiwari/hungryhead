var EventDescription = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      description: data.description,
      event_url: data.event_url,
      is_owner: data.is_owner,
      loading: false,
      min_length: false,
      editing: false
    }
  },

  handleClick: function(e) {
    e.preventDefault();
    this.setState({
      editing: !this.state.editing
    });
  },

  showMarkDownModal: function(){
    $('body').append($('<div>', {class: 'markdown-modal', id: 'markdown-modal'}));
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },

  handleSubmit: function(formData){
    this.setState({loading: true});
    $.ajax({
      url: this.state.event_url,
      type: 'PATCH',
      dataType: 'json',
      data: formData,
    })
    .done(function(data) {
      this.setState({
        description: data.event.description,
        editing: !this.state.editing,
        loading: false
      });
      $('body').pgNotification({style: "simple", message: "Event updated", position: "top-right", type: "success",timeout: 5000}).show();
    }.bind(this))
    .fail(function(xhr, status, err) {
      this.setState({loading: false});
      var errors = JSON.parse(xhr.responseText);
      $.each(errors, function(keys, values) {
        $('body').pgNotification({style: "simple", message: (keys.toUpperCase() + " " + values).toString(), position: "top-right", type: "danger",timeout: 5000}).show();
      });
      console.error(this.state.event_url, status, err.toString());
    }.bind(this))
  },

  _onSubmit: function(event) {
    event.preventDefault();
    var event_description = this.refs.event_description.getDOMNode().value.trim();
    if($(this.refs.event_form.getDOMNode()).valid()) {
      var formData = $( this.refs.event_form.getDOMNode() ).serialize();
      this.handleSubmit(formData);
    }
    event.stopPropagation();
  },

  countLength: function(e){
    e.preventDefault();
    this.setState({
      description: $(e.target).val()
    });
  },

  render: function() {

    var cx = React.addons.classSet;

    var form_classes = cx({
      'event_description_form clearfix': true,
      'show': this.state.editing,
      'hidden': !this.state.editing,
    });

    var button_classes = cx({
      'main-button m-r-10 fs-13 bold': true,
      'disabled': this.state.description.length < 300 || this.state.description.length > 2000
    });

    var classes = cx({
      'event_description clearfix': true,
      'show': !this.state.editing,
      'hidden': this.state.editing,
    });

    var count_class = cx({
      "chars_count pull-right text-danger fs-12": true,
      'chars-overflow': this.state.description.length > 2000 || this.state.description.length < 300
    });

    var loading_class = cx ({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var html = this.state.is_owner && this.state.description.length === 0 ? "<div class='no-content'>Enter event details<span>Details about location</span></div>" : marked(this.state.description)

    var text = this.state.editing ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span>Click to edit <i className="fa fa-pencil"></i> </span>;
    if(this.state.is_owner) {
      return (
        <div className="EventDescription">
          <div className="panel">
            <div className="panel-heading p-b-10 p-l-60 p-r-60">
              <div className="panel-title fs-22 text-master">
                <i className="fa fa-calendar"></i> Description
              </div>
              <div className="panel-controls pull-right">
                <ul>
                  <li>
                    <a className="portlet-maximize pointer text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Markdown help <i className="fa fa-question-circle"></i></a>
                  </li>
                  <li>
                    <a href="javascript:void(0)" id="event_description_edit" className="portlet-close pointer text-master fs-12" onClick={this.handleClick}>
                      {text}
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            <div className="panel-body m-t-10 fs-16 p-l-60 p-r-60">
              <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
              <div className={form_classes}>
                <form id="event_form" ref="event_form" className="event_description_form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={this._onSubmit}>
                  <div className="form-group">
                    <label forHtml="event_description">Enter details about the event </label>
                    <span className="help clearfix"> You can use markdown to format your text styles. Click Markdown help.</span>
                    <textarea ref="event_description" onChange={this.countLength} className="text required form-control empty" defaultValue={this.state.description} required="required" name="event[description]" id="event_description_textarea"></textarea>
                  </div>
                  <label className={count_class} id="descrition_count">{this.state.description.length} chars (min. 300 - max: 2000)</label>
                  <div className="form-buttons pull-right clearfix m-t-10">
                    <button type="submit" className={button_classes}><span className={loading_class}></span> Save</button>
                    <a type="submit" onClick={this.handleClick} className="main-button pointer fs-13 bold">Cancel</a>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      );
    } else {
      return (
        <div className="EventDescription">
          <div className="panel">
            <div className="panel-heading p-b-10">
              <div className="panel-title fs-22 b-b b-grey p-b-5 text-master">
                <i className="fa fa-calendar"></i> Event Description
              </div>
            </div>
            <div className="panel-body m-t-10 fs-16" id="event_description">
              <div className={classes} dangerouslySetInnerHTML={{__html: marked(this.state.description)}}></div>
            </div>
          </div>
        </div>
      );
    }
  }
});