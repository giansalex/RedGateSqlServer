SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Seg_AlertAsigCons3]
@RucE char(11),
@NomUsu varchar(10),
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	
	Select au.RucE, au.NomUsu, au.Cd_TA, ta.Descrip, case IB_NoRecordar When 1 Then 'Inactiva' Else 'Activa' End as 'Activa', au.IB_NoRecordar, au.IB_RecProxIni, au.IB_RecCada, au.IB_RecDentro, au.RecordarCada, au.RecordarDentro, au.CampoConfg
	From AlertXUsu au join TipAlert ta on (au.Cd_TA = ta.Cd_TA)
	Where RucE = @RucE and NomUsu=@NomUsu
	Set @msj = ''
END


--exec Seg_AlertAsigCons2 '11111111111','lrios',null
GO
