SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @RucE nvarchar(11)
--declare @TipCons int
--declare @msj varchar(100)

--set @RucE = '20508840820'
--set @TipCons = 3
--set @msj = ''
CREATE procedure [dbo].[Gsp_TipProvCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as

--if not exists (	select top 1 * from tipProv tp
--				left join Proveedor2 p on tp.Cd_TPrv = p.Cd_TPrv
--				where p.RucE = @RucE)
--set @msj = 'No se encontro Tipos de Proveedor'
--else
begin
	if(@TipCons=0)
		 --select * from tipProv where RucE=@RucE
		select * from tipProv tp
		inner join Proveedor2 p on tp.Cd_TPrv = p.Cd_TPrv
		where p.RucE = @RucE

		
	else if(@TipCons=1)
	
		select tp.Cd_TPrv +'  |  '+ tp.Descrip as CodNom,tp.Cd_TPrv, tp.Descrip from tipProv tp
		inner join Proveedor2 p on tp.Cd_TPrv = p.Cd_TPrv
		where p.RucE = @RucE
		group by tp.Descrip, tp.Cd_TPrv ,tp.Cd_TPrv
		
	else if(@TipCons=2)--SOLO PARA LA PANTALLA DE Gfm_CCostos
	
		select tp.Cd_TPrv ,tp.Cd_TPrv, tp.Descrip from tipProv tp
		inner join Proveedor2 p on tp.Cd_TPrv = p.Cd_TPrv
		where p.RucE = @RucE
		group by tp.Descrip, tp.Cd_TPrv ,tp.Cd_TPrv
		
	else if(@TipCons=3)

		select tp.Cd_TPrv ,tp.Cd_TPrv, tp.Descrip from tipProv tp
		inner join Proveedor2 p on tp.Cd_TPrv = p.Cd_TPrv
		where p.RucE = @RucE
		group by tp.Descrip, tp.Cd_TPrv ,tp.Cd_TPrv
end
print @msj

--exec Gsp_TipProvCons '20508840820', 3, null
GO
