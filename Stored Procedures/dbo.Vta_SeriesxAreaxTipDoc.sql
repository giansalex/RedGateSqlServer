SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_SeriesxAreaxTipDoc]
@RucE nvarchar(11),
@Cd_Area nvarchar(12),
@Cd_TD nvarchar(4),
@msj varchar(100) output
as

/*
select * from TipDoc
01	Factura
03	Boleta de Venta
*/

select distinct sa.*, s.NroSerie from SeriesXArea sa 
inner join Serie s on sa.Cd_Sr = s.Cd_Sr
inner join Numeracion n on n.Cd_Sr = sa.Cd_Sr
where sa.RucE = @RucE and sa.Cd_Area = @Cd_Area
and sa.Cd_Sr in 
(
	select Cd_Sr from Serie where RucE = @RucE and Cd_TD = @Cd_TD
)

/*
--MP : 06/02/2012 : <Creacion del procedimiento almacenado>
exec Vta_SeriesxAreaxTipDoc '11111111111', '0001', '03', null
*/
GO
