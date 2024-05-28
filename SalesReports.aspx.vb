Imports System.Data
Imports System.Data.SqlClient

Public Class SalesReports
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
        Dim query As String = "SELECT * FROM transactions"
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

End Class
