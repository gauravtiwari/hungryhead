/** @jsx React.DOM */

var CoverEditMenu =  React.createClass({

	render: function() {

	  var cx = React.addons.classSet;

      var save_buttons_class = cx({
      	'container change-cover': true,
      	'show': this.props.visible,
        'hidden': !this.props.visible
      });

      var change_icon_class = cx({
      	'container save-cover ': true,
      	'hidden': this.props.visible || this.props.loading,
        'show': !this.props.visible
      });

      var spinner_class = cx({
      	'container spinner ': true,
      	'show': this.props.loading,
        'hidden': !this.props.loading
      });

      var classes = cx({
        'fa fa-camera': !this.props.loading,
        'fa fa-spinner fa-spin': this.props.loading
      });

	if(this.props.cover.url !== null){
        var menu = <ul className="dropdown-menu" role="menu">
                   <li><a onClick={this.props.handleReposition}>Reposition</a></li>
                    <li><a href="#" onClick={this.props.triggerOpen}>Upload New</a></li>
                    <li><a className="delete" onClick={this.props.handleDelete}>
                      Delete
                    </a></li>
                  </ul>;
      } else {
        var menu = <ul className="dropdown-menu" role="menu">
                    <li><a href="#" onClick={this.props.triggerOpen}>Upload cover</a></li>
                  </ul>;
      }

		return (
			<div className="cover-edit-menu" id="cover-edit-menu">

				<div className={spinner_class}>
					<span>Please wait... <i className="ion-load-d"></i></span> 
				</div>

	            <div className={change_icon_class}>
	             <i className="icon-camera3 change-cover dropdown-toggle" data-toggle="dropdown" href="#" id="change-cover-button"></i>
	              {menu}
	            </div>

	          <div className={save_buttons_class}>
	            <a className="main-button cancel-cover" onClick={this.props.onCancel}> <span className="icon-cross5"></span> Cancel</a>
	            <a className="main-button save-cover" onClick={this.props.onUpdate}><span className="fa fa-floppy-o"></span> Save </a>
	          </div>

	        </div>
			)
	}

});