SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Srv_TareaProgramada_Mdf] 
    @RucE nvarchar(11),
    @TareaProgramadaID char(10),
    @Correo nvarchar(160),
    @FechaInicio date,
    @FechaFin date,
    @SoloLunes bit,
    @SoloMartes bit,
    @SoloMiercoles bit,
    @SoloJueves bit,
    @SoloViernes bit,
    @SoloSabados bit,
    @SoloDomingos bit,
    @EsRecurrente bit,
    @Hora1 time,
    @Hora2 time,
    @Hora3 time,
    @Estado int,
    @Asunto nvarchar(100),
    @AltaPrioridad bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[TareaProgramada]
	SET    [RucE] = @RucE, [TareaProgramadaID] = @TareaProgramadaID, [Correo] = @Correo, [FechaInicio] = @FechaInicio, [FechaFin] = @FechaFin, [SoloLunes] = @SoloLunes, [SoloMartes] = @SoloMartes, [SoloMiercoles] = @SoloMiercoles, [SoloJueves] = @SoloJueves, [SoloViernes] = @SoloViernes, [SoloSabados] = @SoloSabados, [SoloDomingos] = @SoloDomingos, [EsRecurrente] = @EsRecurrente, [Hora1] = @Hora1, [Hora2] = @Hora2, [Hora3] = @Hora3, [Estado] = @Estado, [Asunto] = @Asunto, [AltaPrioridad] = @AltaPrioridad
	WHERE  [RucE] = @RucE
	       AND [TareaProgramadaID] = @TareaProgramadaID
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [TareaProgramadaID], [Correo], [FechaInicio], [FechaFin], [SoloLunes], [SoloMartes], [SoloMiercoles], [SoloJueves], [SoloViernes], [SoloSabados], [SoloDomingos], [EsRecurrente], [Hora1], [Hora2], [Hora3], [Estado], [Asunto], [AltaPrioridad]
	FROM   [dbo].[TareaProgramada]
	WHERE  [RucE] = @RucE
	       AND [TareaProgramadaID] = @TareaProgramadaID	
	-- End Return Select <- do not remove

	COMMIT

GO
