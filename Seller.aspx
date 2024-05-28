<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Seller.aspx.vb" Inherits="Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Seller Dashboard</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
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
        .no_book-message{
            color: red;
            font-weight: bold;
            font-size: 18px;
        }
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 50px;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #007bff;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-control {
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
        .label {
            font-weight: bold;
        }
        .table thead th {
            border-bottom: none;
        }
        .table td, .table th {
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h2>Seller Page</h2>
             <asp:Button ID="logoutButton" runat="server" Text="Logout" CssClass="btn-danger" OnClick="logoutButton_Click" />
        </div>
        <br /><br />
        <div class="container">
            <h1>Sell A Book</h1>
            <div class="form-group">
                <label for="txtBookName" class="label">Book Name:</label>
                <asp:TextBox ID="txtBookName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtAuthorName" class="label">Author Name:</label>
                <asp:TextBox ID="txtAuthorName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <asp:Button ID="btnFetchBookInfo" runat="server" Text="Fetch Book Info" CssClass="btn btn-primary" OnClick="btnFetchBookInfo_Click" />
            <div id="bookInfo" runat="server" class="mt-4">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th colspan="2" class="text-center">Book Information</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>Book Name:</th>
                            <td><asp:Label ID="lblBookName" runat="server"></asp:Label></td>
                        </tr>
                        <tr>
                            <th>Author Name:</th>
                            <td><asp:Label ID="lblAuthorName" runat="server"></asp:Label></td>
                        </tr>
                        <tr>
                            <th>Price:</th>
                            <td>
                                <asp:Label ID="lblPrice" runat="server"></asp:Label>
                                <asp:HiddenField ID="hiddenBookPrice" runat="server" />
                                <asp:HiddenField ID="HiddenBookQuantity" runat="server" />
                                <asp:HiddenField ID="HiddenBookID" runat="server" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div id="sellButton" runat="server" class="mt-4">
                    <asp:Button runat="server" ID="sellBook" Text="Sell the book" CssClass="btn btn-success" OnClick="sellBook_Click" />
                </div>
            </div>
            <div id="noBookInfo" class="mt-4" runat="server">
                <p class="no_book-message">No Book Found ! Please Try again.</p>
            </div>
        </div>

        <!-- Modal for selecting customer type -->
        <div class="modal fade" id="customerTypeModal" tabindex="-1" role="dialog" aria-labelledby="customerTypeModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="customerTypeModalLabel">Select Customer Type</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <asp:Button runat="server" ID="btnNewCustomer" Text="New Customer" CssClass="btn btn-primary" OnClick="btnNewCustomer_Click" />
                        <asp:Button runat="server" ID="btnOldCustomer" Text="Old Customer" CssClass="btn btn-primary" OnClick="btnOldCustomer_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for new customer details -->
        <div class="modal fade" id="newCustomerModal" tabindex="-1" role="dialog" aria-labelledby="newCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="newCustomerModalLabel">New Customer Details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="txtUsername" class="label">Username:</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtFullName" class="label">Full Name:</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtEmail" class="label">Email:</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtPhone" class="label">Phone:</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtAddress" class="label">Address:</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtQuantity" class="label">Quantity of Book:</label>
                            <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:Label ID="txtQuantityError" runat="server" CssClass="no_book-message"></asp:Label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <asp:Button runat="server" ID="btnSubmitNewCustomer" Text="Submit" CssClass="btn btn-success" OnClick="btnSubmitNewCustomer_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for old customer details -->
        <div class="modal fade" id="oldCustomerModal" tabindex="-1" role="dialog" aria-labelledby="oldCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="oldCustomerModalLabel">Old Customer Details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="txtCustomerId" class="label">Customer ID:</label>
                            <asp:TextBox ID="txtCustomerId" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtQuantityOldCustomer" class="label">Quantity of Book:</label>
                            <asp:TextBox ID="txtQuantityOldCustomer" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <asp:Button runat="server" ID="btnSubmitOldCustomer" Text="Submit" CssClass="btn btn-success" OnClick="btnSubmitOldCustomer_Click" />
                    </div>
                </div>
            </div>
        </div>

    </form>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Show customer type modal when sell button is clicked
        $('#<%= sellBook.ClientID %>').on('click', function (e) {
            e.preventDefault();
            $('#customerTypeModal').modal('show');
        });

        // Show new customer modal
        $('#<%= btnNewCustomer.ClientID %>').on('click', function (e) {
            e.preventDefault();
            $('#customerTypeModal').modal('hide');
            $('#newCustomerModal').modal('show');
        });

        // Show old customer modal
        $('#<%= btnOldCustomer.ClientID %>').on('click', function (e) {
            e.preventDefault();
            $('#customerTypeModal').modal('hide');
            $('#oldCustomerModal').modal('show');
        });
    </script>
</body>
</html>
