SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosCons]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'No se encontro Sub Sub Centro de Costos'
else	*/
begin
	if(@TipCons=0)
		select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC
	else if(@TipCons=1)
		select Cd_SS+'  |  '+Descrip as CodNom, Cd_SS,Descrip from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC
	else if(@TipCons=2)
		select Cd_SS, Cd_SS, NCorto,Descrip from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC -- and Estado=1
	else if(@TipCons=3)
		select Cd_SS, Cd_SS, Descrip from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC -- and Estado=1

end
print @msj

--PV: Jue 29/01/09
GO
