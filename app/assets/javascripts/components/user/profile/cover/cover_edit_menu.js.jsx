/** @jsx React.DOM */

var CoverEditMenu =  React.createClass({

	render: function() {

	  var cx = React.addons.classSet;

      var save_buttons_class = cx({
      	'change-cover': true,
      	'show': this.props.visible,
        'hidden': !this.props.visible
      });

      var change_icon_class = cx({
      	'save-cover ': true,
      	'hidden': this.props.visible || this.props.loading,
        'show': !this.props.visible
      });

      var spinner_class = cx({
      	'spinner ': true,
      	'show': this.props.loading,
        'hidden': !this.props.loading
      });

      var classes = cx({
        'fa fa-camera': !this.props.loading,
        'fa fa-spinner fa-spin': this.props.loading
      });

	if(this.props.cover.url !== null){
        var menu =  <div className="dropdown pull-right">
        <button href="" className="profile-dropdown-toggle fa fa-camera text-white" title="" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></button>
                  <ul className="dropdown-menu profile-dropdown" role="menu">
                   <li><a onClick={this.props.handleReposition}><i className="fa fa-bars"></i> Reposition</a></li>
                    <li><a href="#" onClick={this.props.triggerOpen}><i className="fa fa-upload"></i> Upload New</a></li>
                    <li><a className="bg-master-lighter" onClick={this.props.handleDelete}>
                      <i className="fa fa-trash-o"></i> Delete
                    </a></li>
                  </ul></div>;
      } else {
        var menu = 
        <div className="dropdown pull-right">
        <button href="" className="profile-dropdown-toggle fa fa-camera text-white" title="" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></button>
        <ul className="dropdown-menu profile-dropdown" role="menu">
                    <li><a href="#" onClick={this.props.triggerOpen}>Upload cover</a></li>
                  </ul></div>;
      }

		return (

      <div className="cover-edit-menu fs-22" id="cover-edit-menu">
          <div className={spinner_class}>
            <span className="text-white fs-14">Please wait... <i className="ion-load-d"></i></span> 
          </div>

          <div className={change_icon_class}>
            {menu}
          </div>

            <div className={save_buttons_class}>
              <a className="btn btn-danger cancel-cover m-r-10" onClick={this.props.onCancel}> <span className="icon-cross5"></span> Cancel</a>
              <a className="btn btn-success save-cover" onClick={this.props.onUpdate}><span className="fa fa-floppy-o"></span> Save </a>
            </div>
      </div>
			)
	}

});