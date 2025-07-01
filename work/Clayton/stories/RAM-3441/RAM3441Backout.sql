BEGIN TRY
    BEGIN TRANSACTION

    DELETE FROM tasktracker.EntityType
    WHERE Name = 'Insurance Claim'

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
