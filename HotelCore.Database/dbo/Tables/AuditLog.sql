CREATE TABLE [dbo].[AuditLog] (
    [AuditID]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [UserID]      INT            NULL,
    [TableName]   NVARCHAR (100) NOT NULL,
    [RecordID]    INT            NOT NULL,
    [ActionType]  NVARCHAR (20)  NOT NULL,
    [OldValues]   NVARCHAR (MAX) NULL,
    [NewValues]   NVARCHAR (MAX) NULL,
    [IPAddress]   NVARCHAR (50)  NULL,
    [UserAgent]   NVARCHAR (500) NULL,
    [CreatedDate] DATETIME2 (7)  DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([AuditID] ASC),
    CONSTRAINT [CHK_Audit_ActionType] CHECK ([ActionType]='LOGOUT' OR [ActionType]='LOGIN' OR [ActionType]='DELETE' OR [ActionType]='UPDATE' OR [ActionType]='INSERT'),
    CONSTRAINT [FK_AuditLog_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_AuditLog_UserDate]
    ON [dbo].[AuditLog]([UserID] ASC, [CreatedDate] ASC)
    INCLUDE([TableName], [ActionType]);

