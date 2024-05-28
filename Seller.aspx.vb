Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Partial Class [Default]
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            noBookInfo.Visible = False
            bookInfo.Visible = False
            sellButton.Visible = False
        End If

        If Session("LoggedIn") Is Nothing OrElse Not CBool(Session("LoggedIn")) Then
            ' User is not logged in, redirect to Default.aspx
            Response.Redirect("Default.aspx")
        End If
    End Sub

    Protected Sub logoutButton_Click(ByVal sender As Object, ByVal e As EventArgs) Handles logoutButton.Click
        Session("LoggedIn") = False
        Session("Role") = ""
        Response.Redirect("Default.aspx")
    End Sub

    Protected Sub btnFetchBookInfo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnFetchBookInfo.Click
        ' Fetch book information based on seller's input
        Dim bookName As String = txtBookName.Text.Trim()
        Dim authorName As String = txtAuthorName.Text.Trim()
        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim query As String = "SELECT * FROM Books WHERE Title = @BookName AND Author = @AuthorName"

        Using con As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@BookName", bookName)
                cmd.Parameters.AddWithValue("@AuthorName", authorName)
                con.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()

                If reader.Read() Then
                    ' Show book information
                    bookInfo.Visible = True
                    ' Display book details fetched from database
                    lblBookName.Text = reader("Title").ToString()
                    lblAuthorName.Text = reader("Author").ToString()
                    lblPrice.Text = reader("Price").ToString()

                    ' Save book price in a hidden field for later use
                    hiddenBookPrice.Value = reader("Price").ToString()
                    HiddenBookQuantity.Value = reader("Quantity").ToString()
                    HiddenBookID.Value = reader("BookID").ToString()
                    sellButton.Visible = True
                Else
                    noBookInfo.Visible = True
                End If
            End Using
        End Using
    End Sub

    Protected Sub sellBook_Click(ByVal sender As Object, ByVal e As EventArgs) Handles sellBook.Click
        ' Show the customer type modal
        ClientScript.RegisterStartupScript(Me.GetType(), "OpenModal", "$('#customerTypeModal').modal('show');", True)
    End Sub

    Protected Sub btnNewCustomer_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnNewCustomer.Click
        ' Show the new customer modal
        ClientScript.RegisterStartupScript(Me.GetType(), "OpenNewCustomerModal", "$('#newCustomerModal').modal('show');", True)
    End Sub

    Protected Sub btnOldCustomer_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnOldCustomer.Click
        ' Show the old customer modal
        ClientScript.RegisterStartupScript(Me.GetType(), "OpenOldCustomerModal", "$('#oldCustomerModal').modal('show');", True)
    End Sub

    Protected Sub btnSubmitNewCustomer_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitNewCustomer.Click
        ' Insert new customer details into the Customers table
        Dim username As String = txtUsername.Text.Trim()
        Dim fullName As String = txtFullName.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim address As String = txtAddress.Text.Trim()
        Dim quantity As Integer = Integer.Parse(txtQuantity.Text.Trim())
        Dim fetchedBookId As Integer = Integer.Parse(HiddenBookID.Value)
        Dim bookPrice As Decimal = Decimal.Parse(hiddenBookPrice.Value)
        Dim totalAmount As Decimal = bookPrice * quantity
        Dim OldQuantity As Integer = Integer.Parse(HiddenBookQuantity.Value)
        Dim NewQuantity As Integer = (OldQuantity - quantity)

        If (quantity > OldQuantity) Then
            txtQuantityError.Text = "Quantity is more than available in store!"
        ElseIf (quantity < 1) Then
            txtQuantityError.Text = "Quantity of book should at least be 1!"
        Else
            Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
            Dim customerQuery As String = "INSERT INTO Customers (Username, FullName, Email, Phone, Address) VALUES (@Username, @FullName, @Email, @Phone, @Address); SELECT SCOPE_IDENTITY();"
            Dim bookQuery As String = "UPDATE Books SET Quantity = @Quantity WHERE BookID = @BookId"
            Dim transactionQuery As String = "INSERT INTO Transactions (CustomerId, TotalAmount, bookId, quantity) VALUES (@CustomerId, @TotalAmount, @BookId, @Quantity)"

            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim transaction As SqlTransaction = con.BeginTransaction()

                Try
                    Dim customerId As Integer

                    Using customerCmd As New SqlCommand(customerQuery, con, transaction)
                        customerCmd.Parameters.AddWithValue("@Username", username)
                        customerCmd.Parameters.AddWithValue("@FullName", fullName)
                        customerCmd.Parameters.AddWithValue("@Email", email)
                        customerCmd.Parameters.AddWithValue("@Phone", phone)
                        customerCmd.Parameters.AddWithValue("@Address", address)

                        customerId = Convert.ToInt32(customerCmd.ExecuteScalar())
                    End Using

                    Using bookCmd As New SqlCommand(bookQuery, con, transaction)
                        bookCmd.Parameters.AddWithValue("@Quantity", NewQuantity)
                        bookCmd.Parameters.AddWithValue("@BookId", fetchedBookId)
                        bookCmd.ExecuteNonQuery()  ' Execute the book update query
                    End Using

                    Using transactionCmd As New SqlCommand(transactionQuery, con, transaction)
                        transactionCmd.Parameters.AddWithValue("@CustomerId", customerId)
                        transactionCmd.Parameters.AddWithValue("@TotalAmount", totalAmount)
                        transactionCmd.Parameters.AddWithValue("@BookId", fetchedBookId)
                        transactionCmd.Parameters.AddWithValue("@Quantity", quantity)
                        transactionCmd.ExecuteNonQuery()  ' Execute the transaction query
                    End Using

                    transaction.Commit()

                    ClientScript.RegisterStartupScript(Me.GetType(), "SuccessMessage", "alert('Transaction successful!');", True)
                Catch ex As Exception
                    transaction.Rollback()
                    ClientScript.RegisterStartupScript(Me.GetType(), "ErrorMessage", "alert('Transaction failed: " & ex.Message & "');", True)
                End Try
            End Using
        End If
    End Sub


    Protected Sub btnSubmitOldCustomer_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitOldCustomer.Click
        ' Get customer ID and quantity for the old customer
        Dim customerId As Integer = Integer.Parse(txtCustomerId.Text.Trim())
        Dim quantity As Integer = Integer.Parse(txtQuantityOldCustomer.Text.Trim())
        Dim bookPrice As Decimal = Decimal.Parse(hiddenBookPrice.Value)
        Dim fetchedBookId As Integer = Integer.Parse(HiddenBookID.Value)
        Dim OldQuantity As Integer = Integer.Parse(HiddenBookQuantity.Value)
        Dim NewQuantity As Integer = (OldQuantity - quantity)
        Dim totalAmount As Decimal = bookPrice * quantity

        Dim connectionString As String = "workstation id=BookProject.mssql.somee.com;packet size=4096;user id=Muhammad_Jahad_SQLLogin_1;pwd=18zd2cutfs;data source=BookProject.mssql.somee.com;persist security info=False;initial catalog=BookProject;TrustServerCertificate=True"
        Dim transactionQuery As String = "INSERT INTO Transactions (CustomerId, TotalAmount, bookId, quantity) VALUES (@CustomerId, @TotalAmount, @BookId, @Quantity)"
        Dim bookQuery As String = "UPDATE Books SET Quantity = @Quantity WHERE BookID = @BookId"

        If (quantity > OldQuantity) Then
            txtQuantityError.Text = "Quantity is more than available in store!"
        ElseIf (quantity < 1) Then
            txtQuantityError.Text = "Quantity of book should at least be 1!"
        Else
            Using con As New SqlConnection(connectionString)
                con.Open()
                Dim transaction As SqlTransaction = con.BeginTransaction()

                Try
                    Using transactionCmd As New SqlCommand(transactionQuery, con, transaction)
                        transactionCmd.Parameters.AddWithValue("@CustomerId", customerId)
                        transactionCmd.Parameters.AddWithValue("@TotalAmount", totalAmount)
                        transactionCmd.Parameters.AddWithValue("@BookId", fetchedBookId)
                        transactionCmd.Parameters.AddWithValue("@Quantity", quantity)
                        transactionCmd.ExecuteNonQuery()  ' Execute the transaction query
                    End Using

                    Using bookCmd As New SqlCommand(bookQuery, con, transaction)
                        bookCmd.Parameters.AddWithValue("@Quantity", NewQuantity)
                        bookCmd.Parameters.AddWithValue("@BookId", fetchedBookId)
                        bookCmd.ExecuteNonQuery()  ' Execute the book update query
                    End Using

                    transaction.Commit()
                    ' Show success message
                    ClientScript.RegisterStartupScript(Me.GetType(), "SuccessMessage", "alert('Transaction successful!');", True)
                Catch ex As Exception
                    ' Show error message
                    transaction.Rollback()
                    ClientScript.RegisterStartupScript(Me.GetType(), "ErrorMessage", "alert('Transaction failed: " & ex.Message & "');", True)
                End Try
            End Using
        End If
    End Sub
End Class
