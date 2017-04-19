SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CajaCons]
@RucE nvarchar(11),
@TipCons int, 
@msj varchar(100) output
as
if(@TipCons=0)
	
	select t1.*, t2.CtaBco from Caja as t1 inner join  CfgCaja  as t2 on t1.Cd_Caja=t2.Cd_Caja where t1.RucE=@RucE 
	
else if(@TipCons=1) 
	
	select Cd_Caja + '  |  '+Nombre as CodNom, Cd_Caja, Nombre from Caja p
	where RucE=@RucE and Estado = 1

else if(@TipCons=3)

	select Cd_Caja + '  |  '+Nombre as Nombre from Caja p
	where RucE=@RucE and Estado = 1

print @msj

--MP : 03/02/2012 <Creacion del procedimiento almacenado>
GO
