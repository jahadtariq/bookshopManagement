<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bookshop Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('./background.jpg');
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        .tabs {
            width: 100%;
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }
        .tabs button {
            width: 100%;
            background: none;
            border: none;
            padding: 10px;
            cursor: pointer;
            font-weight: bold;
            border-bottom: 1px solid #000;
        }
        .tabs button.active {
            color: #007BFF;
            border-bottom: 1px solid #007BFF;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
        }
        .error {
            color: red;
            font-size: 0.9em;
        }
        .submit{
            padding: 10px;
            background-color: #007BFF;
            border: none;
            color: #fff;
        }
        .success {
            color: green;
            font-size: 0.9em;
        }
        .heading{
            text-align: center;
            font-weight: bold;
            font-size: 30px;
        }
    </style>
    <script>
        function showTab(tabId) {
            document.getElementById('signupForm').style.display = (tabId === 'signup') ? 'block' : 'none';
            document.getElementById('loginForm').style.display = (tabId === 'login') ? 'block' : 'none';
            document.getElementById('signupTab').classList.toggle('active', tabId === 'signup');
            document.getElementById('loginTab').classList.toggle('active', tabId === 'login');
        }
        window.onload = function () {
            showTab('login');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2 class="heading">Bookshop Management System</h2>
            <div class="tabs">
                <button type="button" id="loginTab" onclick="showTab('login')">Login</button>
                <button type="button" id="signupTab" onclick="showTab('signup')">Signup</button>
            </div>
            <div id="loginForm" style="display: none;">
                <div class="form-group">
                    <label for="loginUsername">Username</label>
                    <asp:TextBox ID="loginUsername" runat="server" CssClass="form-control" />
                    <asp:Label ID="loginUsernameError" runat="server" CssClass="error" />
                </div>
                <div class="form-group">
                    <label for="loginPassword">Password</label>
                    <asp:TextBox ID="loginPassword" runat="server" CssClass="form-control" TextMode="Password" />
                    <asp:Label ID="loginPasswordError" runat="server" CssClass="error" />
                </div>
                <asp:Button CssClass="submit" ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
                <asp:Label ID="loginMessage" runat="server" />
            </div>
            <div id="signupForm" style="display: none;">
                <div class="form-group">
                    <label for="signupUsername">Username</label>
                    <asp:TextBox ID="signupUsername" runat="server" CssClass="form-control" />
                    <asp:Label ID="signupUsernameError" runat="server" CssClass="error" />
                </div>
                <div class="form-group">
                    <label for="signupPassword">Password</label>
                    <asp:TextBox ID="signupPassword" runat="server" CssClass="form-control" TextMode="Password" />
                    <asp:Label ID="signupPasswordError" runat="server" CssClass="error" />
                </div>
                <div class="form-group">
                    <label for="signupPassword">User Role</label>
                    <asp:DropDownList ID="signupRole" runat="server">
                        <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                        <asp:ListItem Text="Seller" Value="Seller"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <asp:Button CssClass="submit" ID="btnSignup" runat="server" Text="Signup" OnClick="btnSignup_Click" />
                <asp:Label ID="signupMessage" runat="server" />
            </div>
        </div>
    </form>
    <asp:Label ID="Label1" runat="server" />
</body>
</html>
