SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Com_Compra_ConsXPrvOrd_1]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Ejer nvarchar(4),
@Colum nvarchar(15),
@msj varchar(100) output
as
declare @consulta varchar(8000)
set @consulta = '
select convert(bit, 0) as Sel,convert(Nvarchar,  co.FecMov,103) as FecMov,co.RegCtb, co.Cd_TD,co.NroSre,co.NroDoc,case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_Com as CodMov,  convert(Nvarchar,co.FecED,103) as FecED from Compra co
where co.RucE = '''+@RucE+''' and co.Cd_Prv = '''+@Cd_Prv+''' and IB_Anulado = 0 and co.Ejer<= '+@Ejer+'
order by '+ @Colum+' desc'
print @msj
print @consulta

exec (@consulta)


-- Leyenda --
-- CAM : 20/03/2013 : <Creacion del procedimiento almacenado>
--Pruebas:--exec user321.Com_Compra_ConsXPrvOrd '11111111111','PRV0001','2011','RegCtb', null
GO
