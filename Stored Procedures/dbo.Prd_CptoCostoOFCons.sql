SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Prd_CptoCostoOFCons]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from CptoCostoOF where Cd_OF=@Cd_OF and RucE = @RucE)
	set @msj = 'Concepto de Costo No existe'
else	
	select cof.*,cc.Descrip from CptoCostoOF cof
	inner join cptocosto cc on cc.Ruce=cof.RucE and cc.Cd_Cos=cof.Cd_Cos
	where cof.Cd_OF=@Cd_OF and cof.RucE = @RucE
print @msj

--LEYENDA-- 
--FL: 03/03/2011 <Creacion del procedimiento almacenado >
GO
