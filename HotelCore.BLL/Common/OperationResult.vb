'' Standard result wrapper for all BLL operations
Public Class OperationResult
    Public Property Success As Boolean
    Public Property Message As String
    Public Property ErrorMessage As String
    Public Property ErrorCode As Integer
End Class

'' Generic result wrapper with data payload
Public Class OperationResult(Of T)
    Inherits OperationResult
    Public Property Data As T
End Class