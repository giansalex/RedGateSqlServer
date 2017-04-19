SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Prd_OrdFabricacionCons1]
@RucE nvarchar(11),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN
IF(@EstaAut=1)
BEGIN
select orf.Cd_OF,orf.NroOF, Convert(varchar,orf.FecE,103) as FecEmi, Convert(varchar,orf.FecEntR,103) as FecEntR, orf.Asunto ,est.Descrip
from ordfabricacion orf 
left Join EstadoOF est on est.Id_EstOF = orf.Id_EstOF and est.IB_Activo=1
Where ((IB_Aut=1 and TipAut!=0) or TipAut = 0 ) and Cd_OF not in (select CdOF_BASE from ordfabricacion where RucE=@RucE and CdOF_BASE is not null) and orf.RucE=@RucE and orf.Id_EstOF in('01','03')
order by orf.FecE desc  
END
ELSE IF(@EstaAut=0)
BEGIN
select orf.Cd_OF,orf.NroOF, Convert(varchar,orf.FecE,103) as FecEmi, Convert(varchar,orf.FecEntR,103) as FecEntR, orf.Asunto ,est.Descrip
from ordfabricacion orf 
Left Join EstadoOF est on est.Id_EstOF = orf.Id_EstOF and est.IB_Activo=1
Where Cd_OF not in (select CdOF_BASE from ordfabricacion where RucE=@RucE and CdOF_BASE is not null) and orf.RucE=@RucE and orf.Id_EstOF in('01','03')
order by orf.FecE desc
END
END
print @msj
-- Leyenda --
-- FL : 26-02-2011 : <Creacion del procedimiento almacenado>
--exec dbo.Prd_OrdFabricacionCons1 '11111111111',1,null
GO
