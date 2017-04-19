SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosCons1]
@RucE nvarchar(11),
@Cd_CC varchar(8000),
@Cd_SC varchar(8000),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'No se encontro Sub Sub Centro de Costos'
else	*/
declare @Cons varchar(1000)
begin
	if(@TipCons=2)
		set @Cons='
		select Cd_CC, Cd_CC as Cd_CC1, Cd_SC, Cd_SC as Cd_SC1, Cd_SS, Cd_SS as Cd_SS1, 
		NCorto,Descrip from CCSubSub where RucE='''+@RucE+''' '
		--=@Cd_CC and Cd_SC=@Cd_SC 
end
print @msj
exec ('select *from ('+@Cons+'and Cd_CC in ('''+@Cd_CC+''')) as Cons
	  Where Cd_SC in('''+@Cd_SC+''')')

--PV: Jue 29/01/09
GO
