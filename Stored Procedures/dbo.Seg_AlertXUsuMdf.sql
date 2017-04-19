SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Seg_AlertXUsuMdf]
@RucE char(11),
@NomUsu varchar(10),
@Cd_TA char(2),
@IB_NoRecordar bit,
@IB_RecProxIni bit,
@IB_RecCada bit,
@IB_RecDentro bit,
@RecordarCada int,
@RecordarDentro	int,
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE AlertXUsu
	Set IB_NoRecordar=@IB_NoRecordar, IB_RecProxIni=@IB_RecProxIni, IB_RecCada=@IB_RecCada, IB_RecDentro=@IB_RecDentro, RecordarCada=@RecordarCada, RecordarDentro=@RecordarDentro
	Where RucE=@RucE and NomUsu = @NomUsu and Cd_TA=@Cd_TA
	
END
GO
