DECLARE
     @Id UNIQUEIDENTIFIER = NEWID(),
	 @Id1 UNIQUEIDENTIFIER = NEWID(),
	 @Id2 UNIQUEIDENTIFIER = NEWID(),
     @Id3 UNIQUEIDENTIFIER = NEWID(),
     @Id4 UNIQUEIDENTIFIER = NEWID(),
     @TaskTypeId UNIQUEIDENTIFIER = (SELECT Id FROM tasktracker.TaskType WHERE Name = 'Utility'),
     @TaskTypeId2 UNIQUEIDENTIFIER = Null,
     @TenantId UNIQUEIDENTIFIER = '4bc60b8b-d791-4393-bc86-e52bddd1e9e2',
	 @CreatedDate DATETIME = GETDATE(),
     @ActiveDate DATETIME = GETDATE(),
     @InactiveDate DATETIME = NULL;

BEGIN TRY
    BEGIN TRANSACTION

    IF NOT EXISTS (SELECT 1 FROM tasktracker.taskType WHERE Name = 'Manual Adjustments')
    BEGIN
        EXEC tasktracker.usp_TaskType_Insert
            @Id = @Id,
            @Name = 'Manual Adjustments',
            @CreatedDate = @CreatedDate,
            @ActiveDate = @ActiveDate,
            @InactiveDate = @InactiveDate,
            @TenantId = @TenantId;
    END

    IF NOT EXISTS (SELECT 1 FROM tasktracker.taskType WHERE Name = 'Pending Sale')
    BEGIN
        EXEC tasktracker.usp_TaskType_Insert
            @Id = @Id1,
            @Name = 'Pending Sale',
            @CreatedDate = @CreatedDate,
            @ActiveDate = @ActiveDate,
            @InactiveDate = @InactiveDate,
            @TenantId = @TenantId;
    END

    IF NOT EXISTS (SELECT 1 FROM tasktracker.taskSubtype WHERE Name = 'Land')
    BEGIN
        EXEC tasktracker.usp_TaskSubType_Insert
            @Id = @Id2,
            @Name = 'Land',
            @CreatedDate = @CreatedDate,
            @ActiveDate = @ActiveDate,
            @InactiveDate = @InactiveDate,
            @TaskTypeId = @TaskTypeId,
            @TenantId = @TenantId;
    END

    IF NOT EXISTS (SELECT 1 FROM tasktracker.taskType WHERE Name = 'Land')
    BEGIN
        EXEC tasktracker.usp_TaskType_Insert
            @Id = @Id3,
            @Name = 'Land',
            @CreatedDate = @CreatedDate,
            @ActiveDate = @ActiveDate,
            @InactiveDate = @InactiveDate,
            @TenantId = @TenantId;
    END

    SELECT @TaskTypeId2 = Id FROM tasktracker.taskType WHERE Name = 'Land';

    IF NOT EXISTS (SELECT 1 FROM tasktracker.taskSubtype WHERE Name = 'Recovery')
    AND @TaskTypeId2 IS NOT NULL
    BEGIN
        EXEC tasktracker.usp_TaskSubType_Insert
            @Id = @Id4,
            @Name = 'Recovery',
            @CreatedDate = @CreatedDate,
            @ActiveDate = @ActiveDate,
            @InactiveDate = @InactiveDate,
            @TaskTypeId = @TaskTypeId2,
            @TenantId = @TenantId;
    END


    UPDATE tasktracker.taskSubtype t0
    SET t0.Name = 'Establish New Service'
    WHERE t0.Name = 'Land';

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH
