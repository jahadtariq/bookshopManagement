Imports System.Data
Imports System.Data.SqlClient

Public Class UserManagement
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindUsers()
        End If
        If Session("LoggedIn") Is Nothing OrElse Not CBool(Session("LoggedIn")) Then
            ' User is not logged in, redirect to Default.aspx
            Response.Redirect("Default.aspx")
        End If

        If Not Session("Role").ToString().Equals("Admin") Then

            ClientScript.RegisterStartupScript(Me.GetType(), "ErrorMessage", "alert('Access Denied!');", True)

            Response.Redirect("Seller.aspx")
        End If
    End Sub

    Protected Sub logoutButton_Click(ByVal sender As Object, ByVal e As EventArgs) Handles logoutButton.Click
        Session("LoggedIn") = False
        Session("Role") = ""
        Response.Redirect("Default.aspx")
    End Sub

    Private Sub BindUsers()
        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "SELECT * FROM Users"
        Dim dt As New DataTable()

        Try
            Using con As New SqlConnection(connectionString)
                Using cmd As New SqlCommand(query, con)
                    con.Open()
                    dt.Load(cmd.ExecuteReader())
                End Using
            End Using
        Catch ex As Exception
            ' Handle the exception (e.g., log it, display an error message)
            Response.Write("Error: " & ex.Message)
        End Try

        GridView1.DataSource = dt
        GridView1.DataBind()
    End Sub


    Protected Sub btnSaveUser_Click(sender As Object, e As EventArgs)
        If Page.IsValid Then
            Dim username As String = txtUsername.Text.Trim()
            Dim password As String = txtPassword.Text.Trim()
            Dim role As String = ddlRole.SelectedValue

            ' Your database connection and insert query code here
            Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
            Dim query As String = "INSERT INTO Users (Username, Role, Password) VALUES (@Username, @Role, @Password)"

            Using con As New SqlConnection(connectionString)
                Using cmd As New SqlCommand(query, con)
                    cmd.Parameters.AddWithValue("@Username", username)
                    cmd.Parameters.AddWithValue("@Password", password)
                    cmd.Parameters.AddWithValue("@Role", role)
                    con.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            ' Close the modal after saving
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideModalScript", "<script>$('#addUserModal').modal('hide');</script>", False)

            ' Rebind the GridView to display the updated list of users
            BindUsers()
        End If
    End Sub


    Protected Sub btnUpdateUser_Click(sender As Object, e As EventArgs)
        Dim username As String = txtEditUsername.Text.Trim()
        Dim userId As String = txtEditUserId.Text.Trim()
        Dim role As String = ddlEditRole.SelectedValue

        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "UPDATE Users SET Username = @Username, Role = @Role WHERE UserID = @UserID"

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@Username", username)
                cmd.Parameters.AddWithValue("@Role", role)
                cmd.Parameters.AddWithValue("@UserID", userId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ' Close the modal after saving
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideModalScript", "<script>$('#editUserModal').modal('hide');</script>", False)

        ' Rebind the GridView to display the updated list of users
        BindUsers()
    End Sub


    Protected Sub btnDeleteUser_Click(sender As Object, e As EventArgs)
        If Page.IsValid Then
            Dim selectedUserID As String = txtDeleteUserId.Text.Trim()
            Console.WriteLine("Got user ID")
            ' Your database connection and delete query code here
            Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
            Console.WriteLine("Connection string recieved")
            Dim query As String = "DELETE FROM Users WHERE UserID = @UserID"

            Using con As New SqlConnection(connectionString)
                Using cmd As New SqlCommand(query, con)
                    cmd.Parameters.AddWithValue("@UserID", selectedUserID) ' Assuming you have a variable to store the selected user's ID
                    con.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            Console.WriteLine("User Deleted from databse")

            ' Close the modal after deleting
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideModalScript", "<script>$('#deleteUserModal').modal('hide');</script>", False)

            Console.WriteLine("Modal reset")
            ' Rebind the GridView to display the updated list of users
            BindUsers()
        End If
    End Sub

    Protected Sub GridViewUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "EditUser" Then
            Dim userId As String = e.CommandArgument.ToString()
            Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
            Dim query As String = "SELECT Username, Role FROM Users WHERE UserID = @UserID"

            Using con As New SqlConnection(connectionString)
                Using cmd As New SqlCommand(query, con)
                    cmd.Parameters.AddWithValue("@UserID", userId)
                    con.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        reader.Read()
                        If reader.HasRows Then
                            Dim username As String = reader("Username").ToString()
                            Dim role As String = reader("Role").ToString()

                            txtEditUsername.Text = username
                            txtEditUserId.Text = userId
                            ddlEditRole.SelectedValue = role
                            hiddenUserId.Value = userId

                            ' Show the edit user modal
                            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModalScript", "<script>$('#editUserModal').modal('show');</script>", False)
                        End If
                    End Using
                End Using
            End Using
        End If
    End Sub

End Class
