/** @jsx React.DOM */

var RegisterationInfoBox = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
  
    
    return ( <ul className="social-buttons">
                  <li id="facebook">
                  <a className="main-button login button-facebook" data-disable-with="<i className='fa fa-spinner fa-spin'></i> Logging in..." href="/users/auth/facebook?display=popup"> 
                  <i className="fa fa-facebook"></i> Login with Facebook </a>
                </li>
                  <li id="twitter">
                    <a className="main-button login button-twitter" data-disable-with="<i className='fa fa-spinner fa-spin'></i> Logging in..." href="/users/auth/twitter"> 
                    <i className="fa fa-twitter"></i> Login with Twitter </a>
                  </li>
                  <li id="linkedin">
                  <a className="main-button login button-linkedin" data-disable-with="<i className='fa fa-spinner fa-spin'></i> Logging in..." href="/users/auth/linkedin"> 
                  <i className="fa fa-linkedin"></i>  Login with Linkedin </a></li>                
                  
                </ul>
    );
  }

});
