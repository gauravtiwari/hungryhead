/**
 * @jsx React.DOM
*/

var MarkDownHelpModal = React.createClass({
    render: function() {
        return (
            <div className="modal fade stick-up" id="markdownPopup" tabindex="-1" role="dialog" aria-labelledby="markdownPopupLabel" aria-hidden="true">
            <div className="modal-dialog ">
                <div className="modal-content">
                    <div className="modal-header">
                                        <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                        <i className="pg-close"></i>
                    </button>
                        <h5 className="text-left p-b-5"><span className="semi-bold">Markdown</span> Help</h5>
                    </div>
                    <div className="modal-body">
                    <div className="row">
                    <div className="table-content">
                        <p>We use markdown for text formatting. Please use the code on the right to format your text.</p>
                    </div>
                    <table className="table table-bordered modal-markdown-help-table">
                        <thead>
                            <tr>
                                <th>Result</th>
                                <th>Markdown</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Bold</strong></td>
                                <td>**text**</td>
                            </tr>
                            <tr>
                                <td><em>Emphasize</em></td>
                                <td>*text*</td>
                            </tr>
                            <tr>
                                <td><a href="http://www.example.com/">Link</a></td>
                                <td>[Link](http://example.com/)</td>
                            </tr>
                            <tr>
                                <td>Image</td>
                                <td>![image](http://)</td>
                            </tr>
                            <tr>
                                <td>List</td>
                                <td>* item</td>
                            </tr>
                            <tr>
                                <td>Blockquote</td>
                                <td> quote</td>
                            </tr>
                            <tr>
                                <td>H1</td>
                                <td># Heading</td>
                            </tr>
                        </tbody>
                    </table>
                    </div>
                    </div>
                </div>
            </div>
            </div>

            );
    }
});