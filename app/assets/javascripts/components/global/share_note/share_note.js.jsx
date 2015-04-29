/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;
var ShareNote = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      form: JSON.parse(this.props.form)
    };
  },

  handleShareNoteSubmit: function ( formData ) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.notes_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        if(data.created) {
          $('body textarea').trigger('autosize.destroy');
          $('#shareNotePopup').modal('hide');
          this.setState({loading: false});
          $('body').pgNotification({style: "simple", message: "Your note posted successfully ", position: "bottom-left", type: "success",timeout: 5000}).show();
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openShareBox: function() {
    if(this.isMounted()) {
      $('body').append($('<div>', {class: 'share_note_form', id: 'share_note_form'}));
      React.render(
        <ShareNoteForm key={Math.random()} loading={this.state.loading} form={this.state.form.form} handleShareNoteSubmit={this.handleShareNoteSubmit} />,
        document.getElementById('share_note_form')
      );
      $.Pages.init();
      $('#shareNotePopup').modal('show');
    }
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    return (<a onClick={this.openShareBox} id="notification-center" className="fa fa-pencil b-r b-grey p-r-10 b-dashed fs-22 text-brand pointer">
            </a>

    );
  }
});
