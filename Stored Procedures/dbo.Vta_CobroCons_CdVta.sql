SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CobroCons_CdVta]
@RucE nvarchar(11),
--@ItmCo int,
@Cd_Vta nvarchar(10),
--@Itm_BC nvarchar(10),
--@FecPag smalldatetime,
--@IC_TipPag varchar(1),
--@Cd_Mda nvarchar(2),
--@CamMda numeric(6,3),
--@Monto numeric (13,2),
@msj varchar(100) output
as
/*if not exists (select * from Cobro where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Error al eliminar cobro'
else*/
begin
	select 
		c.RucE, c.ItmCo, c.Cd_Vta, c.Itm_BC, c.FecPag, c.IC_TipPag, c.Cd_Mda, m.Nombre,
		c.CamMda, c.Monto
	from Cobro c, Moneda m
	where c.RucE=@RucE and c.Cd_Vta=@Cd_Vta and c.Cd_Mda=m.Cd_Mda
end
print @msj
GO
