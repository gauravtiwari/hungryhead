/** @jsx React.DOM */

var Card = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      profile: data.user.profile,
      form: data.user.about_me.form,
      is_owner: data.user.is_owner,
      loading: false,
      mode: false
    }
  },

  componentDidMount: function() {
    this.setState({disabled: false})
  },

  saveSidebarWidget:function(formData, action) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({profile: data.user.profile});
        this.setState({mode: false, loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openForm: function() {
    this.setState({mode: !this.state.mode});
  },

  render: function() {

  if(this.state.is_owner) {
    if(this.state.mode){
      var text = <span className="fa fa-times-circle"> Cancel</span>;
    } else {
      var text = <span className="fa fa-pencil"> Edit</span>;
    }
  } else {
    var text = "";
  }
    return (
      <div>
        <CardContent key={Math.random()} openForm={this.openForm} text={text} data={this.props.data} is_owner={this.state.is_owner} mode={this.state.mode} profile={this.state.profile} />
        <CardStats key={Math.random()} openForm={this.openForm} mode={this.state.mode} profile={this.state.profile} />
        <CardForm key={Math.random()} openForm={this.openForm} profile={this.state.profile} mode={this.state.mode} loading={this.state.loading} form={this.state.form} saveSidebarWidget ={this.saveSidebarWidget} />
      </div>
    );
  }

});
