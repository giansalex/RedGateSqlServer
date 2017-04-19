SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_CptoCostoOFDocCons]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
@msj varchar(100) output
as
if not exists (select * from CptoCostoOFDoc where Cd_OF=@Cd_OF and RucE = @RucE and Id_CCOF=@Id_CCOF)
	set @msj = 'Documento relacionado a Concepto de Costo no existe'
else	
	select c.*, isnull(cc.BIM_S,0)+isnull(cc.BIM_E,0)+isnull(cc.BIM_C,0) as Costo
 from CptoCostoOFDoc c inner join compra as cc on c.Ruce = cc.RucE and c.Cd_Com = cc.Cd_Com
	where c.Id_CCOF=@Id_CCOF and c.Cd_OF=@Cd_OF and c.RucE = @RucE

print @msj

--LEYENDA-- 
--FL: 04/03/2011 <Creacion del procedimiento almacenado >


GO
