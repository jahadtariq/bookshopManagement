Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Partial Class [Default]
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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


End Class
