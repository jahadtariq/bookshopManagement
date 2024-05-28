Imports System.Data.SqlClient
Imports System.Text
Imports System.Security.Cryptography

Partial Class [Default]
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        ' Validate input
        If String.IsNullOrWhiteSpace(loginUsername.Text) Then
            loginUsernameError.Text = "Username is required."
            Return
        End If

        If String.IsNullOrWhiteSpace(loginPassword.Text) Then
            loginPasswordError.Text = "Password is required."
            Return
        End If

        ' Authenticate user
        Dim role As String = AuthenticateUser(loginUsername.Text, loginPassword.Text)

        If Not String.IsNullOrEmpty(role) Then
            If role = "Admin" Then
                Session("LoggedIn") = True
                Session("Role") = "Admin"
                Response.Redirect("Admin.aspx")
            ElseIf role = "Seller" Then
                Session("LoggedIn") = True
                Session("Role") = "Seller"
                Response.Redirect("Seller.aspx")
            End If
        Else
            loginMessage.Text = "Invalid username or password."
        End If
    End Sub

    Protected Sub btnSignup_Click(sender As Object, e As EventArgs)
        ' Validate input
        If String.IsNullOrWhiteSpace(signupUsername.Text) Then
            signupUsernameError.Text = "Username is required."
            Return
        End If

        If String.IsNullOrWhiteSpace(signupPassword.Text) Then
            signupPasswordError.Text = "Password is required."
            Return
        End If

        ' Create user
        Dim success As Boolean = CreateUser(signupUsername.Text, signupPassword.Text, signupRole.SelectedValue)

        If success Then
            signupMessage.Text = "User created successfully. You can now log in."
        Else
            signupMessage.Text = "Failed to create user. Username might already be taken."
        End If
    End Sub

    Private Function CreateUser(username As String, password As String, role As String) As Boolean
        Using conn As New SqlConnection("workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True")
            Dim hashedPassword As String = HashPassword(password)
            Dim cmd As New SqlCommand("INSERT INTO Users (Username, Password, Role) VALUES (@Username, @Password, @Role)", conn)
            cmd.Parameters.AddWithValue("@Username", username)
            cmd.Parameters.AddWithValue("@Password", hashedPassword)
            cmd.Parameters.AddWithValue("@Role", role)

            Try
                conn.Open()
                cmd.ExecuteNonQuery()
                Return True
            Catch ex As SqlException
                ' Handle exceptions
                Return False
            End Try
        End Using
    End Function

    Private Function AuthenticateUser(username As String, password As String) As String
        Dim role As String = String.Empty
        Dim hashedPassword As String = HashPassword(password)

        Using conn As New SqlConnection("workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True")
            Dim cmd As New SqlCommand("SELECT Role,Username FROM Users WHERE Username = @Username AND Password = @Password", conn)
            cmd.Parameters.AddWithValue("@Username", username)
            cmd.Parameters.AddWithValue("@Password", hashedPassword)

            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()

            If reader.Read() Then
                role = reader("Role").ToString()
                Session("Username") = reader("Username").ToString()
            End If
        End Using

        Return role
    End Function

    Private Function HashPassword(password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password)
            Dim hash As Byte() = sha256.ComputeHash(bytes)
            Dim builder As New StringBuilder()
            For Each b As Byte In hash
                builder.Append(b.ToString("x2"))
            Next
            Return builder.ToString()
        End Using
    End Function
End Class
