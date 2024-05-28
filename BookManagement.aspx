<%@ Page Language="VB" AutoEventWireup="false" CodeFile="BookManagement.aspx.vb" Inherits="BookManagement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Books Management</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <style>
        .error{
            color: red;
        }
        .btn-danger{
            background-color: red;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-danger:hover{
            background-color: orangered;
        }
        .header {
            background-color: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
            display: flex;
            gap: 20px;
            align-items: center;
            justify-content: center;
        }
        .buttons-end{
            display: flex;
            gap: 10px;
            align-items: center;
        }
        /* Custom styles for the page */
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 50px;
        }
        .btn-add-book {
            margin-bottom: 20px;
        }
        .table {
            margin-bottom: 20px;
        }
        /* Custom styles for the modal */
        .modal-content {
            border-radius: 10px;
        }
        .modal-header {
            background-color: #007bff;
            color: #fff;
            border-radius: 10px 10px 0 0;
        }
        .modal-body {
            padding: 20px;
        }
        .modal-footer {
            border-radius: 0 0 10px 10px;
        }
        /* Custom styles for form inputs */
        .form-group {
            margin-bottom: 20px;
        }
        .form-control {
            border-radius: 5px;
        }
        /* Custom styles for buttons */
        .btn {
            border-radius: 5px;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h2>Books Management</h2>
             <asp:Button ID="logoutButton" runat="server" Text="Logout" CssClass="btn-danger" OnClick="logoutButton_Click" />
        </div>
        <br /><br />
        <div class="container">
            <asp:GridView ID="GridViewBooks" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered" OnRowCommand="GridViewBooks_RowCommand">
                <Columns>
                    <asp:BoundField DataField="BookID" HeaderText="Book Id" />
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:BoundField DataField="Author" HeaderText="Author" />
                    <asp:BoundField DataField="Genre" HeaderText="Genre" />
                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                    <asp:BoundField DataField="Price" HeaderText="Price" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-center align-middle">
                        <ItemTemplate>
                            <button type="button" class="btn btn-warning edit-btn" data-toggle="modal" data-target="#editBookModal">Edit</button>
                            <asp:Button ID="btnDeleteBook" runat="server" Text="Delete" CssClass="btn btn-danger" CommandName="DeleteBook" CommandArgument='<%# Eval("BookID") %>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="text-center align-middle" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br /><br />
            <div class="buttons-end">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addBookModal">Add New Book</button>
                <a href="Admin.aspx" class="btn btn-primary">Back to Admin Dashboard</a>
            </div>

            <!-- Add Book Modal -->
            <div class="modal fade" id="addBookModal" tabindex="-1" role="dialog" aria-labelledby="addBookModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addBookModalLabel">Add New Book</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="txtTitle">Title:</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server"
                        ControlToValidate="txtTitle" CssClass="error" ErrorMessage="Title is required." />
                    <asp:RegularExpressionValidator ID="TitleValidator" runat="server"
                        ControlToValidate="txtTitle" CssClass="error"
                        ValidationExpression="^[^\d]*$"
                        ErrorMessage="Title cannot contain numbers." />
                </div>
                <div class="form-group">
                    <label for="txtAuthor">Author:</label>
                    <asp:TextBox ID="txtAuthor" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="AuthorRequired" runat="server"
                        ControlToValidate="txtAuthor" CssClass="error" ErrorMessage="Author is required." />
                    <asp:RegularExpressionValidator ID="AuthorValidator" runat="server"
                        ControlToValidate="txtAuthor" CssClass="error"
                        ValidationExpression="^[a-zA-Z\s]+$"
                        ErrorMessage="Author must be a valid name (letters and spaces only)." />
                </div>
                <div class="form-group">
                    <label for="txtPublisher">Publisher:</label>
                    <asp:TextBox ID="txtPublisher" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="PublisherRequired" runat="server"
                        ControlToValidate="txtPublisher" CssClass="error" ErrorMessage="Publisher is required." />
                    <asp:RegularExpressionValidator ID="PublisherValidator" runat="server"
                        ControlToValidate="txtPublisher" CssClass="error"
                        ValidationExpression="^[a-zA-Z\s]+$"
                        ErrorMessage="Publisher must be a valid name (letters and spaces only)." />
                </div>
                <div class="form-group">
                    <label for="txtGenre">Genre:</label>
                    <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="GenreRequired" runat="server"
                        ControlToValidate="txtGenre" CssClass="error" ErrorMessage="Genre is required." />
                    <asp:RegularExpressionValidator ID="GenreValidator" runat="server"
                        ControlToValidate="txtGenre" CssClass="error"
                        ValidationExpression="^[a-zA-Z\s]+$"
                        ErrorMessage="Genre must be a valid name (letters and spaces only)." />
                </div>
                <div class="form-group">
                    <label for="txtQuantity">Quantity:</label>
                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="QuantityRequired" runat="server"
                        ControlToValidate="txtQuantity" CssClass="error" ErrorMessage="Quantity is required." />
                    <asp:RangeValidator ID="QuantityValidator" runat="server"
                        ControlToValidate="txtQuantity" CssClass="error" MinimumValue="1" MaximumValue="10000"
                        Type="Integer" ErrorMessage="Quantity must be a positive integer." />
                </div>
                <div class="form-group">
                    <label for="txtPrice">Price:</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="PriceRequired" runat="server"
                        ControlToValidate="txtPrice" CssClass="error" ErrorMessage="Price is required." />
                    <asp:RangeValidator ID="PriceValidator" runat="server"
                        ControlToValidate="txtPrice" CssClass="error" MinimumValue="0.01" MaximumValue="1000000"
                        Type="Double" ErrorMessage="Price must be greater than zero." />
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnSaveBook" runat="server" Text="Save Book" CssClass="btn btn-primary" OnClick="btnSaveBook_Click" />
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


            <!-- Edit Book Modal -->
            <div class="modal fade" id="editBookModal" tabindex="-1" role="dialog" aria-labelledby="editBookModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editBookModalLabel">Edit Book</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <asp:Panel ID="pnlEditBook" runat="server">
                                <div class="form-group">
                                    <label for="txtEditTitle">Title:</label>
                                    <asp:TextBox ID="txtEditTitle" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label for="txtEditAuthor">Author:</label>
                                    <asp:TextBox ID="txtEditAuthor" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label for="txtEditGenre">Genre:</label>
                                    <asp:TextBox ID="txtEditGenre" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label for="txtEditQuantity">Quantity:</label>
                                    <asp:TextBox ID="txtEditQuantity" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label for="txtEditPrice">Price:</label>
                                    <asp:TextBox ID="txtEditPrice" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </asp:Panel>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnUpdateBook" runat="server" Text="Update Book" CssClass="btn btn-primary" OnClick="btnUpdateBook_Click" />
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hiddenBookId" runat="server" />
        <asp:HiddenField ID="hiddenDeleteBookId" runat="server" />
    </form>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.edit-btn').click(function () {
                var row = $(this).closest('tr');
                var bookId = row.find('td:eq(0)').text().trim();
                var title = row.find('td:eq(1)').text().trim();
                var author = row.find('td:eq(2)').text().trim();
                var genre = row.find('td:eq(3)').text().trim();
                var quantity = row.find('td:eq(4)').text().trim();
                var price = row.find('td:eq(5)').text().trim();
                $('#<%= txtEditTitle.ClientID %>').val(title);
                $('#<%= txtEditAuthor.ClientID %>').val(author);
                $('#<%= txtEditGenre.ClientID %>').val(genre);
                $('#<%= txtEditQuantity.ClientID %>').val(quantity);
                $('#<%= txtEditPrice.ClientID %>').val(price);
                $('#<%= hiddenBookId.ClientID %>').val(bookId);
            });

            $('.delete-btn').click(function () {
                var row = $(this).closest('tr');
                var bookId = row.find('td:eq(0)').text().trim();
                $('#<%= hiddenDeleteBookId.ClientID %>').val(bookId);
            });
        });
    </script>
</body>
</html>
