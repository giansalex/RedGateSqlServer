SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Prd_OrdFabricacionCons]
@RucE nvarchar(11),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN
set @EstaAut=0
IF(@EstaAut=1)
BEGIN
select orf.Cd_OF,orf.NroOF, Convert(varchar,orf.FecE,103) as FecEmi, Convert(varchar,orf.FecEntR,103) as FecEntR, orf.Asunto ,est.Descrip
from ordfabricacion orf 
Left Join EstadoOF est on est.Id_EstOF = orf.Id_EstOF and est.IB_Activo=1
Where IB_Aut=1 and Cd_OF not in (select CdOF_BASE from ordfabricacion where CdOF_BASE is not null) and orf.RucE=@RucE and orf.Id_EstOF = '01' or orf.Id_EstOF = '03' order by Cd_OF asc
END
ELSE IF(@EstaAut=0)
BEGIN
select orf.Cd_OF,orf.NroOF, Convert(varchar,orf.FecE,103) as FecEmi, Convert(varchar,orf.FecEntR,103) as FecEntR, orf.Asunto ,est.Descrip
from ordfabricacion orf 
Left Join EstadoOF est on est.Id_EstOF = orf.Id_EstOF and est.IB_Activo=1
Where Cd_OF not in (select CdOF_BASE from ordfabricacion where CdOF_BASE is not null) and orf.RucE=@RucE and orf.Id_EstOF = '01' or orf.Id_EstOF = '03' order by Cd_OF asc

END
END
print @msj
-- Leyenda --
-- FL : 26-02-2011 : <Creacion del procedimiento almacenado>
--exec dbo.Prd_OrdFabricacionCons '11111111111',null







GO
