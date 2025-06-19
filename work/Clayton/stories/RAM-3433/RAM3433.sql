DECLARE
        @Id UNIQUEIDENTIFIER = NEWID(),
        @Name VARCHAR(500) = 'Utility',
        @CreatedDate DATETIME = GETDATE(),
        @ActiveDate DATETIME = GETDATE(),
        @InactiveDate DATETIME = NULL,
        @TenantId UNIQUEIDENTIFIER = '4bc60b8b-d791-4393-bc86-e52bddd1e9e2';

BEGIN TRY
    BEGIN TRANSACTION
	USE VMFTaskTracker
    INSERT INTO tasktracker.EntityType (
        Id,
        Name,
        CreatedDate,
        ActiveDate,
        InactiveDate,
        TenantId
    ) VALUES (
        @Id,
        @Name,
        @CreatedDate,
        @ActiveDate,
        @InactiveDate,
        @TenantId
    )

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
