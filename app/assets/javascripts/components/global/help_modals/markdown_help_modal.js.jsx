var MarkDownHelpModal = React.createClass({

    componentDidMount: function() {
        $.Pages.init();
    },
    render: function() {
        return (
            <div className="modal fade slide-right" id="markdownPopup" tabindex="-1" role="dialog" aria-labelledby="markdownPopupLabel" aria-hidden="true">
            <div className="modal-dialog ">
            <div className="modal-content-wrapper">
                <div className="modal-content table-block scrollable">
                    <div className="modal-header">
                        <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                            <i className="pg-close"></i>
                        </button>
                        <h5 className="text-left p-b-5 b-b b-grey pull-left"><span className="semi-bold">Markdown</span> Help</h5>
                    </div>
                    <div className="modal-body clearfix">
                        <div className="table-content">
                            <p>
                                We use markdown for text formatting. Please use the syntax on the right to style/format your text.
                                You can find more information here <a href="http://daringfireball.net/projects/markdown/syntax">http://daringfireball.net/projects/markdown/syntax</a>
                            </p>
                        </div>
                        <table className="table table-bordered modal-markdown-help-table">
                            <thead>
                                <tr>
                                    <th>Style/Format</th>
                                    <th>Markdown Syntax</th>
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
                                    <td><img src="http://cdn2.hubspot.net/hub/160927/file-259055322-png/Entrepreneur.png" width="100px" /></td>
                                    <td>![image](http://cdn2.hubspot.net/hub/160927/file-259055322-png/Entrepreneur.png)</td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul>
                                            <strong>List</strong>
                                            <li>Item</li>
                                            <li>Item2</li>
                                        </ul>
                                    </td>
                                    <td>* item or - item</td>
                                </tr>
                                <tr>
                                    <td><blockquote>This is a blockquote</blockquote></td>
                                    <td> Greater than symbol </td>
                                </tr>
                                <tr>
                                    <td>
                                        <h1>This is a big heading </h1>
                                        <h2>This is not so big heading </h2>
                                        <h3>This is medium heading </h3>
                                        <h4>This is medium small heading </h4>
                                        <h5>This is a small heading </h5>
                                        <h6>This is a very small heading </h6>
                                    </td>
                                    <td>
                                        <p># Heading</p>
                                        <p>## Heading</p>
                                        <p>### Heading</p>
                                        <p>#### Heading</p>
                                        <p>##### Heading</p>
                                        <p>###### Heading</p>
                                    </td>
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