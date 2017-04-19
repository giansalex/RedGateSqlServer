SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptoDetracHistCons]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@msj varchar(100) output
as

if not exists (select top 1 *from ConceptoDetracHist where RucE=@RucE and Cd_CDtr=@Cd_CDtr)
		set @msj=''
else 
begin
		select Convert(nvarchar,FecVig,103) as FecVig,Porc,MtoDtr from ConceptoDetracHist
		where RucE=@RucE and Cd_CDtr=@Cd_CDtr
		order by FecVig
end
-- Leyenda --
-- JJ 05/02/2011 :<Creacion del procedimiento almacendo>
GO
