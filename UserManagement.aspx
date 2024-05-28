<%@ Page Language="VB" AutoEventWireup="false" CodeFile="UserManagement.aspx.vb" Inherits="UserManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Management</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
            <h2>User Management</h2>
             <asp:Button ID="logoutButton" runat="server" Text="Logout" CssClass="btn-danger" OnClick="logoutButton_Click" />
        </div>
        <br /><br />
        <div class="container">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="custom-table">
                <Columns>
                    <asp:BoundField DataField="UserId" HeaderText="UserId" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="Username" HeaderText="Username" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="Role" HeaderText="Role" ItemStyle-CssClass="align-middle" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-center align-middle">
                        <ItemTemplate>
                            <button type="button" class="btn btn-warning edit-btn" data-toggle="modal" data-target="#editUserModal">Edit</button>
                            <button type="button" class="btn btn-danger delete-btn" data-toggle="modal" data-target="#deleteUserModal">Delete</button>
                        </ItemTemplate>
                        <ItemStyle CssClass="text-center align-middle" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br /><br />
            <div class="buttons-end">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addUserModal">Add User</button>
                <a href="Admin.aspx" class="btn btn-primary">Back to Admin Dashboard</a>
            </div>


            <!-- Add User Modal -->
            <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addUserModalLabel">Add User</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <asp:Panel ID="pnlAddUser" runat="server">
                                <div class="form-group">
                                    <label for="txtUsername">Username:</label>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ValidationGroup="AddUserValidation"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="Username is required." ValidationGroup="AddUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group">
                                    <label for="txtPassword">Password:</label>
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" ValidationGroup="AddUserValidation"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." ValidationGroup="AddUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="txtPasswordRegex" runat="server"
                                        ControlToValidate="txtPassword" CssClass="error"
                                        ValidationExpression="^(?=.*[A-Z])(?=.*\d)(?=.*[@$_!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                                        ErrorMessage="Password must be at least 8 characters long, contain at least one uppercase letter, one number, and one special character." />
                                </div>
                                <div class="form-group">
                                    <label for="ddlRole">Role:</label>
                                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" ValidationGroup="AddUserValidation">
                                        <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                        <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                                        <asp:ListItem Text="Seller" Value="Seller"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvRole" runat="server" ControlToValidate="ddlRole" ErrorMessage="Role is required." ValidationGroup="AddUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                </div>
                            </asp:Panel>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <asp:Button ID="Button1" runat="server" Text="Submit" CssClass="btn btn-primary" ValidationGroup="AddUserValidation" OnClick="btnSaveUser_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <asp:Panel ID="pnlEditUser" runat="server">
                                <div class="form-group">
                                    <label for="txtEditUsername">Username:</label>
                                    <asp:TextBox ID="txtEditUsername" runat="server" CssClass="form-control" ValidationGroup="EditUserValidation"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEditUsername" runat="server" ControlToValidate="txtEditUsername" ErrorMessage="Username is required." ValidationGroup="EditUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group">
                                    <label for="txtEditUserId">User Id:</label>
                                    <asp:TextBox ID="txtEditUserId" runat="server" CssClass="form-control" ValidationGroup="EditUserValidation"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtEditUserId" ErrorMessage="User Id is required. check table to find user id." ValidationGroup="EditUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group">
                                    <label for="ddlEditRole">Role:</label>
                                    <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-control" ValidationGroup="EditUserValidation">
                                        <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                        <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                                        <asp:ListItem Text="Seller" Value="Seller"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvEditRole" runat="server" ControlToValidate="ddlEditRole" InitialValue="" ErrorMessage="Role is required." ValidationGroup="EditUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                                </div>
                            </asp:Panel>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnUpdateUserChanges" runat="server" Text="Update User" CssClass="btn btn-primary" ValidationGroup="EditUserValidation" OnClick="btnUpdateUser_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Delete User Modal -->
            <div class="modal fade" id="deleteUserModal" tabindex="-1" role="dialog" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteUserModalLabel">Delete User</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="txtDeleteUserId">Confirm User Id to delete:</label>
                                <asp:TextBox ID="txtDeleteUserId" runat="server" CssClass="form-control" ValidationGroup="EditUserValidation"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtDeleteUserId" ErrorMessage="User Id is required. check table to find user id." ValidationGroup="EditUserValidation" CssClass="text-danger"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnDeleteUser" runat="server" Text="Delete User" CssClass="btn btn-danger" OnClick="btnDeleteUser_Click" />
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <asp:HiddenField ID="hiddenUserId" runat="server" />
    </form>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
     <script type="text/javascript">
        $(document).ready(function () {
            $('.edit-btn').click(function () {
                var row = $(this).closest('tr');
                var userId = row.find('td:eq(0)').text().trim();
                var username = row.find('td:eq(1)').text().trim();
                var role = row.find('td:eq(2)').text().trim();
                $('#<%= txtEditUsername.ClientID %>').val(username);
                $('#<%= txtEditUserId.ClientID %>').val(userId);
                $('#<%= ddlEditRole.ClientID %>').val(role);
                $('#<%= hiddenUserId.ClientID %>').val(userId);
            });
        });
     </script>
</body>
</html>
