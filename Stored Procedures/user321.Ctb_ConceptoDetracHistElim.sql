SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptoDetracHistElim]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@FecVig smalldatetime,
@msj varchar(100) output
as
if not exists (select top 1 *from ConceptoDetracHist where RucE=@RucE and Cd_CDtr=@Cd_CDtr and Convert(varchar,FecVig,103)=Convert(varchar,@FecVig,103))
		set @msj='Historial de Detraccion no existe'
else
begin
		delete ConceptoDetracHist 
			where RucE=@RucE and Cd_CDtr=@Cd_CDtr
				and Convert(varchar,FecVig,103)=Convert(varchar,@FecVig,103)
end
GO
