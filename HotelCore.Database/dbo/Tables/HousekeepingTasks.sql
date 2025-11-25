CREATE TABLE [dbo].[HousekeepingTasks] (
    [TaskID]            INT             IDENTITY (1, 1) NOT NULL,
    [RoomID]            INT             NOT NULL,
    [BookingID]         INT             NULL,
    [AssignedStaffID]   INT             NULL,
    [TaskType]          NVARCHAR (50)   NOT NULL,
    [Priority]          NVARCHAR (20)   DEFAULT ('Normal') NOT NULL,
    [Status]            NVARCHAR (20)   DEFAULT ('Pending') NOT NULL,
    [DueDateTime]       DATETIME2 (7)   NOT NULL,
    [StartedDateTime]   DATETIME2 (7)   NULL,
    [CompletedDateTime] DATETIME2 (7)   NULL,
    [EstimatedMinutes]  INT             DEFAULT ((30)) NOT NULL,
    [ActualMinutes]     INT             NULL,
    [Notes]             NVARCHAR (1000) NULL,
    [CreatedBy]         INT             NULL,
    [CreatedDate]       DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    [ModifiedBy]        INT             NULL,
    [ModifiedDate]      DATETIME2 (7)   DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([TaskID] ASC),
    CONSTRAINT [CHK_Tasks_Priority] CHECK ([Priority]='Urgent' OR [Priority]='High' OR [Priority]='Normal' OR [Priority]='Low'),
    CONSTRAINT [CHK_Tasks_Status] CHECK ([Status]='Failed' OR [Status]='Cancelled' OR [Status]='Completed' OR [Status]='InProgress' OR [Status]='Assigned' OR [Status]='Pending'),
    CONSTRAINT [CHK_Tasks_Type] CHECK ([TaskType]='Inspection' OR [TaskType]='Maintenance' OR [TaskType]='ConfigChange' OR [TaskType]='DeepClean' OR [TaskType]='Turnover' OR [TaskType]='Checkout'),
    CONSTRAINT [FK_HousekeepingTasks_Booking] FOREIGN KEY ([BookingID]) REFERENCES [dbo].[Bookings] ([BookingID]),
    CONSTRAINT [FK_HousekeepingTasks_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_HousekeepingTasks_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_HousekeepingTasks_Room] FOREIGN KEY ([RoomID]) REFERENCES [dbo].[Rooms] ([RoomID]),
    CONSTRAINT [FK_HousekeepingTasks_Staff] FOREIGN KEY ([AssignedStaffID]) REFERENCES [dbo].[Staff] ([StaffID])
);


GO
CREATE NONCLUSTERED INDEX [IX_HousekeepingTasks_StaffStatus]
    ON [dbo].[HousekeepingTasks]([AssignedStaffID] ASC, [Status] ASC, [DueDateTime] ASC)
    INCLUDE([RoomID], [TaskType], [Priority]);


GO
CREATE NONCLUSTERED INDEX [IX_HousekeepingTasks_RoomStatus]
    ON [dbo].[HousekeepingTasks]([RoomID] ASC, [Status] ASC, [DueDateTime] ASC);

