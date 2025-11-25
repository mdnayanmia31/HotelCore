Imports System.Data
Imports System.Data.SqlClient

Public Class RoomRepository
    Implements IRoomRepository

    Public Function GetRoomById(roomID As Integer) As DataRow Implements IRoomRepository.GetRoomById

        Dim parameters As SqlParameter() = {
            SqlHelper.CreateParameter("@RoomID", SqlDbType.Int, roomID)
        }

        Dim dt As DataTable = SqlHelper.ExecuteDataTable("sp_Room_GetById", parameters)

        If dt.Rows.Count > 0 Then
            Return dt.Rows(0)
        End If

        Return Nothing
    End Function

    Public Function GetAllRoomTypes() As DataTable Implements IRoomRepository.GetAllRoomTypes
        Return SqlHelper.ExecuteDataTable("sp_RoomType_GetAll")
    End Function

    Public Function UpdateRoomStatus(roomID As Integer, status As String, notes As String,
                                    currentUserID As Integer, ByRef errorCode As Integer,
                                    ByRef errorMessage As String) As Boolean Implements IRoomRepository.UpdateRoomStatus

        Dim parameters As New List(Of SqlParameter) From {
            SqlHelper.CreateParameter("@RoomID", SqlDbType.Int, roomID),
            SqlHelper.CreateParameter("@Status", SqlDbType.NVarChar, status),
            SqlHelper.CreateParameter("@Notes", SqlDbType.NVarChar, notes),
            SqlHelper.CreateParameter("@CurrentUserID", SqlDbType.Int, currentUserID),
            SqlHelper.CreateOutputParameter("@ErrorCode", SqlDbType.Int),
            SqlHelper.CreateOutputParameter("@ErrorMessage", SqlDbType.NVarChar, 500)
        }

        Dim outputParams As New Dictionary(Of String, Object) From {
            {"@ErrorCode", Nothing},
            {"@ErrorMessage", Nothing}
        }

        SqlHelper.ExecuteWithOutputs("sp_Room_Update", outputParams, parameters.ToArray())

        errorCode = SqlHelper.SafeGetValue(outputParams("@ErrorCode"), -999)
        errorMessage = SqlHelper.SafeGetValue(outputParams("@ErrorMessage"), "Unknown error")

        Return errorCode = 0
    End Function

End Class