/** @jsx React.DOM */

var AboutMe = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      sidebar: data.user.about_me.sidebar,
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
        this.setState({sidebar: data.user.about_me.sidebar});
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
      var text = <span className="ion-close"> Cancel</span>;
    } else {
      var text = <span className="ion-edit"> Edit</span>;
    }
  } else {
    var text = "";
  }
    return (
      <div>
        <AboutMeHeader key={Math.random()}  text={text} openForm={this.openForm} />
        <AboutMeContent key={Math.random()} is_owner={this.state.is_owner} mode={this.state.mode} sidebar={this.state.sidebar} />
        <AboutMeForm key={Math.random()} sidebar={this.state.sidebar} mode={this.state.mode} loading={this.state.loading} form={this.state.form} saveSidebarWidget ={this.saveSidebarWidget} />
      </div>
    );
  }

});
