/**
 * @jsx React.DOM
*/

var MarkDownHelpModal = React.createClass({
    render: function() {
        return (
            <article className="modal" tabIndex="-1" role="dialog" id="markdownPopup" aria-labelledby="markdownPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
                <div className="modal-dialog modal-lg">
                <header className="profile-wrapper-title">
                    <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
                    <h4>Markdown cheatsheet</h4>
                </header>
                <section className="modal-content regular-padding margin-top">
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
                    </section>
                 </div>
             </article>

            );
    }
});