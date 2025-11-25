Imports System.Data
Public Interface IBookingRepository
    Function SearchRooms(startDateTime As DateTime, endDateTime As DateTime,
                        configID As Integer?, minOccupancy As Integer,
                        maxPrice As Decimal?, amenityIDs As String,
                        floorNumber As Integer?) As DataTable

    Function CheckAvailability(roomID As Integer, startDateTime As DateTime,
                              endDateTime As DateTime) As DataSet

    Function CreateBooking(userID As Integer, roomID As Integer,
                          startDateTime As DateTime, endDateTime As DateTime,
                          guestCount As Integer, configID As Integer?,
                          specialRequests As String, currentUserID As Integer,
                          ByRef errorCode As Integer, ByRef errorMessage As String) As Integer

    Function AddGuest(bookingID As Integer, guest As GuestModel, currentUserID As Integer,
                 ByRef errorCode As Integer, ByRef errorMessage As String) As Integer

    Function CancelBooking(bookingID As Integer, cancellationReason As String,
                          currentUserID As Integer, ByRef errorCode As Integer,
                          ByRef errorMessage As String) As Boolean

    Function GetBookingById(bookingID As Integer, userID As Integer?) As DataSet

    Function GetBookingsByUser(userID As Integer, status As String,
                              startDate As Date?, endDate As Date?) As DataTable

    Function CheckInBooking(bookingID As Integer, currentUserID As Integer,
                           ByRef errorCode As Integer, ByRef errorMessage As String) As Boolean

    Function CheckOutBooking(bookingID As Integer, currentUserID As Integer,
                            ByRef errorCode As Integer, ByRef errorMessage As String) As Boolean

    Function GetBookingTimeline(bookingID As Integer) As DataTable

    Function AddTimelineEvent(bookingID As Integer, eventType As String,
                             eventDateTime As DateTime, title As String,
                             description As String, actionURL As String) As Integer
End Interface
