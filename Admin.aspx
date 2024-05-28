<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Admin.aspx.vb" Inherits="Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <style>
        /* Basic CSS for layout and styling */
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
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 20px auto;
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
        .content {
            margin-top: 20px;
        }
        .card {
            background-color: #f4f4f4;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .card-header {
            background-color: #ddd;
            padding: 10px;
            font-weight: bold;
            border-bottom: 1px solid #ccc;
        }
        .card-body {
            padding: 10px 0;
        }
        .btn {
            background-color: #007bff;
            color: #fff;
            padding: 8px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>Admin Dashboard</h1>
            <asp:Button ID="logoutButton" runat="server" Text="Logout" CssClass="btn-danger" OnClick="logoutButton_Click" />
        </div>
        <div class="container">
            <div class="content">
                <div class="card">
                    <div class="card-header">User Management</div>
                    <div class="card-body">
                        <a href="UserManagement.aspx" class="btn">Manage Users</a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">Book Management</div>
                    <div class="card-body">
                        <a href="BookManagement.aspx" class="btn">Manage Books</a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">All Sales</div>
                    <div class="card-body">
                        <a href="SalesReports.aspx" class="btn">View Sales</a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
