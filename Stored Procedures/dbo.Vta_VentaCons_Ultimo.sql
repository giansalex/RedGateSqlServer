SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCons_Ultimo]
@RucE nvarchar(11),
@Eje nvarchar(4),
@msj varchar(100) output
as
declare @Cd_Vta nvarchar(10)
set @Cd_Vta = (select isnull(max(Cd_Vta),0) as Maximo from Venta where RucE=@RucE and Eje=@Eje)
if(@Cd_Vta = '0')
begin
	set @msj = 'No se encontraron Ventas registras'
	return
end
select ve.Cd_Vta,ve.Cd_TD,ve.NroSre as NroSerie,ve.NroDoc,ve.RegCtb from Venta ve--, Serie se 
where ve.RucE=@RucE and ve.Eje=@Eje and ve.Cd_Vta=@Cd_Vta --and ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
GO
