<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SalesReports.aspx.vb" Inherits="SalesReports" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Report</title>
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
       .buttons-end{
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .custom-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #dee2e6;
        }
        .custom-table th, .custom-table td {
            padding: 8px;
            border: 1px solid #dee2e6;
        }
        .custom-table th {
            background-color: #f8f9fa;
            color: #212529;
            text-align: left;
            font-weight: bold;
        }
        .align-middle {
            vertical-align: middle !important;
        }
        .text-center {
            text-align: center !important;
        }
        .edit-btn, .delete-btn {
            padding: 6px 12px;
            font-size: 14px;
        }
        .container{
            padding: 50px;
        }
        .text-danger{
            color: red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h2>Sales Report</h2>
             <asp:Button ID="logoutButton" runat="server" Text="Logout" CssClass="btn-danger" OnClick="logoutButton_Click" />
        </div>
        <br /><br />
        <div class="container">
            <p>Following are the transactions made:</p><br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="custom-table">
                <Columns>
                    <asp:BoundField DataField="Date" HeaderText="Date" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="TransactionId" HeaderText="TransactionId" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="CustomerId" HeaderText="CustomerId" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="bookId" HeaderText="bookId" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="quantity" HeaderText="quantity" ItemStyle-CssClass="align-middle" />
                </Columns>
            </asp:GridView>
            <br /><br />
            <div class="buttons-end">
                <a href="Admin.aspx" class="btn btn-primary">Back to Admin Dashboard</a>
            </div>
        </div>
    </form>
</body>
</html>
