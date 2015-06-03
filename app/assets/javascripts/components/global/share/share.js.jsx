/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;

var Share = React.createClass({

  mixins: [PureRenderMixin],
  getInitialState: function () {
     return {
      loading: false,
      css_class: this.props.css_class,
      shared: this.props.shared,
      share_url: this.props.share_url,
      shares_count: this.props.shares_count,
      sharers_path: this.props.sharers_path
    };
  },

  loadSharers: function() {
    this.setState({loading: true});
    var path = this.props.sharers_path;
    $('body').append($('<div>', {class: 'sharers_list', id: 'listing_modal'}));
    React.render(
      <ModalListing path={path} key={Math.random()}  />,
      document.getElementById('listing_modal')
    );
    this.setState({loading: false});
    $('#modalListingPopup').modal('show');
    ReactRailsUJS.mountComponents();
  },


  handleShareSubmit: function ( formData ) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: this.state.share_url,
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        if(data.share.shared) {
          $('body textarea').trigger('autosize.destroy');
          $('#sharePopup').modal('hide');
          this.setState({loading: false});
          $('body').pgNotification({style: "simple", message: "<span> You shared " + this.props.shareable_name +"</span>", position: "bottom-left", type: "success",timeout: 5000}).show();
          this.setState({shares_count: data.share.count, shared: data.share.shared});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openShareBox: function() {
    if(this.isMounted()) {
      $('body').append($('<div>', {class: 'idea_share_form', id: 'idea_share_form'}));
      React.render(
        <ShareForm key={this.props.record} loading={this.state.loading} shareable_name={this.props.shareable_name} handleShareSubmit={this.handleShareSubmit} />,
        document.getElementById('idea_share_form')
      );
      $('#sharePopup').modal('show');
    }
  },

  render: function() {
    var css_classes = this.state.css_class;
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });


    var text = this.state.shared ? 'You shared this' : 'Share';

    var voter_text = this.state.shares_count > 1 ? 'people' : 'person';

    if(this.state.shares_count > 0) {
      var voters = <a onClick={this.loadSharers} className="m-l-5"><i className={classes}></i>{this.state.shares_count}</a>;
    }

    var share_link = this.state.shared ?  <span data-toggle="tooltip" data-container="body" title={text} className="fa fa-share-square text-danger">
              </span> :  <a data-toggle="tooltip" data-container="body" title={text} className="fa fa-share-square-o" onClick={this.openShareBox}>
              </a>;

    return (<li className="inline p-l-10 fs-14">
              {share_link}{voters}
            </li>

    );
  }
});
