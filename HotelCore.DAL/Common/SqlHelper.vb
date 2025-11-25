Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class SqlHelper
    ' Reads connection string from Web.config
    Private Shared ReadOnly ConnectionString As String = ConfigurationManager.ConnectionStrings("HotelCore").ConnectionString

    Public Shared Function ExecuteDataTable(spName As String, Optional parameters As SqlParameter() = Nothing) As DataTable
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(spName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                If parameters IsNot Nothing Then cmd.Parameters.AddRange(parameters)

                Dim da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    Public Shared Function ExecuteDataSet(spName As String, Optional parameters As SqlParameter() = Nothing) As DataSet
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(spName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                If parameters IsNot Nothing Then cmd.Parameters.AddRange(parameters)

                Dim da As New SqlDataAdapter(cmd)
                Dim ds As New DataSet()
                da.Fill(ds)
                Return ds
            End Using
        End Using
    End Function

    ' Handles Output Parameters (Needed for Booking Creation)
    Public Shared Sub ExecuteWithOutputs(spName As String, ByRef outputValues As Dictionary(Of String, Object), parameters As SqlParameter())
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(spName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                If parameters IsNot Nothing Then cmd.Parameters.AddRange(parameters)

                conn.Open()
                cmd.ExecuteNonQuery()

                ' Capture outputs
                For Each key In outputValues.Keys.ToList()
                    If cmd.Parameters.Contains(key) Then
                        outputValues(key) = cmd.Parameters(key).Value
                    End If
                Next
            End Using
        End Using
    End Sub

    ' Helper to create parameters quickly
    Public Shared Function CreateParameter(name As String, type As SqlDbType, value As Object) As SqlParameter
        Dim param As New SqlParameter(name, type)
        param.Value = If(value, DBNull.Value)
        Return param
    End Function

    Public Shared Function CreateOutputParameter(name As String, type As SqlDbType, Optional size As Integer = 0) As SqlParameter
        Dim param As New SqlParameter(name, type)
        param.Direction = ParameterDirection.Output
        If size > 0 Then param.Size = size
        Return param
    End Function

    Public Shared Function SafeGetValue(Of T)(value As Object, defaultValue As T) As T
        If value Is Nothing OrElse IsDBNull(value) Then Return defaultValue
        Return CType(value, T)
    End Function
End Class