/** @jsx React.DOM */

var PlanVideo = React.createClass({
   
    render: function() {
        return (
            <div className={this.props.video_classes}>
                <iframe src={"http://www.youtube.com/embed/" + this.props.videoID}
                        frameBorder="0"
                        allowFullScreen>
                </iframe>
            </div>
        );
    }

});