SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Prd_OrdFabricacionConsPag1]
@RucE nvarchar(11),
@TamPag int,
@EstaAut bit,
@msj varchar(100) output
as
BEGIN

declare @consulta varchar(8000)
IF(@EstaAut=1)
BEGIN
set @consulta= 'select top '+convert(nvarchar,@TamPag)+' orf.Cd_OF,orf.NroOF, Convert(varchar,orf.FecE,103) as FecEmi, Convert(varchar,orf.FecEntR,103) as FecEntR, orf.Asunto ,est.Descrip
from ordfabricacion orf 
Left Join EstadoOF est on est.Id_EstOF = orf.Id_EstOF and est.IB_Activo=1
Where IB_Aut=1 and Cd_OF not in (select CdOF_BASE from ordfabricacion where CdOF_BASE is not null) and orf.RucE='''+@RucE+''' and orf.Id_EstOF = ''01'' or orf.Id_EstOF = ''03'' order by Cd_OF asc'
print @consulta
exec (@consulta)
END
ELSE IF(@EstaAut=0)
BEGIN
set @consulta= 'select top '+convert(nvarchar,@TamPag)+' orf.Cd_OF,orf.NroOF, Convert(varchar,orf.FecE,103) as FecEmi, Convert(varchar,orf.FecEntR,103) as FecEntR, orf.Asunto ,est.Descrip
from ordfabricacion orf 
Left Join EstadoOF est on est.Id_EstOF = orf.Id_EstOF and est.IB_Activo=1
Where Cd_OF not in (select CdOF_BASE from ordfabricacion where CdOF_BASE is not null) and orf.RucE='''+@RucE+''' and orf.Id_EstOF = ''01'' or orf.Id_EstOF = ''03'' order by Cd_OF asc'
print @consulta
exec (@consulta)
END

END
print @msj
-- Leyenda --
-- FL : 22-02-2011 : <Creacion del procedimiento almacenado>
--exec dbo.Prd_OrdFabricacionConsPag '11111111111',5,null










GO
