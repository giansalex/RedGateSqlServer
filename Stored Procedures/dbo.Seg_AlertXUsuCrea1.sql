SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Seg_AlertXUsuCrea1]
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
	
	Insert Into AlertXUsu
	(RucE,Cd_TA,NomUsu,IB_NoRecordar,IB_RecProxIni,IB_RecCada,IB_RecDentro,RecordarCada,RecordarDentro,CampoConfg)
	Values(@RucE,@Cd_TA,@NomUsu,@IB_NoRecordar,@IB_RecProxIni,@IB_RecCada,@IB_RecDentro,@RecordarCada,@RecordarDentro,'')
	
END
GO
