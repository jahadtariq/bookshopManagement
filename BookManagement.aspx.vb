Imports System.Data
Imports System.Data.SqlClient

Public Class BookManagement
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindBooks()
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

    Private Sub BindBooks()
        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "SELECT * FROM Books"
        Dim dt As New DataTable()

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                con.Open()
                dt.Load(cmd.ExecuteReader())
            End Using
        End Using

        GridViewBooks.DataSource = dt
        GridViewBooks.DataBind()
    End Sub

    Protected Sub btnSaveBook_Click(sender As Object, e As EventArgs)
        Dim title As String = txtTitle.Text.Trim()
        Dim author As String = txtAuthor.Text.Trim()
        Dim publisher As String = txtPublisher.Text.Trim()
        Dim genre As String = txtGenre.Text.Trim()
        Dim quantity As Integer = Convert.ToInt32(txtQuantity.Text)
        Dim price As Decimal = Convert.ToDecimal(txtPrice.Text)

        ' Your database connection and insert query code here
        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "INSERT INTO Books (Title, Author, Genre, Quantity, Price, Publisher) VALUES (@Title, @Author, @Genre, @Quantity, @Price, @Publisher)"

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@Title", title)
                cmd.Parameters.AddWithValue("@Author", author)
                cmd.Parameters.AddWithValue("@Genre", genre)
                cmd.Parameters.AddWithValue("@Quantity", quantity)
                cmd.Parameters.AddWithValue("@Price", price)
                cmd.Parameters.AddWithValue("@Publisher", publisher)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ' Close the modal after saving
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideModalScript", "<script>$('#addBookModal').modal('hide');</script>", False)

        ' Rebind the GridView to display the updated list of books
        BindBooks()
    End Sub

    Protected Sub GridViewBooks_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewBooks.RowCommand
        If e.CommandName = "DeleteBook" Then
            Dim bookId As Integer = Convert.ToInt32(e.CommandArgument)
            DeleteBook(bookId)
        ElseIf e.CommandName = "EditBook" Then
            Dim bookId As Integer = Convert.ToInt32(e.CommandArgument)
            LoadBookDetailsForEdit(bookId)
        End If
    End Sub

    Private Sub LoadBookDetailsForEdit(bookId As Integer)
        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "SELECT * FROM Books WHERE BookID = @BookID"

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@BookID", bookId)
                con.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    txtEditTitle.Text = reader("Title").ToString()
                    txtEditAuthor.Text = reader("Author").ToString()
                    txtEditGenre.Text = reader("Genre").ToString()
                    txtEditQuantity.Text = reader("Quantity").ToString()
                    txtEditPrice.Text = reader("Price").ToString()
                    hiddenBookId.Value = bookId.ToString()
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModalScript", "<script>$('#editBookModal').modal('show');</script>", False)
                End If
            End Using
        End Using
    End Sub

    Protected Sub btnUpdateBook_Click(sender As Object, e As EventArgs)
        Dim bookId As Integer = Convert.ToInt32(hiddenBookId.Value)
        Dim title As String = txtEditTitle.Text.Trim()
        Dim author As String = txtEditAuthor.Text.Trim()
        Dim genre As String = txtEditGenre.Text.Trim()
        Dim quantity As Integer = Convert.ToInt32(txtEditQuantity.Text)
        Dim price As Decimal = Convert.ToDecimal(txtEditPrice.Text)

        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "UPDATE Books SET Title = @Title, Author = @Author, Genre = @Genre, Quantity = @Quantity, Price = @Price WHERE BookID = @BookID"

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@Title", title)
                cmd.Parameters.AddWithValue("@Author", author)
                cmd.Parameters.AddWithValue("@Genre", genre)
                cmd.Parameters.AddWithValue("@Quantity", quantity)
                cmd.Parameters.AddWithValue("@Price", price)
                cmd.Parameters.AddWithValue("@BookID", bookId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ' Close the modal after updating
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideEditModalScript", "<script>$('#editBookModal').modal('hide');</script>", False)

        ' Rebind the GridView to display the updated list of books
        BindBooks()
    End Sub

    Private Sub DeleteBook(bookId As Integer)
        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "DELETE FROM Books WHERE BookID = @BookID"

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@BookID", bookId)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ' Rebind the GridView to reflect the changes
        BindBooks()
    End Sub
End Class
