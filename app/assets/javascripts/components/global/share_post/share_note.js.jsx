/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;
var SharePost = React.createClass({
  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      form: JSON.parse(this.props.form)
    };
  },

  handleSharePostSubmit: function ( formData ) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.posts_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        if(data.created) {
          $('body textarea').trigger('autosize.destroy');
          $('#sharePostPopup').modal('hide');
          this.setState({loading: false});
          $('body').pgNotification({style: "simple", message: "Your shared your post successfully ", position: "bottom-left", type: "success",timeout: 5000}).show();
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openShareBox: function() {
    if(this.isMounted()) {
      $('body').append($('<div>', {class: 'share_post_form', id: 'share_post_form'}));
      React.render(
        <SharePostForm key={Math.random()} loading={this.state.loading} form={this.state.form.form} handleSharePostSubmit={this.handleSharePostSubmit} />,
        document.getElementById('share_post_form')
      );
      $.Pages.init();
      $('#sharePostPopup').modal('show');
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
