CREATE TABLE [dbo].[StaffSchedule] (
    [ScheduleID]   INT            IDENTITY (1, 1) NOT NULL,
    [StaffID]      INT            NOT NULL,
    [ShiftDate]    DATE           NOT NULL,
    [StartTime]    TIME (7)       NOT NULL,
    [EndTime]      TIME (7)       NOT NULL,
    [Status]       NVARCHAR (20)  DEFAULT ('Scheduled') NOT NULL,
    [Notes]        NVARCHAR (500) NULL,
    [CreatedBy]    INT            NULL,
    [CreatedDate]  DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    [ModifiedBy]   INT            NULL,
    [ModifiedDate] DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([ScheduleID] ASC),
    CONSTRAINT [CHK_Schedule_Status] CHECK ([Status]='Cancelled' OR [Status]='Absent' OR [Status]='Completed' OR [Status]='Active' OR [Status]='Scheduled'),
    CONSTRAINT [CHK_Schedule_Time] CHECK ([EndTime]>[StartTime]),
    CONSTRAINT [FK_StaffSchedule_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_StaffSchedule_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID]),
    CONSTRAINT [FK_StaffSchedule_Staff] FOREIGN KEY ([StaffID]) REFERENCES [dbo].[Staff] ([StaffID])
);


GO
CREATE NONCLUSTERED INDEX [IX_StaffSchedule_StaffDate]
    ON [dbo].[StaffSchedule]([StaffID] ASC, [ShiftDate] ASC)
    INCLUDE([StartTime], [EndTime], [Status]);


GO
CREATE NONCLUSTERED INDEX [IX_StaffSchedule_DateStatus]
    ON [dbo].[StaffSchedule]([ShiftDate] ASC, [Status] ASC)
    INCLUDE([StaffID], [StartTime], [EndTime]);

