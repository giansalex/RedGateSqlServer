SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GRPtoLlegadaCons]
@RucE nvarchar(11),
@Cd_GR char(10),
@TipCons int,
@msj varchar(100) output
as
if(@TipCons=0)
	select * from GRPtoLlegada where RucE = @RucE and Cd_GR = @Cd_GR
/*--FALTA IMPLEMENTAR
else if(@TipCons=1)
	select Cd_Mca+'  |  '+Nombre,Cd_Mca,Nombre from Marca where Estado=1 and  RucE = @RucE
else if(@TipCons=2)
	select Cd_Mca,Nombre,Descrip,NCorto,Estado, CA01,CA02,CA03  from Marca where Estado=1 and  RucE = @RucE
else if(@TipCons=3)
	select Cd_Mca,Cd_Mca,Nombre from Marca where Estado=1 and  RucE = @RucE
*/
print @msj
-- Leyenda --
-- PP : 2010-05-05 13:55:06.573	: <Creacion del procedimiento almacenado>
GO
